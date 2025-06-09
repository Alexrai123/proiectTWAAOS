from fastapi import APIRouter, Depends, HTTPException, status, Body
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.schemas.user import UserRead, UserCreate, UserUpdate
from app.models.user import User
from app.db.session import AsyncSessionLocal
from app.core.deps import require_role
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordRequestForm

router = APIRouter(prefix="/users", tags=["Users"])

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session

# TEMPORARY DEBUG ENDPOINT
@router.get("/debug_list")
async def debug_list_users(db: AsyncSession = Depends(get_db)):
    from app.models.user import User
    result = await db.execute(select(User))
    users = result.scalars().all()
    return [{"id": u.id, "name": u.name, "email": u.email, "role": u.role} for u in users]

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)

@router.get("/", response_model=list[UserRead])
async def list_users(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role(["ADM"]))
):
    result = await db.execute(select(User))
    users = result.scalars().all()
    return users

@router.post("/", response_model=UserRead, status_code=201)
async def create_user(
    user: UserCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role(["ADM"]))
):
    db_user = User(name=user.name, email=user.email, role=user.role, is_active=True)
    db_user.password_hash = hash_password(user.password)
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    return db_user

@router.put("/me", response_model=UserRead)
async def edit_profile(
    name: str = Body(...),
    email: str = Body(...),
    current_user: User = Depends(require_role(["SG", "SEC", "CD", "ADM"])),
    db: AsyncSession = Depends(get_db)
):
    user = await db.get(User, current_user.id)
    user.name = name
    user.email = email
    await db.commit()
    await db.refresh(user)
    return user

@router.post("/change-password")
async def change_password(
    old_password: str = Body(...),
    new_password: str = Body(...),
    current_user: User = Depends(require_role(["SG", "SEC", "CD", "ADM"])),
    db: AsyncSession = Depends(get_db)
):
    user = await db.get(User, current_user.id)
    if not verify_password(old_password, user.password_hash):
        raise HTTPException(400, "Old password incorrect")
    user.password_hash = hash_password(new_password)
    await db.commit()
    return {"msg": "Password changed"}

@router.post("/{user_id}/reset-password")
async def reset_password(
    user_id: int,
    new_password: str = Body(...),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role(["ADM"]))
):
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(404, "User not found")
    user.password_hash = hash_password(new_password)
    await db.commit()
    return {"msg": "Password reset"}

@router.post("/{user_id}/activate")
async def activate_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role(["ADM"]))
):
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(404, "User not found")
    user.is_active = True
    await db.commit()
    return {"msg": "User activated"}

@router.post("/{user_id}/deactivate")
async def deactivate_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role(["ADM"]))
):
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(404, "User not found")
    user.is_active = False
    await db.commit()
    return {"msg": "User deactivated"}

@router.put("/{user_id}", response_model=UserRead)
async def update_user(
    user_id: int,
    update: UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role(["ADM"]))
):
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(404, "User not found")
    update_data = update.dict(exclude_unset=True)
    for k, v in update_data.items():
        setattr(user, k, v)
    await db.commit()
    await db.refresh(user)
    return user

@router.delete("/{user_id}")
async def delete_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role(["ADM"]))
):
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(404, "User not found")
    await db.delete(user)
    await db.commit()
    return {"msg": "User deleted"}
