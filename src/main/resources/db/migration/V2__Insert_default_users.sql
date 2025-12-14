-- Migration: Insert default users
-- Version: 2
-- Description: Inserts a super admin user and a test user for initial access

-- Insert super admin user (for internal app access)
INSERT INTO users (name, username, password, type, tabela, created_at, updated_at)
VALUES (
    'Super Administrador',
    'admin',
    'admin123',
    'admin',
    NULL,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (username) DO NOTHING;

-- Insert test user (for testing purposes)
INSERT INTO users (name, username, password, type, tabela, created_at, updated_at)
VALUES (
    'Usuário de Teste',
    'teste',
    'teste123',
    'comum',
    NULL,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (username) DO NOTHING;

-- Add comments
COMMENT ON TABLE users IS 'Tabela de usuários do sistema - Usuários padrão: admin/admin123 (admin) e teste/teste123 (comum)';

