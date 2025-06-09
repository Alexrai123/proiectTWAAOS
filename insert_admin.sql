DELETE FROM users WHERE email = 'admin@usv.ro';
INSERT INTO users (name, email, role, password_hash, is_active) VALUES ('Admin', 'admin@usv.ro', 'ADM', '$2b$12$7QIe8N.5zBmYhj5lzQCpEuDAF7gGVL1Bq7tSHI./gsAXYiuf.MKV2', true);
