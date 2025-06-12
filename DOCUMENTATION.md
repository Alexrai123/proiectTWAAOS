# TWAAOS-SIC Project Documentation

## 1. Project Overview

**TWAAOS-SIC** is an exam and colloquium scheduling system for the Faculty of Electrical Engineering and Computer Science (FIESC), USV. The system streamlines the management of disciplines, rooms, users (students, group leaders, coordinators, secretaries, admins), and the scheduling and approval of exams. It supports import/export of data via Excel and provides secure authentication and role-based access.

---

## 2. Application Architecture

### Backend
- **Framework:** FastAPI (Python)
- **Structure:**
  - `main.py`: FastAPI app, middleware, router registration
  - `app/api/endpoints/`: REST API endpoints (users, auth, disciplines, rooms, exams, import/export)
  - `app/models/`: SQLAlchemy ORM models
  - `app/schemas/`: Pydantic models for request/response validation
  - `app/core/`: Config, dependencies, security
  - `app/db/`: Database session and base
  - `services/`: Business logic (if any)
- **Database:** PostgreSQL (see schema below)
- **Authentication:** JWT and Google OAuth2
- **Import/Export:** Excel (openpyxl)

### Frontend
- **Framework:** React (JavaScript)
- **Structure:**
  - `src/App.js`: Main app, routing, authentication context
  - `src/pages/`: Dashboard and feature pages for each role (CD, SG, SEC, ADM)
  - `src/components/`: Shared UI components
  - `src/api/`: API integration
- **UI:** Material-UI (MUI)
- **Routing:** React Router

---

## 3. Business Rules
- Only group leaders (SG) can propose exams for their group.
- Exams must be approved by the discipline coordinator (CD) and secretary (SEC).
- Exam dates must not overlap for the same group or room.
- Only admins (ADM) and secretaries (SEC) can import/export data.
- Users can only access data and actions permitted by their role.
- All imported Excel sheets must match required formats (see README.txt).

---

## 4. API Overview

### Authentication
- `POST /auth/login` — Login via Google OAuth2 or JWT. Returns access token.
  - **Request:** `{ "email": "user@usv.ro", "password": "..." }`
  - **Response:** `{ "access_token": "...", "token_type": "bearer", "expires_in": 3600 }`
  - **Errors:** `401 Invalid credentials`

### Users
- `GET /users/` — List all users (ADM/SEC only)
- `POST /users/` — Create user (ADM only)
- `GET /users/{user_id}` — Get user by ID
- `PUT /users/{user_id}` — Update user
- `DELETE /users/{user_id}` — Delete user (ADM only)
  - **User Model:**
    - `id: int`, `name: str`, `email: str`, `role: str (SG|CD|SEC|ADM)`, `is_active: bool`, `group_name: Optional[str]`
  - **Validation:** Emails must be unique and valid; roles enforced; required fields checked by Pydantic.

### Disciplines
- `GET /disciplines/` — List disciplines
- `POST /disciplines/` — Create discipline (CD/SEC/ADM)
  - **Discipline Model:**
    - `id: int`, `name: str`, `program: str`, `year: int`, `group_name: str`

### Rooms
- `GET /rooms/` — List rooms
- `POST /rooms/` — Create room (SEC/ADM)
- `DELETE /rooms/{room_id}` — Delete room (SEC/ADM)
  - **Room Model:**
    - `id: int`, `name: str`, `building: Optional[str]`, `capacity: Optional[int]`

### Exams
- `GET /exams/` — List all exams
- `POST /exams/` — Propose new exam (SG)
- `GET /exams/{exam_id}` — Get exam details
- `PUT /exams/{exam_id}` — Update exam (CD/SEC/ADM)
- `DELETE /exams/{exam_id}` — Delete exam (CD/SEC/ADM)
  - **Exam Model:**
    - `id: int`, `discipline_id: int`, `proposed_by: int`, `proposed_date: str`, `confirmed_date: str`, `room_id: int`, `teacher_id: int`, `assistant_ids: List[int]`, `status: str`, `group_name: str`
  - **Validation:**
    - `proposed_date`, `confirmed_date` validated as ISO strings
    - `assistant_ids` validated for empty/None
    - `group_name` must be present and not 'None'
    - Overlap checks for group/room in business logic

### Import, Validation, and Export Process

