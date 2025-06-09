"""
Alembic migration script to add group_name to Exam and User models.
"""
from alembic import op
import sqlalchemy as sa

def upgrade():
    op.add_column('exams', sa.Column('group_name', sa.String(20)))
    op.add_column('users', sa.Column('group_name', sa.String(20)))

def downgrade():
    op.drop_column('exams', 'group_name')
    op.drop_column('users', 'group_name')
