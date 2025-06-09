from pydantic import BaseModel
from typing import Optional

class RoomBase(BaseModel):
    name: str
    building: Optional[str] = None
    capacity: Optional[int] = None

class RoomCreate(RoomBase):
    pass

class RoomRead(RoomBase):
    id: int
    class Config:
        orm_mode = True
