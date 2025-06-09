import sys
import asyncio
if sys.platform == "win32":
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

import os
import pytest
import pytest_asyncio
import uuid
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text
from sqlalchemy.pool import NullPool
from app.main import FastAPI
from app.api.endpoints import users, auth, disciplines, rooms, exams, import_export

# Enforce sequential test execution
os.environ['PYTEST_DISABLE_PLUGIN_AUTOLOAD'] = '1'

def pytest_configure(config):
    if hasattr(config, 'workerinput'):
        raise RuntimeError("Test parallelism is not allowed. Please run pytest without -n or xdist.")

@pytest_asyncio.fixture(scope="function")
async def isolated_app_and_db():
    """
    Creates a fresh FastAPI app and SQLAlchemy engine/sessionmaker for each test, using a unique test DB.
    """
    # Generate a unique DB name for this test
    base_url = os.environ.get("DATABASE_URL", "postgresql+asyncpg://postgres:postgres@localhost:5432/twaaos_sic")
    # Patch to use psycopg async driver for tests
    base_url = base_url.replace("+asyncpg", "+psycopg")
    test_db_name = f"twaaos_test_{uuid.uuid4().hex[:8]}"
    admin_url = base_url.rsplit('/', 1)[0] + "/postgres"
    test_url = base_url.rsplit('/', 1)[0] + f"/{test_db_name}"

    # Create/drop test DB using admin connection (SYNC engine, AUTOCOMMIT)
    from sqlalchemy import create_engine as create_sync_engine
    admin_url = base_url.rsplit("/", 1)[0] + "/postgres"
    admin_sync_engine = create_sync_engine(admin_url, isolation_level="AUTOCOMMIT")
    with admin_sync_engine.connect() as conn:
        conn.execute(text(f"DROP DATABASE IF EXISTS {test_db_name}"))
        conn.execute(text(f"CREATE DATABASE {test_db_name} ENCODING 'utf8' TEMPLATE template1"))
    admin_sync_engine.dispose()

    # Create a new engine/sessionmaker for this test DB
    engine = create_async_engine(test_url, echo=False, future=True, poolclass=NullPool)
    TestingSessionLocal = sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)

    # Create all tables
    from app.db.base import Base
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    # Patch get_db dependency to use this sessionmaker
    async def override_get_db():
        async with TestingSessionLocal() as session:
            yield session

    app = FastAPI()
    # Ensure test endpoint is available: import import_export AFTER PYTEST_CURRENT_TEST is set
    os.environ["PYTEST_CURRENT_TEST"] = "1"
    from app.api.endpoints import import_export  # re-import to trigger test endpoint registration
    app.include_router(users.router)
    app.include_router(auth.router)
    app.include_router(disciplines.router)
    app.include_router(rooms.router)
    app.include_router(exams.router)
    app.include_router(import_export.router)

    # Programmatically add /import_export/test_export/pdf endpoint for tests
    if os.environ.get("PYTEST_CURRENT_TEST"):
        from fastapi import Response
        from fpdf import FPDF
        from sqlalchemy import create_engine
        from app.models.exam import Exam
        from sqlalchemy.future import select
        @app.get("/import_export/test_export/pdf")
        def test_export_pdf(type: str, token: str = ""):
            if type != "exams":
                from fastapi import HTTPException
                raise HTTPException(status_code=400, detail="Only exams export supported in test endpoint.")
            db_url = os.environ.get("DATABASE_URL", "postgresql://postgres:postgres@localhost:5432/twaaos_sic").replace("+asyncpg", "")
            engine = create_engine(db_url, echo=False, future=True)
            SessionLocal = sessionmaker(bind=engine)
            with SessionLocal() as sync_db:
                q = sync_db.execute(select(Exam))
                all_exams = list(q.scalars())
                exam_dicts = []
                for e in all_exams:
                    exam_dicts.append({
                        "id": e.id,
                        "discipline_id": e.discipline_id,
                        "proposed_by": e.proposed_by,
                        "proposed_date": e.proposed_date,
                        "confirmed_date": e.confirmed_date,
                        "room_id": e.room_id,
                        "teacher_id": e.teacher_id,
                        "assistant_ids": str(e.assistant_ids),
                        "status": e.status,
                        "group_id": getattr(e, "group_id", None),
                    })
            headers = [
                "ID", "Discipline", "Proposed By", "Proposed Date", "Confirmed Date", "Room", "Teacher", "Assistants", "Status"
            ]
            pdf = FPDF()
            pdf.add_page()
            pdf.set_font("Arial", size=12)
            for header in headers:
                pdf.cell(30, 10, header, 1)
            pdf.ln()
            for ex in exam_dicts:
                row = [
                    str(ex["id"]), str(ex["discipline_id"]), str(ex["proposed_by"]), str(ex["proposed_date"]),
                    str(ex["confirmed_date"]), str(ex["room_id"]), str(ex["teacher_id"]), str(ex["assistant_ids"]), str(ex["status"])
                ]
                for item in row:
                    pdf.cell(30, 10, item, 1)
                pdf.ln()
            pdf_bytes = pdf.output(dest="S").encode("latin1")
            return Response(pdf_bytes, media_type="application/pdf", headers={"Content-Disposition": "attachment; filename=exams.pdf"})

    app.dependency_overrides = {}
    for module in [users, auth, disciplines, rooms, exams, import_export]:
        if hasattr(module, 'get_db'):
            app.dependency_overrides[module.get_db] = override_get_db

    yield app, engine

    # Teardown: drop DB and dispose engine
    await engine.dispose()
    from sqlalchemy import create_engine as create_sync_engine
    admin_sync_engine = create_sync_engine(admin_url, isolation_level="AUTOCOMMIT")
    with admin_sync_engine.connect() as conn:
        conn.execute(text(f"DROP DATABASE IF EXISTS {test_db_name}"))
    admin_sync_engine.dispose()