#### Importing Data (Excel)
- **Endpoint:** `POST /import/excel`
- **Process:**
  1. User uploads an Excel file matching the provided template (see `/import_export/template/...`).
  2. Backend parses the file using `openpyxl` and reads each row.
  3. **Validation Steps:**
     - Checks for required columns and correct sheet names.
     - Validates data types for each field (e.g., integer IDs, valid emails).
     - Checks referential integrity: referenced disciplines, groups, rooms, and users must exist.
     - Ensures uniqueness where required (e.g., user emails).
     - Collects and reports all errors found, returning a summary to the user.
  4. If all data is valid, records are inserted into the database in bulk.
  5. On error, import is aborted and user receives detailed feedback.
- **Security:** Only SEC/ADM roles can import.

#### Validation Mechanisms
- **Pydantic Models:** Enforce types and required fields at the API level.
- **Business Logic:** Additional checks for schedule overlaps, role-based permissions, and uniqueness.
- **Database Constraints:** Enforced at the DB level (unique, not null, foreign keys).

#### Exporting Data
- **Endpoint:** `GET /export/excel?type=...`
- **Process:**
  1. User requests export for a specific data type (e.g., "exams").
  2. Backend queries relevant data from the database.
  3. Data is written to an Excel file in-memory using `openpyxl`.
  4. File is streamed to the user as a download.
- **Supported Types:** disciplines, exams, rooms, users, schedule.
- **Error Handling:** Returns error if type is invalid or no data is found.
- **Other Formats:** PDF and ICS export endpoints exist for schedule data.

---

### Misc
- `GET /ping` — Health check endpoint

**See `OpenAPI.yaml` for full request/response models, error codes, and additional endpoints.**

---

### Error Handling and Response Codes
| Code | Meaning                | Typical Cause                |
|------|------------------------|------------------------------|
| 200  | Success                | Valid request                |
| 201  | Created                | Resource created             |
| 400  | Bad Request            | Invalid input, import type   |
| 401  | Unauthorized           | Invalid/missing token        |
| 403  | Forbidden              | Insufficient permissions     |
| 404  | Not Found              | Resource does not exist      |
| 422  | Validation Error       | Pydantic/field validation    |
| 500  | Internal Server Error  | Unhandled exception          |

---

### Security: Password Hashing Algorithm
- **Algorithm:** bcrypt (via passlib)
- **Implementation:**
  - Passwords are never stored in plain text.
  - On user creation or password change, passwords are hashed using:
    ```python
    from passlib.context import CryptContext
    pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
    hash = pwd_context.hash(password)
    ```
  - On login, the password is verified using:
    ```python
    pwd_context.verify(plain_password, stored_hash)
    ```
- **Security Notes:**
  - bcrypt is a modern, adaptive hash function designed for password storage.
  - Hashes include a salt and are computationally expensive to resist brute-force attacks.

---

#### Example: Exam Creation (POST /exams/)
```json
{
  "discipline_id": 1,
  "proposed_by": 2,
  "proposed_date": "2025-06-15T09:00:00",
  "room_id": 3,
  "teacher_id": 4,
  "assistant_ids": [5, 6],
  "status": "pending",
  "group_name": "3122"
}
```
- **Validation:**
  - All fields must match existing records (discipline, user, room)
  - Dates must be ISO format
  - No overlapping exams for group/room
  - Only allowed roles can propose
- **Response:**
  - `201 Created` with exam details
  - `422 Validation Error` or `400 Bad Request` with error message

---


## 5. Database Schema

### Main Tables
- **users**: id, name, email, role (SG, SEC, CD, ADM), password_hash, is_active, group_name
- **disciplines**: id, name, program, year, group_name
- **rooms**: id, name, building, capacity
- **exams**: id, discipline_id, proposed_by, proposed_date, confirmed_date, room_id, teacher_id, assistant_ids, status, group_name
- **schedules**: id, group_name, room_id, start_time, end_time, type

**See `local_schema.sql` for complete DDL, sequences, and foreign key constraints.**

---

## 6. Important Modules & Workflows

