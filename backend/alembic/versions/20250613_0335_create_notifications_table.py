"""
Create notifications table
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '20250613_0335'
down_revision = '20250608_0241'
branch_labels = None
depends_on = None

def upgrade():
    op.create_table(
        'notifications',
        sa.Column('id', sa.Integer(), primary_key=True, index=True),
        sa.Column('user_id', sa.Integer(), sa.ForeignKey('users.id'), nullable=False),
        sa.Column('exam_id', sa.Integer(), sa.ForeignKey('exams.id'), nullable=True),
        sa.Column('message', sa.String(length=255), nullable=False),
        sa.Column('created_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.Column('seen', sa.Boolean(), nullable=False, server_default=sa.text('false')),
        sa.Column('seen_at', sa.TIMESTAMP(), nullable=True),
    )

def downgrade():
    op.drop_table('notifications')
