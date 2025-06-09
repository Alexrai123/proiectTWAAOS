TWAAOS-SIC EXCEL TEMPLATE – README
General Import Rules
Do not modify the header (first row) of any sheet.

Each sheet must have the columns in the exact order shown below.

Field values are case sensitive and must match existing records in the system.

All columns are required unless explicitly marked as optional.

Dates must use format: YYYY-MM-DD HH:MM:SS (date and time), or YYYY-MM-DD (date only, e.g., for publication_date).

The separator for multiple assistant names is ; (semicolon).

Sheet List
README – this page, import instructions and validation rules.

Disciplines – defines all available disciplines for each program and year.

Exams – list of exams to be imported, each row is a single exam.

GroupLeaders – mapping between each group and its assigned leader.

Sheet: Disciplines
name	program	year
Advanced Tech	Computers	3
Embedded Systems	Computers	4
Electronics	Automation	3

Column descriptions
name: The official name of the discipline/course.

program: The program or specialization (e.g., Computers, Automation).

year: Study year for which this discipline is taught (integer).

Sheet: Exams
faculty	program	discipline_name	group_name	proposed_by_name	proposed_date	confirmed_date	room_name	status	professor_name	assistant_names	publication_date

Column descriptions
faculty: Faculty name (e.g., FIESC).

program: The specialization of the group and discipline (must match program from Disciplines and GroupLeaders).

discipline_name: Name of the discipline, must exist in Disciplines for the given program/year.

group_name: Name of the group (must match entry in GroupLeaders).

proposed_by_name: The group leader who is proposing the exam (must match GroupLeaders).

proposed_date: Proposed exam date and time (YYYY-MM-DD HH:MM:SS).

confirmed_date: Confirmed date and time if approved, otherwise leave blank or use null.

room_name: Name of the room for the exam (must exist in the system).

status: One of pending, approved, rejected, cancelled, completed.

professor_name: The name of the professor responsible for the exam (must exist in the system).

assistant_names: All assistants’ names, separated by ;. All names must exist in the system. Leave blank if none.

publication_date: Date when the exam is published for students (YYYY-MM-DD).

Validation Rules (ENFORCED BY THE SYSTEM)
For each row, the discipline, group, faculty, and program must all match (e.g., you cannot schedule a Computers discipline for an Automation group).

The group leader (proposed_by_name) can only import exams for their own group.

All referenced names (disciplines, professors, assistants, rooms) must already exist in the system. Otherwise, the row is rejected.

Dates must have the correct format.

The status must be one of the allowed values.

Example (valid row):
faculty	program	discipline_name	group_name	proposed_by_name	proposed_date	confirmed_date	room_name	status	professor_name	assistant_names	publication_date
FIESC	Computers	Advanced Tech	3A1	Radu Popescu	2025-06-15 10:00:00	2025-06-18 12:00:00	A101	approved	Mihai Vasilescu	Ana Ionescu;G Vasile	2025-06-10

Sheet: GroupLeaders
group_name	leader_name	leader_email
3A1	Radu Popescu	radu.popescu@usv.ro
3B2	Andreea Ionescu	andreea.ionescu@usv.ro

Column descriptions
group_name: Official name of the group (must match group_name in Exams).

leader_name: Full name of the group leader (must match proposed_by_name in Exams).

leader_email: Email address of the group leader.

General Workflow (for AI or automation):
Fill in data using the sheets in this template. Do not change the order or headers of columns.

Before import: Check that all referenced disciplines, professors, assistants, rooms, and group leaders exist in the database.

For each exam row:

Check that the group, faculty, and program all match the discipline and group leader.

Reject any row with mismatched or non-existent data. Report detailed error per row.

On import: Only valid rows will be imported. Invalid rows must be logged with explicit error reasons.

Never schedule an exam for a group in a discipline of another program/faculty/year.

Common Import Errors
Discipline, group, faculty, or program mismatch

Group leader importing exams for a different group

User, room, or assistant name does not exist

Invalid date or publication date format

Status not in allowed values

Sheet List Recap
README — this sheet, with all instructions and rules.

Disciplines — allowed disciplines, programs, and years.

Exams — all exam data for scheduling/import.

GroupLeaders — official mapping between group and leader.

---

## Project Documentation

All core Python modules and services in the TWAAOS-SIC system are documented using Google- or NumPy-style docstrings.

The technical documentation is automatically generated using [Sphinx](https://www.sphinx-doc.org/) and [sphinxcontrib-napoleon](https://sphinxcontrib-napoleon.readthedocs.io/), which parses and formats all code docstrings into easy-to-read HTML and PDF files.

To build or update the documentation:
1. Install requirements:
pip install sphinx sphinxcontrib-napoleon

2. From the `docs/` directory, run:
3. Open `docs/_build/html/index.html` in your browser to view the generated documentation.

**All docstrings in the Python codebase should use the Google or NumPy style for full compatibility and clear API documentation.**

