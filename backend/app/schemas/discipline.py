from pydantic import BaseModel
from typing import Optional

class DisciplineBase(BaseModel):
    name: str
    program: Optional[str] = None
    year: Optional[int] = None
    group_name: Optional[str] = None

class DisciplineCreate(DisciplineBase):
    pass

class DisciplineRead(DisciplineBase):
    id: int
    class Config:
        orm_mode = True
