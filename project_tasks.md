# TWAAOS-SIC Project Implementation Checklist

## Manual Test Cases To Verify Once Application Is Running

- [ ] **SG cannot propose exam for another group**
    - Verify as SG: attempt to create an exam for a group you do NOT belong to. Expect a 403 Forbidden or clear error.
    - Confirm that only exams for your own group can be created by a group leader (SG).
- [ ] (Add more skipped/edge case tests here as needed)


## User Roles & Permissions
- [ ] Implement SG (Group Leader) role with ability to propose exam dates for their group/year only
- [ ] Restrict SG to view/edit/import exams only for their group
- [ ] Implement CD (Professor) role with ability to approve/reject exams for their disciplines
- [ ] Allow CD to assign rooms and assistant professors, and prevent scheduling conflicts
- [ ] Implement SEC (Secretariat) role with ability to upload/edit/export templates, edit/finalize schedules, notify users, and import/export all data
- [ ] Implement ADM (Administrator) role with full access, user management, metadata editing, and JWT-only login

## Data Import & Validation
- [ ] Allow Excel import for exams, disciplines, and group leaders for SG, SEC, ADM roles only
- [ ] Validate all referenced names (faculty, program, group, discipline, professor, assistants, room) on import
- [ ] Restrict SG import to their group only; reject other groups
- [ ] Validate discipline-group/faculty/program/year match on import
- [ ] Reject exams for disciplines outside group’s program/year
- [ ] Validate date formats (YYYY-MM-DD HH:MM:SS) on import
- [ ] Validate assistant names (split by ;, all must exist)
- [ ] Prevent room/professor/assistant/group conflicts on import/manual scheduling

## Exam Scheduling & Status Workflow
- [ ] Implement exam proposal flow: SG proposes, enters pending, CD reviews/approves/rejects
- [ ] Allow CD to set confirmed_date, assign assistants/room
- [ ] Set status transitions: pending, approved, rejected (with reason), cancelled, completed
- [ ] Record publication_date on final approval

## Notifications & Communication
- [ ] Send email notifications on status changes (pending→approved, etc.) to SG, CD; optionally copy SEC
- [ ] Send notifications asynchronously and log them

## Data Export
- [ ] Allow SEC/ADM to export data in Excel, PDF, ICS formats
- [ ] Restrict SG export to their group, CD to their disciplines, SEC/ADM to all data

## API Access & Security
- [ ] Implement Google OAuth2 for SG, SEC, CD (@usv.ro, @student.usv.ro)
- [ ] Implement JWT authentication for ADM
- [ ] Restrict full dataset import/export to SEC/ADM

## Error Handling
- [ ] On import, report specific errors for each rejected row (e.g., discipline, assistant, room errors)
- [ ] Forbid partial/invalid data acceptance
- [ ] Return clear, user-facing errors on forbidden actions

## Audit & Traceability
- [ ] Log all imports, user actions, approvals/rejections, and exports with timestamp/user
- [ ] Provide audit trail for any change

## API Behavior & Validation
- [ ] Enforce business rules at input and business logic layers
- [ ] Return HTTP 4xx for user errors, 5xx for system errors, with descriptive messages

## Edge Cases & Constraints
- [ ] Prevent scheduling exams for past dates
- [ ] Ensure publication date cannot be before approval date
- [ ] Send notifications on exam cancellation

## Architecture & Deployment
- [ ] Use FastAPI for backend, React for frontend, PostgreSQL for DB
- [ ] Dockerize backend, frontend, and DB; provide docker-compose.yml
- [ ] Store persistent data in Docker volumes
- [ ] Use .env for secrets, DB, and API keys
- [ ] Run DB migrations (Alembic) and seed initial data
- [ ] Configure Sendgrid (or SMTP) for async notifications
- [ ] Use Celery/RQ/BackgroundTasks for notifications

## Security & Privacy
- [ ] Enforce HTTPS in production
- [ ] Secure JWT tokens and Google OAuth2 domain whitelist
- [ ] Hash/salt ADM passwords (bcrypt)
- [ ] Audit sensitive user actions
- [ ] Allow export/deletion of personal data (GDPR)
- [ ] Restrict exports to authorized users

## Maintenance & Extensibility
- [ ] Modularize for scalability (microservices/Kubernetes-ready)
- [ ] Update OpenAPI YAML and business rules for new features
- [ ] Rebuild Docker images after dependency/env changes

## Integration & References
- [ ] Integrate with USV Orar API for staff, rooms, faculties, groups, timetable
- [ ] Use names not IDs in Excel import for traceability
- [ ] Provide all documentation: Architecture, OpenAPI YAML, DB schema, Excel README, Business Rules

## Testing & Validation
- [ ] Provide unit/integration tests for all endpoints and workflows
- [ ] Test all role-based permissions and edge cases
- [ ] Test import/export with valid and invalid data
- [ ] Assert DB state after import/export
- [ ] Test notifications and audit logging

# End of Checklist
