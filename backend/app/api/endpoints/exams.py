from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.schemas.exam import ExamRead, ExamCreate
from app.models.exam import Exam
from app.db.session import AsyncSessionLocal
from app.core.deps import require_role

router = APIRouter(prefix="/exams", tags=["Exams"])

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session

from app.schemas.exam_display import ExamDisplay
from app.models.user import User
from app.models.discipline import Discipline
from app.models.room import Room

@router.get("/", response_model=list[ExamDisplay])
async def list_exams(db: AsyncSession = Depends(get_db)):
    """
    List all exams with related discipline, teacher, assistants, and room.

    Args:
        db (AsyncSession): Database session dependency.

    Returns:
        list[ExamDisplay]: List of exams with expanded information.
    """
    # Fetch all exams with their related discipline, teacher, assistants, and room
    result = await db.execute(select(Exam))
    exams = result.scalars().all()
    exam_list = []
    for exam in exams:
        # Discipline name and specialization
        discipline_name = None
        specialization = None
        if exam.discipline_id:
            discipline = await db.get(Discipline, exam.discipline_id)
            discipline_name = discipline.name if discipline else None
            specialization = discipline.program if discipline else None
        # Teacher name
        teacher_name = None
        if exam.teacher_id:
            teacher = await db.get(User, exam.teacher_id)
            teacher_name = teacher.name if teacher else None
        # Assistants names
        assistant_names = []
        if exam.assistant_ids:
            for aid in exam.assistant_ids:
                user = await db.get(User, aid)
                if user:
                    assistant_names.append(user.name)
        # Room name
        room_name = None
        if exam.room_id:
            room = await db.get(Room, exam.room_id)
            room_name = room.name if room else None
        # Proposed by name
        proposed_by_name = None
        if exam.proposed_by:
            proposer = await db.get(User, exam.proposed_by)
            proposed_by_name = proposer.name if proposer else None
        exam_list.append(ExamDisplay(
            id=exam.id,
            discipline_name=discipline_name,
            specialization=specialization,
            proposed_by_name=proposed_by_name,
            proposed_date=exam.proposed_date.isoformat() if exam.proposed_date else None,
            confirmed_date=exam.confirmed_date.isoformat() if exam.confirmed_date else None,
            room_name=room_name,
            teacher_name=teacher_name,
            assistant_names=assistant_names,
            status=exam.status,
            group_name=exam.group_name,
        ))
    return exam_list

import os, json
from datetime import datetime

@router.post("/", response_model=ExamRead, status_code=201)
async def create_exam(
    item: ExamCreate,
    db: AsyncSession = Depends(get_db)
):
    # Load orar_usv.json
    orar_path = os.path.join(os.path.dirname(__file__), "..", "..", "static", "orar_usv.json")
    try:
        with open(orar_path, encoding="utf-8") as f:
            orar_data = json.load(f)
    except Exception as e:
        raise HTTPException(500, f"Could not load orar_usv.json: {e}")

    # Extract exam info
    new_start = datetime.fromisoformat(item.start_time)
    new_end = datetime.fromisoformat(item.end_time)
    new_group = item.group_name
    new_room = item.room_id
    new_teacher = item.teacher_id

    # Check for conflicts in orar_usv.json (structure must match API)
    for sched in orar_data.get("schedules", []):
        sched_start = datetime.fromisoformat(sched["start_time"])
        sched_end = datetime.fromisoformat(sched["end_time"])
        # Overlap check
        overlap = not (new_end <= sched_start or new_start >= sched_end)
        if overlap:
            if sched.get("group_name") == new_group:
                raise HTTPException(409, detail={"conflict": "group", "with": sched})
            if sched["room_id"] == new_room:
                raise HTTPException(409, detail={"conflict": "room", "with": sched})
            if sched["teacher_id"] == new_teacher:
                raise HTTPException(409, detail={"conflict": "teacher", "with": sched})
    # If no conflict, create exam
    exam_data = item.dict()
    exam_data.pop("start_time", None)
    exam_data.pop("end_time", None)
    # No role enforcement, just require group_name
    group_name = exam_data.get("group_name")
    if group_name is None or str(group_name).strip() == "" or str(group_name) == "None":
        raise HTTPException(422, "group_name is required for exam creation and must be a non-empty string and not 'None'")
    exam_data["group_name"] = str(group_name)
    # Defensive: never allow None or 'None' to be saved
    if exam_data["group_name"] is None or exam_data["group_name"] == "None":
        raise HTTPException(422, "group_name cannot be None or 'None'")
    db_item = Exam(**exam_data)
    db.add(db_item)
    await db.commit()
    await db.refresh(db_item)
    db_item.group_name = str(db_item.group_name)
    return db_item

