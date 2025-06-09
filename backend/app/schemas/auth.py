from pydantic import BaseModel, EmailStr

class Token(BaseModel):
    access_token: str
    token_type: str
    expires_in: int

class LoginRequest(BaseModel):
    email: EmailStr
    password: str
