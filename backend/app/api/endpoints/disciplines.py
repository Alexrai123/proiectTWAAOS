from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.schemas.discipline import DisciplineRead, DisciplineCreate
from app.models.discipline import Discipline
from app.db.session import AsyncSessionLocal
from app.core.deps import require_role

router = APIRouter(prefix="/disciplines", tags=["Disciplines"])

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session

@router.get("/", response_model=list[DisciplineRead])
async def list_disciplines(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Discipline))
    return result.scalars().all()

@router.post("/", response_model=DisciplineRead, status_code=201)
async def create_discipline(
    item: DisciplineCreate,
    db: AsyncSession = Depends(get_db),
    current_user = Depends(require_role(["ADM", "SEC"]))
):
    db_item = Discipline(**item.dict())
    db.add(db_item)
    await db.commit()
    await db.refresh(db_item)
    return db_item

@router.get("/{discipline_id}", response_model=DisciplineRead)
async def get_discipline(discipline_id: int, db: AsyncSession = Depends(get_db)):
    item = await db.get(Discipline, discipline_id)
    if not item:
        raise HTTPException(404, "Discipline not found")
    return item

@router.put("/{discipline_id}", response_model=DisciplineRead)
async def update_discipline(
    discipline_id: int,
    item: DisciplineCreate,
    db: AsyncSession = Depends(get_db),
    current_user = Depends(require_role(["ADM", "SEC"]))
):
    raise HTTPException(status_code=403, detail="Editing disciplines is disabled.")

@router.delete("/{discipline_id}", status_code=204)
async def delete_discipline(
    discipline_id: int,
    db: AsyncSession = Depends(get_db),
    current_user = Depends(require_role(["ADM", "SEC"]))
):
    db_item = await db.get(Discipline, discipline_id)
    if not db_item:
        raise HTTPException(404, "Discipline not found")
    await db.delete(db_item)
    await db.commit()
    return None