@router.get("/{exam_id}", response_model=ExamRead)
async def get_exam(exam_id: int, db: AsyncSession = Depends(get_db)):
    item = await db.get(Exam, exam_id)
    if not item:
        raise HTTPException(404, "Exam not found")
    return item

@router.put("/{exam_id}", response_model=ExamRead)
async def update_exam(
    exam_id: int,
    item: dict,  # Accept dict to allow discipline_name
    db: AsyncSession = Depends(get_db)
):
    db_item = await db.get(Exam, exam_id)
    if not db_item:
        raise HTTPException(404, "Exam not found")

    update_data = dict(item)
    update_data.pop("start_time", None)
    update_data.pop("end_time", None)

    # Handle discipline_name → discipline_id
    discipline_name = update_data.pop("discipline_name", None)
    if discipline_name:
        discipline = await db.execute(select(Discipline).where(Discipline.name == discipline_name))
        discipline_obj = discipline.scalar_one_or_none()
        if not discipline_obj:
            raise HTTPException(422, f"Discipline with name '{discipline_name}' not found")
        update_data["discipline_id"] = discipline_obj.id

    # No role enforcement, just require group_name
    group_name = update_data.get("group_name")
    if group_name is None or str(group_name).strip() == "" or str(group_name) == "None":
        raise HTTPException(422, "group_name is required for exam update and must be a non-empty string and not 'None'")
    update_data["group_name"] = str(group_name)
    # Defensive: never allow None or 'None' to be saved
    if update_data["group_name"] is None or update_data["group_name"] == "None":
        raise HTTPException(422, "group_name cannot be None or 'None'")
    # Parse confirmed_date if present and is a string
    from datetime import datetime
    if "confirmed_date" in update_data and isinstance(update_data["confirmed_date"], str):
        try:
            update_data["confirmed_date"] = datetime.fromisoformat(update_data["confirmed_date"])
        except ValueError:
            raise HTTPException(422, "Invalid date format for confirmed_date. Use ISO format (YYYY-MM-DDTHH:MM:SS)")
    # --- PATCH: serialize assistant_ids to JSON string if needed (for current model) ---
    # NOTE: For robust solution, use a hybrid property in the Exam model.
    if isinstance(update_data.get("assistant_ids"), list):
        import json
        update_data["assistant_ids"] = json.dumps(update_data["assistant_ids"])
    for k, v in update_data.items():
        setattr(db_item, k, v)
    await db.commit()
    await db.refresh(db_item)
    db_item.group_name = str(db_item.group_name)
    return db_item

@router.post("/{exam_id}/approve", response_model=ExamRead)
async def approve_exam(
    exam_id: int,
    db: AsyncSession = Depends(get_db)
):
    db_item = await db.get(Exam, exam_id)
    if not db_item:
        raise HTTPException(404, "Exam not found")
    db_item.status = "approved"
    await db.commit()
    await db.refresh(db_item)
    return db_item

@router.post("/{exam_id}/reject", response_model=ExamRead)
async def reject_exam(
    exam_id: int,
    db: AsyncSession = Depends(get_db)
):
    db_item = await db.get(Exam, exam_id)
    if not db_item:
        raise HTTPException(404, "Exam not found")
    db_item.status = "rejected"
    await db.commit()
    await db.refresh(db_item)
    return db_item

@router.delete("/{exam_id}", status_code=204)
async def delete_exam(
    exam_id: int,
    db: AsyncSession = Depends(get_db)
):
    db_item = await db.get(Exam, exam_id)
    if not db_item:
        raise HTTPException(404, "Exam not found")
    await db.delete(db_item)
    await db.commit()
    return None
