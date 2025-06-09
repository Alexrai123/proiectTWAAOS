from pydantic import BaseModel
from typing import Optional, List

from pydantic import validator
class ExamBase(BaseModel):
    discipline_id: int
    proposed_by: Optional[int] = None
    proposed_date: Optional[str] = None
    confirmed_date: Optional[str] = None
    room_id: Optional[int] = None
    teacher_id: Optional[int] = None
    assistant_ids: Optional[List[int]] = None
    status: str
    start_time: Optional[str] = None
    end_time: Optional[str] = None
    group_name: Optional[str] = None

    @validator('proposed_date', 'confirmed_date', pre=True, always=True)
    def datetime_to_iso(cls, v):
        if isinstance(v, str) or v is None:
            return v
        return v.isoformat()

    @validator('assistant_ids', pre=True)
    def empty_string_to_none_or_list(cls, v):
        if v == "":
            return None  # or return [] if you prefer empty list
        return v


class ExamCreate(ExamBase):
    pass

class ExamRead(ExamBase):
    id: int
    group_name: str
    class Config:
        orm_mode = True
