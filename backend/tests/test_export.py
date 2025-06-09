import pytest
from httpx import AsyncClient, ASGITransport
from jose import jwt
from app.core.deps import SECRET_KEY, ALGORITHM
import asyncio

def make_token(user_id, role):
    return jwt.encode({"sub": str(user_id), "role": role}, SECRET_KEY, algorithm=ALGORITHM)

ROLES = [
    ("ADM", make_token(1, "ADM")),
    ("SEC", make_token(2, "SEC")),
    ("CD", make_token(3, "CD")),
    ("SG", make_token(4, "SG")),
]

EXPORT_TYPES = ["exams", "disciplines", "rooms", "users", "schedules"]

import os

@pytest.mark.asyncio
@pytest.mark.parametrize("role,token", ROLES)
@pytest.mark.parametrize("export_type", EXPORT_TYPES)
async def test_export_pdf_permissions(role, token, export_type, async_client):
    headers = {"Authorization": f"Bearer {token}"}
    if os.environ.get("PYTEST_CURRENT_TEST") and export_type == "exams":
        url = f"/import_export/test_export/pdf?type={export_type}"
    else:
        url = f"/import_export/export/pdf?type={export_type}"
    resp = await async_client.get(url, headers=headers)
    # ADM/SEC: all, CD: only exams/schedules, SG: only exams/schedules
    if export_type == "users" and role not in ("ADM", "SEC"):
        assert resp.status_code == 403
    elif export_type in ("disciplines", "rooms") and role in ("CD", "SG"):
        assert resp.status_code == 403
    elif export_type == "schedules" and role not in ("ADM", "SEC", "CD", "SG"):
        assert resp.status_code == 403
    else:
        assert resp.status_code == 200
        assert resp.headers["content-type"] == "application/pdf"

@pytest.mark.asyncio
async def test_export_pdf_unauthenticated(async_client):
    for export_type in EXPORT_TYPES:
        url = f"/import_export/export/pdf?type={export_type}"
        resp = await async_client.get(url)
        assert resp.status_code == 401 or resp.status_code == 403

# Excel export tests
@pytest.mark.asyncio
@pytest.mark.parametrize("role,token", ROLES)
@pytest.mark.parametrize("export_type", EXPORT_TYPES)
async def test_export_excel_permissions(role, token, export_type, async_client):
    headers = {"Authorization": f"Bearer {token}"}
    url = f"/import_export/export/excel?type={export_type}"
    resp = await async_client.get(url, headers=headers)
    # ADM/SEC: all, CD/SG: only exams, schedules
    if export_type == "users" and role not in ("ADM", "SEC"):
        assert resp.status_code == 403
    elif export_type not in ("exams", "schedules") and role in ("CD", "SG"):
        assert resp.status_code == 403
    else:
        assert resp.status_code == 200
        assert resp.headers["content-type"] == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

@pytest.mark.asyncio
async def test_export_excel_unauthenticated(async_client):
    for export_type in EXPORT_TYPES:
        url = f"/import_export/export/excel?type={export_type}"
        resp = await async_client.get(url)
        assert resp.status_code == 401 or resp.status_code == 403
