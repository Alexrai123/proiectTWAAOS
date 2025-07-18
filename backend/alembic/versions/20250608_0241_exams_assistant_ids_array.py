"""
Migration: Change assistant_ids to ARRAY(Integer) in exams table
Generated by Cascade on 2025-06-08 02:41
"""
# Alembic revision identifiers
revision = '20250608_0241'
down_revision = '5d49433bac11'
branch_labels = None
depends_on = None

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    # Change assistant_ids from String/Text to ARRAY(Integer)
    op.alter_column('exams', 'assistant_ids',
        type_=postgresql.ARRAY(sa.Integer),
        postgresql_using="string_to_array(assistant_ids, ',')::integer[]",
        existing_type=sa.String(),
        existing_nullable=True
    )
    # If your old data was JSON, you may need a custom conversion here
    # Otherwise, consider dropping and recreating the column if no data to preserve
    # op.drop_column('exams', 'assistant_ids')
    # op.add_column('exams', sa.Column('assistant_ids', postgresql.ARRAY(sa.Integer)))
    # ### end Alembic commands ###

def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('exams', 'assistant_ids',
        type_=sa.String(),
        existing_type=postgresql.ARRAY(sa.Integer),
        existing_nullable=True
    )
    # ### end Alembic commands ###
