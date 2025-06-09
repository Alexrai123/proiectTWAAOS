from fastapi import Depends, HTTPException, status
from jose import jwt, JWTError
from fastapi.security import OAuth2PasswordBearer
from typing import Optional
import os

SECRET_KEY = os.getenv("SECRET_KEY", "devsecret")
ALGORITHM = "HS256"
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")

# Role-based access dependency factory
from app.models.user import User
from app.db.session import AsyncSessionLocal
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

# Returns a dependency function for FastAPI
def require_role(required_roles: list[str]):
    def dependency(token: str = Depends(oauth2_scheme)):
        try:
            payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
            role = payload.get("role")
            user_id = payload.get("sub")
            if role not in required_roles:
                raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Insufficient permissions")
            if not user_id:
                raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Missing user id in token")
            # Accept both integer and email as user_id
            try:
                user_id_int = int(user_id)
                user = User(id=user_id_int, role=role)
            except (ValueError, TypeError):
                user = User(id=None, email=user_id if "@" in str(user_id) else None, role=role)
            # Patch: set group_name for SG users from JWT
            if role == "SG":
                group_name = payload.get("group") or payload.get("group_name")
                user.group_name = group_name
            # You may expand this to fetch from DB if needed
            return user
        except JWTError:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")
    return dependency
