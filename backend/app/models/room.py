from sqlalchemy import Column, Integer, String
from app.db.base import Base

class Room(Base):
    __tablename__ = "rooms"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50))
    building = Column(String(50))
    capacity = Column(Integer)
