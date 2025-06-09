import requests

url = "http://127.0.0.1:8000/auth/login"
payload = {"email": "admin@usv.ro", "password": "admin123"}
r = requests.post(url, json=payload)
print("Status:", r.status_code)
print("Response:", r.text)
