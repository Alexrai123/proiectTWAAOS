import asyncio
from passlib.context import CryptContext
from app.db.session import AsyncSessionLocal
from app.models.user import User

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

USERS = [
    {"name": "Admin", "email": "admin@usv.ro", "role": "ADM", "password": "admin123"},
    {"name": "Secretary", "email": "sec@usv.ro", "role": "SEC", "password": "sec123"},
    {"name": "Coordinator", "email": "cd@usv.ro", "role": "CD", "password": "cd123"},
    {"name": "StudentGroup", "email": "sg@usv.ro", "role": "SG", "password": "sg123"},
]

async def seed_users():
    async with AsyncSessionLocal() as session:
        for user in USERS:
            exists = await session.execute(
                User.__table__.select().where(User.email == user["email"]))
            if exists.first():
                continue
            user_obj = User(
                name=user["name"],
                email=user["email"],
                role=user["role"],
                password_hash=pwd_context.hash(user["password"]),
                is_active=True
            )
            session.add(user_obj)
        await session.commit()

if __name__ == "__main__":
    asyncio.run(seed_users())