### Backend (Python)
- **main.py**: App setup, CORS, error handling, router inclusion. Registers all routers and global exception handler for debugging.
- **models/**: SQLAlchemy ORM models:
  - `User`: User accounts, roles, group mapping.
  - `Discipline`: Subjects/courses, linked to exams.
  - `Room`: Physical rooms for scheduling.
  - `Exam`: Exam event, links to users, discipline, room.
  - `Schedule`: Timetable entries for groups/rooms.
- **schemas/**: Pydantic models for API validation:
  - `UserBase`, `UserCreate`, `UserRead`, etc.
  - `ExamBase`, `ExamCreate`, `ExamRead`, etc.
  - Custom validators for date/assistant fields.
- **api/endpoints/**: REST endpoints for each entity:
  - `users.py`, `auth.py`, `disciplines.py`, `rooms.py`, `exams.py`, `import_export.py`
  - Each endpoint includes CRUD, validation, and permission checks.
- **core/config.py**: Settings and environment variables.
- **core/deps.py**: Dependency injection, role-based access control.
- **db/session.py**: Async DB session management.
- **seed_users.py**: Script to initialize default users.

#### Backend Workflow Example: Exam Creation
1. **Request:** SG submits POST `/exams/` with exam details.
2. **Validation:**
   - Pydantic enforces field types, required fields.
   - Business logic checks for overlapping exams, valid group/discipline/room.
   - Role-based check ensures only SG can propose.
3. **Database:** Exam is inserted if all checks pass.
4. **Response:** Returns created exam or error message.

### Frontend (React)
- **App.js**: Routing, authentication context, role-based redirects.
- **pages/**: Dashboards and feature pages per user role (SG, CD, SEC, ADM).
- **api/**: API integration, fetch logic.
- **components/**: Shared UI elements (forms, tables, nav bars).
- **Auth Context:** Handles login, token storage, user info, and role-based UI.

#### Frontend Workflow Example: Login
1. User enters credentials and submits login form.
2. Frontend calls `/auth/login` endpoint.
3. On success, JWT token is stored and user is redirected based on role.
4. Auth context provides user info and guards routes.

---

### Business Rule Matrix
| Action                | SG  | CD  | SEC | ADM |
|-----------------------|-----|-----|-----|-----|
| Propose Exam          | ✔   |     |     |     |
| Approve/Reject Exam   |     | ✔   | ✔   | ✔   |
| Create/Edit User      |     |     |     | ✔   |
| Import/Export Excel   |     |     | ✔   | ✔   |
| CRUD Disciplines      |     | ✔   | ✔   | ✔   |
| CRUD Rooms            |     |     | ✔   | ✔   |
| View Own Exams        | ✔   | ✔   | ✔   | ✔   |
| Change Password       | ✔   | ✔   | ✔   | ✔   |

---


## 7. Usage Scenarios

### Scenario 1: Group Leader Proposes Exam
1. SG logs in and navigates to "Propose Exam"
2. Fills in details (discipline, date, room, assistants)
3. Submits proposal
4. CD and SEC review and approve/reject
5. Exam status updated, notifications sent

### Scenario 2: Secretary Imports Data
1. SEC logs in
2. Navigates to Import section
3. Uploads Excel file matching template
4. System validates and ingests data

### Scenario 3: Admin Manages Users
1. ADM logs in
2. Views, creates, updates, or deletes user accounts

---

## 8. Technology Stack

- **Backend:**
  - Python 3.10+
  - FastAPI (async REST API)
  - SQLAlchemy (ORM)
  - Alembic (migrations)
  - PostgreSQL (database)
  - openpyxl (Excel import/export)
  - passlib (password hashing)
  - jose (JWT authentication)
  - asyncpg (async DB driver)
- **Frontend:**
  - React (SPA)
  - Material-UI (UI components)
  - React Router (routing)
  - Axios/fetch (API calls)
- **DevOps/Other:**
  - Docker, docker-compose (service orchestration)
  - Sphinx (Python docs)
  - Excel (template data)
  - Git (version control)

---


## 9. Deployment Notes

### Local Development
- Backend: `cd backend && uvicorn app.main:app --reload`
- Frontend: `cd frontend && npm install && npm start`
- Database: Use Docker Compose (`docker-compose up -d`)
- Environment variables: Set in `.env` or via OS
- Database schema: Initialize with Alembic or run `local_schema.sql`

### Production
- Use production-ready DB and web server (e.g., Gunicorn/Uvicorn, Nginx)
- Set secure environment variables (DB URL, SECRET_KEY, etc.)
- Build frontend (`npm run build`) and serve with static server
- Configure CORS and HTTPS

---

## 10. Appendix

- **Excel Templates:** See `README.txt` for import rules and formats
- **Example Data:** See `Disciplines.xlsx`, `Exams.xlsx`, `GroupLeaders.xlsx`
- **Environment Variables:**
  - `DATABASE_URL` (PostgreSQL connection string)
  - `SECRET_KEY` (JWT signing)
  - `GOOGLE_CLIENT_ID` (OAuth2)
- **API Docs:** See `OpenAPI.yaml` or `/docs` endpoint (Swagger UI)
- **Sphinx Docs:** Build with `sphinx-build docs docs/_build`

---

*Generated on: 2025-06-13*
