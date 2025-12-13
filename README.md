# Calculator API

API backend para aplicação de calculadora financeira, desenvolvida com **Spring Boot 3.2** e **Kotlin**. Esta API fornece endpoints REST para autenticação de usuários, gerenciamento de usuários e upload de tabelas de taxas financeiras.

## 📋 Sobre o Projeto

Esta é uma API REST que serve como backend para uma aplicação de calculadora financeira. A aplicação permite:

- **Autenticação de usuários** (admin e comum)
- **Gerenciamento de usuários** (CRUD completo)
- **Upload e gerenciamento de tabelas de taxas** (arquivos JSON)
- **Cálculos financeiros** baseados em tabelas personalizadas por usuário

A API foi migrada de Node.js/Express para Spring Boot/Kotlin, utilizando PostgreSQL como banco de dados e Flyway para versionamento do schema.

## 🚀 Como Rodar o Projeto

### Pré-requisitos

- **Java 17+** instalado
- **Docker** e **Docker Compose** (para PostgreSQL)
- **Gradle** (ou use o wrapper incluído: `./gradlew`)

### Opção 1: Início Rápido (Recomendado)

```bash
# Na raiz do projeto (onde estão calculator-api e calculator-app)
./calculator-api/start.sh
```

Este script:
- ✅ Inicia PostgreSQL via Docker (se não estiver rodando)
- ✅ Inicia a API Spring Boot na porta 3001
- ✅ Inicia o frontend React/Vite na porta 5173

Pressione `Ctrl+C` para parar API e App (PostgreSQL continua rodando).

### Opção 2: Apenas a API

```bash
cd calculator-api

# 1. Iniciar PostgreSQL
docker-compose up -d postgres

# 2. Rodar a API
./gradlew bootRun
```

A API estará disponível em: **http://localhost:3001**

### Opção 3: Tudo via Docker

```bash
cd calculator-api
docker-compose --profile fullstack up -d
```

Isso inicia PostgreSQL + API via Docker.

## ⚙️ Configuração

### Banco de Dados

O PostgreSQL é configurado automaticamente via Docker. Credenciais padrão:

- **Usuário:** `postgres`
- **Senha:** `postgres`
- **Banco:** `calculator_db`
- **Porta:** `5432`

### Variáveis de Ambiente (Opcional)

Você pode sobrescrever as credenciais do banco usando variáveis de ambiente:

```bash
export DB_USERNAME=postgres
export DB_PASSWORD=postgres
```

Ou edite `src/main/resources/application.yml` diretamente.

## 🗄️ Versionamento do Banco de Dados (Flyway)

O projeto utiliza **Flyway** para gerenciar migrações do banco de dados. As migrations são executadas automaticamente na inicialização da aplicação.

### Estrutura de Migrations

As migrations estão em: `src/main/resources/db/migration/`

**Convenção de nomenclatura:**
- `V{version}__{description}.sql`
- Exemplo: `V1__Create_users_table.sql`

### Migrations Existentes

- **V1__Create_users_table.sql**: Cria a tabela `users` com todos os campos necessários

### Criar Nova Migration

1. Crie um arquivo SQL em `src/main/resources/db/migration/`
2. Use o próximo número sequencial: `V2__{descricao}.sql`
3. Exemplo: `V2__Add_email_to_users.sql`

```sql
-- V2__Add_email_to_users.sql
ALTER TABLE users ADD COLUMN email VARCHAR(255);
```

### Comandos Flyway

```bash
# Ver status das migrations
./gradlew flywayInfo

# Executar migrations manualmente
./gradlew flywayMigrate

# Validar migrations
./gradlew flywayValidate
```

**⚠️ Importante:** Nunca modifique migrations já executadas. Sempre crie uma nova migration para mudanças.

## 📡 Endpoints da API

### Autenticação

- `POST /api/login` - Login de usuário
  ```json
  {
    "username": "admin",
    "password": "senha"
  }
  ```

### Usuários

- `GET /api/users` - Lista todos os usuários
- `POST /api/users` - Cria novo usuário
  ```json
  {
    "name": "Nome do Usuário",
    "username": "usuario",
    "password": "senha",
    "type": "admin" // ou "comum"
  }
  ```
- `PUT /api/users/{id}` - Atualiza usuário (tabela e/ou senha)
- `DELETE /api/users/{id}` - Exclui usuário

