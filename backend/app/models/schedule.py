from sqlalchemy import Column, Integer, String, ForeignKey, TIMESTAMP
from app.db.base import Base

class Schedule(Base):
    __tablename__ = "schedules"
    id = Column(Integer, primary_key=True, index=True)
    group_name = Column(String(20))
    room_id = Column(Integer, ForeignKey("rooms.id"))
    start_time = Column(TIMESTAMP)
    end_time = Column(TIMESTAMP)
    type = Column(String(20))
