# Quick Start - Calculator API

## Pré-requisitos Rápidos

1. **Java 17+** instalado
   ```bash
   java -version
   ```

2. **PostgreSQL** instalado e rodando
   ```bash
   psql --version
   ```

## Setup Rápido

### 1. Criar Banco de Dados

```bash
psql -U postgres
CREATE DATABASE calculator_db;
\q
```

### 2. Configurar Credenciais

Edite `src/main/resources/application.yml` ou use variáveis de ambiente:

```bash
export DB_USERNAME=postgres
export DB_PASSWORD=postgres
```

### 3. Rodar a Aplicação

```bash
./gradlew bootRun
```

A API estará disponível em: `http://localhost:3001`

## Testar Endpoints

### Login
```bash
curl -X POST http://localhost:3001/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"senha"}'
```

### Listar Usuários
```bash
curl http://localhost:3001/api/users
```

## Estrutura Criada Automaticamente

O Spring Boot criará automaticamente a tabela `users` na primeira execução.

## Próximos Passos

1. Migrar dados do SQLite antigo (veja MIGRACAO.md)
2. Copiar arquivos JSON de tabelas para `public/tables-taxes/`
3. Conectar o frontend aos novos endpoints