### Tabelas

- `GET /api/tabelas` - Lista arquivos JSON de tabelas disponíveis
- `POST /api/upload` - Upload de arquivo JSON de tabela

## 🧪 Testar Endpoints

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

### Criar Usuário
```bash
curl -X POST http://localhost:3001/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Administrador",
    "username": "admin",
    "password": "senha",
    "type": "admin"
  }'
```

## 🏗️ Estrutura do Projeto

```
calculator-api/
├── src/
│   ├── main/
│   │   ├── kotlin/com/calculator/api/
│   │   │   ├── config/          # Configurações (CORS, Web)
│   │   │   ├── controller/      # Controllers REST
│   │   │   ├── dto/             # Data Transfer Objects
│   │   │   ├── entity/          # Entidades JPA
│   │   │   ├── repository/      # Repositories JPA
│   │   │   ├── service/         # Lógica de negócio
│   │   │   └── CalculatorApiApplication.kt
│   │   └── resources/
│   │       ├── application.yml  # Configurações da aplicação
│   │       └── db/migration/    # Migrations Flyway
│   └── test/                    # Testes
├── docker-compose.yml           # Configuração Docker (PostgreSQL)
├── Dockerfile                   # Dockerfile para deploy da API
├── start.sh                     # Script para iniciar tudo
├── stop.sh                      # Script para parar Docker
└── build.gradle.kts             # Dependências Gradle
```

## 🛠️ Tecnologias

- **Spring Boot 3.2.0** - Framework Java/Kotlin
- **Kotlin 1.9.20** - Linguagem de programação
- **PostgreSQL 14** - Banco de dados relacional
- **Spring Data JPA** - Persistência de dados
- **Flyway** - Versionamento de banco de dados
- **Gradle** - Gerenciamento de dependências
- **Docker** - Containerização

## 🐳 Comandos Docker

```bash
# Ver logs do PostgreSQL
docker-compose logs -f postgres

# Parar PostgreSQL
./stop.sh
# ou
docker-compose down

# Parar e remover volumes (⚠️ apaga dados)
docker-compose down -v

# Ver status dos containers
docker-compose ps
```

## 📦 Deploy

### Build da Imagem Docker

```bash
docker build -t calculator-api .
```

### Deploy com Docker Compose

```bash
docker-compose --profile fullstack up -d
```

### Configuração para Produção

Para produção, configure as variáveis de ambiente ou edite `application.yml`:

```yaml
spring:
  datasource:
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:postgres}
```

## 🔄 Migração de Dados (Legado)

Se você está migrando de um backend anterior (Node.js/Express com SQLite):

### Diferenças Principais

- **Antigo**: SQLite (`backend/database/db.sqlite`)
- **Novo**: PostgreSQL (`calculator_db`)
- **Antigo**: Node.js com Express
- **Novo**: Spring Boot com Kotlin

### Migrar Dados do SQLite

Você pode usar um script Python para migrar dados:

```python
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
# Fechar conexões...
```

## 📝 Notas Importantes

1. **Flyway**: As migrations são executadas automaticamente na inicialização. Nunca modifique migrations já executadas.

2. **Hibernate**: Configurado com `ddl-auto: validate` para garantir que o schema corresponde às entidades. O Flyway gerencia o schema.

3. **CORS**: Configurado para permitir requisições do frontend (porta 5173).

4. **Porta**: A API roda na porta **3001** por padrão.

## 🐛 Troubleshooting

### Erro: "Connection refused" ao iniciar API
- Verifique se o PostgreSQL está rodando: `docker-compose ps`
- Inicie o PostgreSQL: `docker-compose up -d postgres`

### Erro: "Migration failed"
- Verifique os logs da aplicação para ver qual comando SQL falhou
- Corrija a migration e execute novamente

### Erro: "Migration checksum mismatch"
- Isso acontece quando uma migration foi modificada após ser executada
- Use `./gradlew flywayRepair` (cuidado: pode mascarar problemas)
- Ou reverta a migration manualmente no banco

## 📚 Documentação Adicional

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Kotlin Documentation](https://kotlinlang.org/docs/home.html)
- [Flyway Documentation](https://flywaydb.org/documentation/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 📄 Licença

Este projeto é privado e de uso interno.
