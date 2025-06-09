from passlib.context import CryptContext
print(CryptContext(schemes=["bcrypt"]).hash("admin123"))
