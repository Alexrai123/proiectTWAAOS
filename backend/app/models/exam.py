from sqlalchemy import Column, Integer, String, ForeignKey, TIMESTAMP, ARRAY
from sqlalchemy.orm import relationship
from app.db.base import Base

class Exam(Base):
    __tablename__ = "exams"
    id = Column(Integer, primary_key=True, index=True)
    discipline_id = Column(Integer, ForeignKey("disciplines.id", ondelete="CASCADE"))
    proposed_by = Column(Integer, ForeignKey("users.id"))
    proposed_date = Column(TIMESTAMP)
    confirmed_date = Column(TIMESTAMP)
    room_id = Column(Integer, ForeignKey("rooms.id"))
    teacher_id = Column(Integer, ForeignKey("users.id"))
    # Postgres-native array for assistant_ids; use ARRAY(Integer)
    # NOTE: For SQLite compatibility, use a custom type or hybrid property if needed.
    from sqlalchemy.dialects.postgresql import ARRAY
    assistant_ids = Column(ARRAY(Integer))
    status = Column(String(20))
    group_name = Column(String(20), nullable=False, default="")

    # Relationships
    proposed_by_user = relationship("User", back_populates="proposed_exams", foreign_keys=[proposed_by])
    teacher = relationship("User", back_populates="taught_exams", foreign_keys=[teacher_id])
    discipline = relationship("Discipline")
    room = relationship("Room")