import pytest_asyncio

@pytest_asyncio.fixture(scope="function")
async def async_client(isolated_app_and_db):
    app, engine = isolated_app_and_db
    ac = AsyncClient(transport=ASGITransport(app=app), base_url="http://test")
    yield ac
    await ac.aclose()

from jose import jwt
from app.core.deps import SECRET_KEY, ALGORITHM
from datetime import datetime, timedelta
import pytest_asyncio

@pytest_asyncio.fixture
def sg_token():
    def _token(group="A", user_id=100):
        payload = {"sub": str(user_id), "role": "SG", "group_name": group}
        return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return _token

@pytest_asyncio.fixture
def sec_token():
    def _token(user_id=101):
        payload = {"sub": str(user_id), "role": "SEC"}
        return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return _token

@pytest_asyncio.fixture
def adm_token():
    def _token(user_id=102):
        payload = {"sub": str(user_id), "role": "ADM"}
        return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return _token

@pytest_asyncio.fixture
def user_factory(async_client, adm_token):
    async def _factory(role="SG", group_name="A", token=None, **kwargs):
        data = {"username": f"user_{role}_{group_name}", "password": "pw", "role": role, "full_name": f"User {role}", "name": f"User {role}", "email": f"user_{role}_{group_name}@x.com", "group_name": group_name}
        data.update(kwargs)
        headers = {"Authorization": f"Bearer {token or adm_token()}"}
        resp = await async_client.post("/users/", json=data, headers=headers)
        assert resp.status_code in (200, 201), resp.text
        return resp.json()
    return _factory

@pytest_asyncio.fixture
def discipline_factory(async_client, adm_token):
    async def _factory(group_name="A", token=None, **kwargs):
        if not group_name or group_name == "None":
            group_name = "A"
        data = {"name": f"Disc_{group_name}", "program": "SCI", "year": 1, "group_name": group_name}
        data.update(kwargs)
        headers = {"Authorization": f"Bearer {token or adm_token()}"}
        resp = await async_client.post("/disciplines/", json=data, headers=headers)
        assert resp.status_code in (200, 201), resp.text
        return resp.json()
    return _factory

