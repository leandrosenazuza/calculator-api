# Guia de Migração do Backend

Este documento explica como migrar do backend Node.js/Express para o novo backend Spring Boot/Kotlin.

## Diferenças Principais

### Banco de Dados
- **Antigo**: SQLite (`backend/database/db.sqlite`)
- **Novo**: PostgreSQL (`calculator_db`)

### Estrutura
- **Antigo**: Node.js com Express, rotas em JavaScript
- **Novo**: Spring Boot com Kotlin, arquitetura em camadas

## Passos para Migração

### 1. Instalar PostgreSQL

**macOS:**
```bash
brew install postgresql@14
brew services start postgresql@14
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
sudo systemctl start postgresql
```

**Windows:**
Baixe e instale do site oficial: https://www.postgresql.org/download/windows/

### 2. Criar Banco de Dados

```bash
# Conectar ao PostgreSQL
psql -U postgres

# Criar banco de dados
CREATE DATABASE calculator_db;

# Criar usuário (opcional)
CREATE USER calculator_user WITH PASSWORD 'sua_senha';
GRANT ALL PRIVILEGES ON DATABASE calculator_db TO calculator_user;

# Sair
\q
```

### 3. Migrar Dados do SQLite para PostgreSQL

Você pode usar um script Python ou fazer manualmente:

```python
# migrate_data.py (exemplo)
import sqlite3
import psycopg2

# Conectar ao SQLite
sqlite_conn = sqlite3.connect('backend/database/db.sqlite')
sqlite_cur = sqlite_conn.cursor()

# Conectar ao PostgreSQL
pg_conn = psycopg2.connect(
    host="localhost",
    database="calculator_db",
    user="postgres",
    password="postgres"
)
pg_cur = pg_conn.cursor()

# Migrar usuários
sqlite_cur.execute("SELECT * FROM users")
users = sqlite_cur.fetchall()

for user in users:
    pg_cur.execute("""
        INSERT INTO users (id, name, username, password, type, tabela)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, user)

pg_conn.commit()
pg_cur.close()
pg_conn.close()
sqlite_cur.close()
sqlite_conn.close()
```

### 4. Configurar Variáveis de Ambiente

Crie um arquivo `.env` ou configure no `application.yml`:

```yaml
spring:
  datasource:
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:postgres}
```

### 5. Executar o Novo Backend

```bash
cd calculator-api
./gradlew bootRun
```

## Endpoints Mantidos

Todos os endpoints mantêm a mesma estrutura:

- `POST /api/login` - Login
- `GET /api/users` - Listar usuários
- `POST /api/users` - Criar usuário
- `PUT /api/users/{id}` - Atualizar usuário
- `DELETE /api/users/{id}` - Excluir usuário
- `GET /api/tabelas` - Listar tabelas
- `POST /api/upload` - Upload de tabela

## Estrutura de Resposta

As respostas JSON são compatíveis com o frontend existente.

## Próximos Passos

1. Testar todos os endpoints
2. Verificar se o frontend funciona corretamente
3. Migrar arquivos JSON de tabelas para a pasta `public/tables-taxes` do novo projeto

