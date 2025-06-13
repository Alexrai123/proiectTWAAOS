import requests

exam_id = 3
url = f"http://localhost:8000/exams/{exam_id}"
payload = {
    "proposed_by": 4,  # ID for sg@usv.ro
    "group_name": "ETTI"  # or the correct group name for the exam
}
response = requests.put(url, json=payload)
print(response.status_code, response.text)