@pytest_asyncio.fixture
def exam_factory(async_client, adm_token):
    async def _factory(discipline_id, group_name="A", token=None, proposed_by=None, **kwargs):
        # Strict normalization: always use a valid group_name
        if not group_name or str(group_name).strip() == "" or str(group_name) == "None":
            group_name = "A"
        # Ensure Room with id=1 exists
        room_resp = await async_client.post(
            "/rooms/",
            json={"id": 1, "name": "Room 1", "capacity": 30},
            headers={"Authorization": f"Bearer {adm_token()}"}
        )
        assert room_resp.status_code in (200, 201, 409), room_resp.text  # 409 if already exists

        # Determine SG user id if token is SG
        sg_user_id = None
        if token and callable(token):
            # Use the group_name and a fixed id or allow override
            import uuid
            sg_user_uuid = uuid.uuid4().int & (1<<31)-1
            sg_user_id = proposed_by if proposed_by is not None else sg_user_uuid
            # group_name is already normalized above
            sg_user_email = f"sg_{sg_user_id}_{uuid.uuid4().hex[:8]}@x.com"
            print('[DEBUG] SG user creation payload:', group_name, proposed_by)
            user_payload = {
                "id": sg_user_id,
                "username": f"sg_{sg_user_id}",
                "password": "pw",
                "role": "SG",
                "group_name": group_name,
                "name": f"SG User {sg_user_id}",
                "full_name": f"SG User {sg_user_id}",
                "email": sg_user_email
            }
            user_resp = await async_client.post(
                "/users/",
                json=user_payload,
                headers={"Authorization": f"Bearer {adm_token()}"}
            )
            if user_resp.status_code not in (200, 201, 409):
                print("SG user creation failed:", user_payload, user_resp.status_code, user_resp.text)
            assert user_resp.status_code in (200, 201, 409), user_resp.text
            # Use the created user's id as proposed_by
            if user_resp.status_code in (200, 201):
                sg_user_id_created = user_resp.json().get("id")
                data_proposed_by = sg_user_id_created
            else:
                # fallback: use original sg_user_id if user already exists
                data_proposed_by = sg_user_id
        else:
            data_proposed_by = proposed_by if proposed_by is not None else 1

        # Ensure User with id=1 (teacher) exists for teacher_id FK
        if not group_name or group_name == "None":
            group_name = "A"
        import uuid
        teacher_email = f"teacher_{uuid.uuid4().hex[:8]}@x.com"
        teacher_username = f"teacher_{uuid.uuid4().hex[:8]}"
        teacher_payload = {
            "username": teacher_username,
            "password": "pw",
            "role": "SEC",
            "full_name": "Teacher 1",
            "name": "Teacher 1",
            "email": teacher_email,
            "group_name": group_name
        }
        user_resp = await async_client.post(
            "/users/",
            json=teacher_payload,
            headers={"Authorization": f"Bearer {adm_token()}"}
        )
        print(f"[DEBUG FACTORY] Teacher creation response: {user_resp.status_code} {user_resp.text}")
        if user_resp.status_code not in (200, 201, 409):
            print("Teacher user creation failed:", teacher_payload, user_resp.status_code, user_resp.text)
        assert user_resp.status_code in (200, 201, 409), user_resp.text  # 409 if already exists
        teacher_id = user_resp.json().get("id") if user_resp.status_code in (200, 201) else 1
        if user_resp.status_code == 409:
            teacher_id = 1  # fallback (legacy)
        print(f"[DEBUG FACTORY] Using teacher_id={teacher_id}")

        data = {
            "discipline_id": discipline_id,
            "start_time": (datetime.now() + timedelta(days=1)).isoformat(),
            "end_time": (datetime.now() + timedelta(days=1, hours=2)).isoformat(),
            "room_id": 1,
            "teacher_id": teacher_id,
            "status": "scheduled",
            "group_name": group_name,
            "proposed_by": data_proposed_by
        }
        data.update(kwargs)
        # Normalize again after update
        if data.get('group_name') is None or data.get('group_name') == 'None':
            print('[DEBUG] data["group_name"] was None or "None" after kwargs, normalizing to "A"')
            data['group_name'] = 'A'
        # Use SG token if token is provided and role is SG
        if token and callable(token):
            jwt_token = token(group=group_name, user_id=data_proposed_by)
            print('[DEBUG] SG JWT payload:', group_name, data_proposed_by)
            headers = {"Authorization": f"Bearer {jwt_token}"}
        else:
            headers = {"Authorization": f"Bearer {token or adm_token()}"}
        print(f"[DEBUG] Creating exam with group_name={data['group_name']}, proposed_by={data['proposed_by']}")
        try:
            resp = await async_client.post("/exams/", json=data, headers=headers)
            if resp.status_code not in (200, 201):
                print("Exam creation failed:", data, resp.status_code, resp.text)
            assert resp.status_code in (200, 201), resp.text
            return resp.json()
        except Exception as e:
            import traceback
            print("[EXCEPTION] Exam creation:", e)
            traceback.print_exc()
            raise
    return _factory
