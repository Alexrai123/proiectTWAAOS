import pytest
from httpx import AsyncClient
from app.main import app
from app.models.exam import Exam
from app.models.user import User
from app.db.session import AsyncSessionLocal
from jose import jwt
from app.core.deps import SECRET_KEY, ALGORITHM
from datetime import datetime, timedelta

pytestmark = pytest.mark.asyncio

# Helper to create JWT for a user with role

def make_token(user_id, role, group_name=None):
    payload = {"sub": str(user_id), "role": role}
    if group_name:
        payload["group_name"] = group_name
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

# NOTE: For robust solution, patch Exam model to use a hybrid property for assistant_ids
# that serializes/deserializes JSON automatically between DB and Python list.
# The current happy-path test expects assistant_ids to be a list, but the model stores it as a string.
# This test will only pass if the backend endpoint or model handles this conversion.
@pytest.fixture
def exam_payload():
    return {
        "discipline_id": 1,
        "proposed_by": 1,
        "proposed_date": datetime.now().isoformat(),
        # Omit confirmed_date; backend sets it on approval
        "room_id": 1,
        "teacher_id": 2,
        "assistant_ids": [],  # Send as list; robust fix needed in model
        "group_name": "A1",
        "status": "pending",
        "start_time": (datetime.now() + timedelta(days=1)).isoformat(),
        "end_time": (datetime.now() + timedelta(days=1, hours=2)).isoformat(),
    }

async def create_user(db, name, email, role, group_name=None):
    user = User(name=name, email=email, role=role, is_active=True)
    db.add(user)
    await db.flush()
    if group_name:
        user.group_name = group_name
    await db.commit()
    await db.refresh(user)
    return user

import uuid
async def test_exam_crud_and_status(exam_payload):
    async with AsyncSessionLocal() as db:
        # Generate unique emails
        sg_email = f"sg_{uuid.uuid4()}@usv.ro"
        cd_email = f"cd_{uuid.uuid4()}@usv.ro"
        sec_email = f"sec_{uuid.uuid4()}@usv.ro"
        adm_email = f"adm_{uuid.uuid4()}@usv.ro"
        # Create users
        sg = await create_user(db, "SG", sg_email, "SG", group_name="A1")
        cd = await create_user(db, "CD", cd_email, "CD")
        sec = await create_user(db, "SEC", sec_email, "SEC")
        adm = await create_user(db, "ADM", adm_email, "ADM")
    # Tokens
    sg_token = make_token(sg.id, "SG", group_name="A1")
    cd_token = make_token(cd.id, "CD")
    sec_token = make_token(sec.id, "SEC")
    adm_token = make_token(adm.id, "ADM")

    from httpx import ASGITransport
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        # SG creates exam for their group
        headers = {"Authorization": f"Bearer {sg_token}"}
        resp = await ac.post("/exams/", json={**exam_payload, "group_name": "A1", "proposed_by": sg.id, "teacher_id": cd.id}, headers=headers)
        assert resp.status_code == 201, resp.text
        exam = resp.json()
        exam_id = exam["id"]
        # SG can update their own exam
        resp = await ac.put(f"/exams/{exam_id}", json={**exam_payload, "group_name": "A1", "proposed_by": sg.id, "teacher_id": cd.id}, headers=headers)
        assert resp.status_code == 200
        # SG can delete their own exam
        resp = await ac.delete(f"/exams/{exam_id}", headers=headers)
        assert resp.status_code == 204
        # SEC creates new exam
        headers = {"Authorization": f"Bearer {sec_token}"}
        resp = await ac.post("/exams/", json={**exam_payload, "group_name": "A1", "proposed_by": sec.id, "teacher_id": cd.id}, headers=headers)
        assert resp.status_code == 201
        exam = resp.json()
        exam_id = exam["id"]
        # CD approves exam
        headers = {"Authorization": f"Bearer {cd_token}"}
        resp = await ac.post(f"/exams/{exam_id}/approve", headers=headers)
        assert resp.status_code == 200
        assert resp.json()["status"] == "approved"
        # CD rejects exam
        resp = await ac.post(f"/exams/{exam_id}/reject", headers=headers)
        assert resp.status_code == 200
        assert resp.json()["status"] == "rejected"
        # ADM deletes exam
        headers = {"Authorization": f"Bearer {adm_token}"}
        resp = await ac.delete(f"/exams/{exam_id}", headers=headers)
        assert resp.status_code == 204
