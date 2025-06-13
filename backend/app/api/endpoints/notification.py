from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.notification import Notification
from app.schemas.notification import NotificationRead
from app.db.session import AsyncSessionLocal
from app.core.deps import require_role
from typing import List

router = APIRouter(prefix="/notifications", tags=["Notifications"])

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session

from app.models.user import User

@router.get("/unseen", response_model=List[NotificationRead])
async def get_unseen_notifications(user_email: str, db: AsyncSession = Depends(get_db)):
    user_result = await db.execute(select(User).where(User.email == user_email))
    user = user_result.scalar_one_or_none()
    if not user:
        raise HTTPException(404, "User not found")
    result = await db.execute(select(Notification).where(Notification.user_id == user.id, Notification.seen == False))
    notifications = result.scalars().all()
    return notifications

from pydantic import BaseModel

class MarkReadRequest(BaseModel):
    user_email: str

@router.post("/mark_read")
async def mark_notifications_read(payload: MarkReadRequest, db: AsyncSession = Depends(get_db)):
    user_result = await db.execute(select(User).where(User.email == payload.user_email))
    user = user_result.scalar_one_or_none()
    if not user:
        raise HTTPException(404, "User not found")
    result = await db.execute(select(Notification).where(Notification.user_id == user.id, Notification.seen == False))
    notifications = result.scalars().all()
    for notif in notifications:
        notif.seen = True
    await db.commit()
    return {"status": "ok"}
