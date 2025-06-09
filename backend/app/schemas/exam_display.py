from pydantic import BaseModel
from typing import List, Optional

class ExamDisplay(BaseModel):
    id: int
    discipline_name: str
    specialization: Optional[str] = None
    proposed_by_name: Optional[str] = None
    proposed_date: Optional[str] = None
    confirmed_date: Optional[str] = None
    room_name: Optional[str] = None
    teacher_name: Optional[str] = None
    assistant_names: Optional[List[str]] = None
    status: str
    group_name: str

    class Config:
        orm_mode = True
