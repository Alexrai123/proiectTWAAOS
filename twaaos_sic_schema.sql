
-- TWAAOS-SIC: Initial SQL Schema (PostgreSQL)

-- Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(10) CHECK (role IN ('SG', 'SEC', 'CD', 'ADM')) NOT NULL,
    password_hash TEXT,  -- only for ADM
    is_active BOOLEAN DEFAULT TRUE
);

-- Disciplines Table
CREATE TABLE disciplines (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    program VARCHAR(50),
    year INT,
    group_name VARCHAR(20)
);

-- Exams Table
CREATE TABLE exams (
    id SERIAL PRIMARY KEY,
    discipline_id INT REFERENCES disciplines(id) ON DELETE CASCADE,
    proposed_by INT REFERENCES users(id),
    proposed_date TIMESTAMP,
    confirmed_date TIMESTAMP,
    room_id INT,
    teacher_id INT REFERENCES users(id),
    assistant_ids INT[],
    status VARCHAR(20) CHECK (status IN ('pending', 'approved', 'rejected'))
);

-- Rooms Table
CREATE TABLE rooms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    building VARCHAR(50),
    capacity INT
);

-- Schedules Table (e.g. reserved slots)
CREATE TABLE schedules (
    id SERIAL PRIMARY KEY,
    group_name VARCHAR(20),
    room_id INT REFERENCES rooms(id),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    type VARCHAR(20)  -- e.g., 'exam', 'colloquium'
);
