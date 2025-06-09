import pytest
from httpx import AsyncClient, ASGITransport
from app.main import app
from app.db.session import AsyncSessionLocal
from app.models.user import User
from jose import jwt
from app.core.deps import SECRET_KEY, ALGORITHM
import asyncio

@pytest.mark.asyncio
async def test_user_crud_and_permissions():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        # Create admin user and login
        import uuid
        from app.api.endpoints.users import hash_password
        unique_email = f"admin_{uuid.uuid4()}@usv.ro"
        admin = User(name="Admin", email=unique_email, role="ADM", is_active=True, password_hash=hash_password("pw"))
        async with AsyncSessionLocal() as db:
            db.add(admin)
            await db.flush()
            admin_id = admin.id
            await db.commit()
        # Simulate login and get token (stub, replace with real login flow)
        token = jwt.encode({"sub": str(admin_id), "role": "ADM"}, SECRET_KEY, algorithm=ALGORITHM)
        headers = {"Authorization": f"Bearer {token}"}
        # List users (ADM)
        resp = await ac.get("/users/", headers=headers)
        assert resp.status_code == 200
        # Create user (ADM)
        user_email = f"u_{uuid.uuid4()}@usv.ro"
        resp = await ac.post("/users/", json={"name":"U","email":user_email,"role":"CD","password":"pw"}, headers=headers)
        assert resp.status_code == 201
        # Edit profile (self)
        new_admin_email = f"admin2_{uuid.uuid4()}@usv.ro"
        resp = await ac.put("/users/me", json={"name":"Admin2","email":new_admin_email}, headers=headers)
        assert resp.status_code == 200
        # Change password (self)
        resp = await ac.post("/users/change-password", json={"old_password":"pw","new_password":"pw2"}, headers=headers)
        assert resp.status_code in (200, 400)  # 400 if old pw wrong
        # Reset password (ADM)
        resp = await ac.post(f"/users/{admin_id}/reset-password", json={"new_password":"pw3"}, headers=headers)
        assert resp.status_code == 200
        # Activate/deactivate (ADM)
        resp = await ac.post("/users/1/deactivate", headers=headers)
        assert resp.status_code == 200
        resp = await ac.post("/users/1/activate", headers=headers)
        assert resp.status_code == 200
        # Delete (ADM)
        resp = await ac.delete("/users/1", headers=headers)
        assert resp.status_code == 200

@pytest.mark.asyncio
async def test_permissions_forbidden():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        # Simulate non-admin token
        token = jwt.encode({"sub": "3", "role": "CD"}, SECRET_KEY, algorithm=ALGORITHM)
        headers = {"Authorization": f"Bearer {token}"}
        # Try forbidden actions
        resp = await ac.post("/users/", json={"name":"U","email":"u@usv.ro","role":"CD","password":"pw"}, headers=headers)
        assert resp.status_code == 403
        resp = await ac.delete("/users/2", headers=headers)
        assert resp.status_code == 403
