-- Migration: Create users table
-- Version: 1
-- Description: Creates the users table for authentication and user management

-- Drop table if exists (for clean migration from Hibernate-managed schema)
DROP TABLE IF EXISTS users CASCADE;

-- Create users table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('admin', 'comum')),
    tabela VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on username for faster lookups
CREATE INDEX idx_users_username ON users(username);

-- Create index on type for filtering
CREATE INDEX idx_users_type ON users(type);

-- Add comments
COMMENT ON TABLE users IS 'Tabela de usuários do sistema';
COMMENT ON COLUMN users.id IS 'ID único do usuário';
COMMENT ON COLUMN users.name IS 'Nome completo do usuário';
COMMENT ON COLUMN users.username IS 'Nome de usuário único para login';
COMMENT ON COLUMN users.password IS 'Senha do usuário';
COMMENT ON COLUMN users.type IS 'Tipo do usuário: admin ou comum';
COMMENT ON COLUMN users.tabela IS 'Nome da tabela de taxas associada ao usuário';
COMMENT ON COLUMN users.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN users.updated_at IS 'Data da última atualização';

