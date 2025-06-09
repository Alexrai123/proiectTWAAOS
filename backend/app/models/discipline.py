from sqlalchemy import Column, Integer, String
from app.db.base import Base

class Discipline(Base):
    __tablename__ = "disciplines"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    program = Column(String(50))
    year = Column(Integer)
    group_name = Column(String(20))
