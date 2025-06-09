from fastapi import APIRouter, HTTPException, status, Depends
from app.schemas.auth import LoginRequest, Token
from app.models.user import User
from app.db.session import AsyncSessionLocal
from sqlalchemy.future import select
from jose import jwt
from passlib.context import CryptContext
import os

SECRET_KEY = os.getenv("SECRET_KEY", "devsecret")
ALGORITHM = "HS256"

router = APIRouter(prefix="/auth", tags=["Auth"])

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

@router.post("/login", response_model=Token)
async def login(data: LoginRequest, db=Depends(get_db)):
    q = await db.execute(select(User).where(User.email == data.email))
    user = q.scalar_one_or_none()
    if not user or (not pwd_context.verify(data.password, user.password_hash)):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    # Minimal JWT token creation
    token_data = {"sub": user.email, "role": user.role}
    token = jwt.encode(token_data, SECRET_KEY, algorithm=ALGORITHM)
    return {"access_token": token, "token_type": "bearer", "expires_in": 3600}
