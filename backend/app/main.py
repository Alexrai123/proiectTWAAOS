from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.endpoints import users, auth, disciplines, rooms, exams, import_export

from fastapi.responses import JSONResponse
from fastapi.requests import Request
import traceback

app = FastAPI(title="TWAAOS-SIC Exam Scheduling API")

# Global exception handler for debugging (development only)
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "detail": str(exc),
            "traceback": traceback.format_exc()
        },
    )

# CORS middleware for frontend-backend communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://localhost:5000"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(users.router)
app.include_router(auth.router)
app.include_router(disciplines.router)
app.include_router(rooms.router)
app.include_router(exams.router)
app.include_router(import_export.router)

@app.get("/ping")
def ping():
    return {"message": "pong"}
