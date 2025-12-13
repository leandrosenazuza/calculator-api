# Calculator API

API backend para a aplicação de calculadora financeira, desenvolvida com Spring Boot 3.2 e Kotlin.

## Tecnologias

- **Spring Boot 3.2.0**
- **Kotlin 1.9.20**
- **PostgreSQL** (via Docker)
- **Spring Data JPA**
- **Gradle**

## Pré-requisitos

- Java 17 ou superior
- Docker e Docker Compose (para PostgreSQL)
- Gradle (ou use o wrapper incluído)

## Configuração do Banco de Dados

O PostgreSQL é configurado automaticamente via Docker. Não é necessário instalar PostgreSQL localmente.

### Credenciais Padrão

- **Usuário:** `postgres`
- **Senha:** `postgres`
- **Banco:** `calculator_db`
- **Porta:** `5432`

## Como Rodar

### Opção 1: Script de Start Completo (Recomendado)

Execute a partir da **raiz do projeto** (onde estão `calculator-api` e `calculator-app`):

```bash
./calculator-api/start.sh
```

Este script:
- ✅ Inicia PostgreSQL via Docker (se não estiver rodando)
- ✅ Inicia a API Spring Boot
- ✅ Inicia o App React/Vite

Pressione `Ctrl+C` para parar API e App (PostgreSQL continua rodando).

### Opção 2: Apenas a API

```bash
# Iniciar PostgreSQL
cd calculator-api
docker-compose up -d postgres

# Rodar a API
./gradlew bootRun
```

### Opção 3: Tudo via Docker

```bash
cd calculator-api
docker-compose --profile fullstack up -d
```

Isso inicia PostgreSQL + API via Docker.

## Comandos Docker

```bash
# Ver logs do PostgreSQL
docker-compose logs -f postgres

# Parar PostgreSQL
./stop.sh
# ou
docker-compose down

# Parar e remover volumes (apaga dados)
docker-compose down -v
```

## Endpoints da API

### Autenticação
- `POST /api/login` - Login de usuário

### Usuários
- `GET /api/users` - Lista todos os usuários
- `POST /api/users` - Cria novo usuário
- `PUT /api/users/{id}` - Atualiza tabela e/ou senha do usuário
- `DELETE /api/users/{id}` - Exclui usuário

### Tabelas
- `GET /api/tabelas` - Lista arquivos JSON de tabelas
- `POST /api/upload` - Upload de arquivo JSON

## Porta Padrão

A API roda na porta **3001** por padrão.

## Estrutura do Projeto

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
│   │       └── application.yml  # Configurações da aplicação
│   └── test/                    # Testes
├── docker-compose.yml           # Configuração Docker (PostgreSQL)
├── Dockerfile                   # Dockerfile para deploy da API
├── start.sh                     # Script para iniciar tudo
├── stop.sh                      # Script para parar Docker
├── build.gradle.kts             # Dependências Gradle
└── README.md
```

## Migração de Dados

O Spring Boot criará automaticamente as tabelas no PostgreSQL na primeira execução (usando `ddl-auto: update`).

Para migrar dados do SQLite antigo, você pode usar um script de migração ou fazer manualmente.

## Deploy

Para deploy em produção:

1. **Build da imagem Docker:**
   ```bash
   docker build -t calculator-api .
   ```

2. **Ou usar docker-compose:**
   ```bash
   docker-compose --profile fullstack up -d
   ```

3. **Configurar variáveis de ambiente** para produção no `application.yml` ou via variáveis de ambiente do sistema.
