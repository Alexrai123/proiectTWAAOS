# Getting Started Tutorial: TWAAOS-SIC

This tutorial will guide you through setting up and running the TWAAOS-SIC exam scheduling system on your local machine for development and testing.

---

## Prerequisites

- **Python 3.9+** (recommended: 3.10 or later)
- **Node.js 16+** (for frontend)
- **npm** (comes with Node.js)
- **Docker & Docker Compose** (for PostgreSQL database)
- **Git** (optional, for version control)

---

## 1. Clone the Repository

```sh
git clone <your-repo-url>
cd proiect TWAAOS
```

---

## 2. Start the Database with Docker

```sh
docker-compose up -d
```
This will start a PostgreSQL database as defined in `docker-compose.yml`.

---

## 3. Backend Setup (FastAPI)

```sh
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### Database Initialization
- If using Alembic migrations:
  ```sh
  alembic upgrade head
  ```
- Or, to manually create tables, run:
  ```sh
  psql -U postgres -d twaaos_sic -f ../local_schema.sql
  ```

### Seed Initial Users (Optional)
```sh
python app/seed_users.py
```

### Start Backend Server
```sh
uvicorn app.main:app --reload
```
Backend will be available at `http://localhost:8000`.

---

## 4. Frontend Setup (React)

```sh
cd ../frontend
npm install
npm start
```
Frontend will be available at `http://localhost:3000`.

---

## 5. Environment Variables

- Backend: Edit `.env` or set variables in your OS (see `DOCUMENTATION.md`, Appendix)
- Frontend: If needed, create `.env` in `frontend/` for variables like `REACT_APP_API_BASE_URL`

---

## 6. Accessing the App

- Open your browser to [http://localhost:3000](http://localhost:3000)
- Login with seeded users (see `app/seed_users.py` for default credentials)

---

## 7. Importing Data

- Use the Import section in the frontend to upload Excel files (`Disciplines.xlsx`, `Exams.xlsx`, etc.)
- See `README.txt` and `DOCUMENTATION.md` for template rules.

---

## 8. API Documentation

- Visit [http://localhost:8000/docs](http://localhost:8000/docs) for Swagger UI
- Or see the `OpenAPI.yaml` file for full API details

---

## 9. Common Issues

- **Port Conflicts:** Make sure nothing else is running on ports 8000 or 3000.
- **Database Connection Errors:** Check Docker is running and `DATABASE_URL` is correct.
- **CORS Errors:** Ensure backend CORS settings allow frontend origin (`http://localhost:3000`).

---

## 10. Stopping the Project

- To stop the database:
  ```sh
  docker-compose down
  ```
- To stop backend/frontend, use `CTRL+C` in their terminal windows.

---

For further help, see `DOCUMENTATION.md` or contact the project maintainer.
