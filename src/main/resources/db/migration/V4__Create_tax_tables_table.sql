-- Migration: Create tax_tables table
-- Version: 4
-- Description: Creates the tax_tables table to store tax calculation tables as JSON

-- Create tax_tables table
CREATE TABLE IF NOT EXISTS tax_tables (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(500) NULL,
    data JSONB NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create index on name for faster lookups
CREATE INDEX idx_tax_tables_name ON tax_tables(name);

-- Create index on active for filtering active tables
CREATE INDEX idx_tax_tables_active ON tax_tables(active);

-- Create GIN index on JSONB data for efficient JSON queries
CREATE INDEX idx_tax_tables_data ON tax_tables USING GIN (data);

-- Add comments
COMMENT ON TABLE tax_tables IS 'Tabela de tabelas de taxas financeiras armazenadas em formato JSON';
COMMENT ON COLUMN tax_tables.id IS 'ID único da tabela de taxas';
COMMENT ON COLUMN tax_tables.name IS 'Nome único da tabela de taxas';
COMMENT ON COLUMN tax_tables.description IS 'Descrição opcional da tabela';
COMMENT ON COLUMN tax_tables.data IS 'Dados da tabela de taxas em formato JSONB';
COMMENT ON COLUMN tax_tables.active IS 'Indica se a tabela está ativa';
COMMENT ON COLUMN tax_tables.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN tax_tables.updated_at IS 'Data da última atualização';

