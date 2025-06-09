from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.schemas.room import RoomRead, RoomCreate
from app.models.room import Room
from app.db.session import AsyncSessionLocal
from app.core.deps import require_role

router = APIRouter(prefix="/rooms", tags=["Rooms"])

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session

@router.get("/", response_model=list[RoomRead])
async def list_rooms(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Room))
    return result.scalars().all()

@router.post("/", response_model=RoomRead, status_code=201)
async def create_room(
    item: RoomCreate,
    db: AsyncSession = Depends(get_db),
    current_user = Depends(require_role(["ADM"]))
):
    db_item = Room(**item.dict())
    db.add(db_item)
    await db.commit()
    await db.refresh(db_item)
    return db_item

@router.get("/{room_id}", response_model=RoomRead)
async def get_room(room_id: int, db: AsyncSession = Depends(get_db)):
    item = await db.get(Room, room_id)
    if not item:
        raise HTTPException(404, "Room not found")
    return item

@router.put("/{room_id}", response_model=RoomRead)
async def update_room(
    room_id: int,
    item: RoomCreate,
    db: AsyncSession = Depends(get_db),
    current_user = Depends(require_role(["ADM"]))
):
    db_item = await db.get(Room, room_id)
    if not db_item:
        raise HTTPException(404, "Room not found")
    for k, v in item.dict().items():
        setattr(db_item, k, v)
    await db.commit()
    await db.refresh(db_item)
    return db_item

@router.delete("/{room_id}", status_code=204)
async def delete_room(
    room_id: int,
    db: AsyncSession = Depends(get_db),
    current_user = Depends(require_role(["ADM"]))
):
    db_item = await db.get(Room, room_id)
    if not db_item:
        raise HTTPException(404, "Room not found")
    await db.delete(db_item)
    await db.commit()
    return None
