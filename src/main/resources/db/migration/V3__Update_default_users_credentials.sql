-- Migration: Update default users credentials
-- Version: 3
-- Description: Updates the default users with new secure credentials
--
-- Atualiza os usuários padrão com novas credenciais:
-- 1. Super Administrador (admin) - Acesso completo ao sistema
--    Login: superadmin
--    Senha: SuperAdmin@2024
--    Tipo: admin
--
-- 2. Usuário de Teste (comum) - Para testes gerais
--    Login: teste
--    Senha: Teste@2024
--    Tipo: comum

-- Atualiza ou cria o super admin user
-- Remove usuário antigo 'admin' se existir e cria/atualiza 'superadmin'
DELETE FROM users WHERE username = 'admin';

INSERT INTO users (name, username, password, type, tabela, created_at, updated_at)
VALUES (
    'Super Administrador',
    'superadmin',
    'SuperAdmin@2024',
    'admin',
    NULL,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (username) DO UPDATE
SET 
    name = EXCLUDED.name,
    password = EXCLUDED.password,
    type = EXCLUDED.type,
    updated_at = CURRENT_TIMESTAMP;

-- Atualiza ou cria o usuário de teste
INSERT INTO users (name, username, password, type, tabela, created_at, updated_at)
VALUES (
    'Usuário de Teste',
    'teste',
    'Teste@2024',
    'comum',
    NULL,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (username) DO UPDATE
SET 
    name = EXCLUDED.name,
    password = EXCLUDED.password,
    type = EXCLUDED.type,
    updated_at = CURRENT_TIMESTAMP;

