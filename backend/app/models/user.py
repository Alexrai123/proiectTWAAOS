from sqlalchemy import Column, Integer, String, Boolean, Text, CheckConstraint
from sqlalchemy.orm import relationship
from app.db.base import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False, index=True)
    role = Column(String(10), nullable=False)
    password_hash = Column(Text)
    is_active = Column(Boolean, default=True)
    group_name = Column(String(20))

    # Relationships
    proposed_exams = relationship("Exam", back_populates="proposed_by_user", foreign_keys="Exam.proposed_by")
    taught_exams = relationship("Exam", back_populates="teacher", foreign_keys="Exam.teacher_id")
