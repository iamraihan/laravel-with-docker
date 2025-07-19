-- Create database if not exists
SELECT 'CREATE DATABASE laravel_db'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'laravel_db')\gexec

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE laravel_db TO laravel_user; 