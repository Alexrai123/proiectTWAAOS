import asyncio
from app.db.session import AsyncSessionLocal
from app.models.user import User
from app.models import exam, discipline, room

async def check():
    async with AsyncSessionLocal() as s:
        users = (await s.execute(User.__table__.select())).fetchall()
        for row in users:
            print(f"email={row._mapping['email']}, role={row._mapping['role']}")

if __name__ == "__main__":
    asyncio.run(check())
