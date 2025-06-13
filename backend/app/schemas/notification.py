from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class NotificationBase(BaseModel):
    user_id: int
    exam_id: Optional[int] = None
    message: str
    created_at: Optional[datetime] = None
    seen: Optional[bool] = False
    seen_at: Optional[datetime] = None

class NotificationRead(NotificationBase):
    id: int
    class Config:
        orm_mode = True
