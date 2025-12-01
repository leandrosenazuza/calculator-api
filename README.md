# Calculator API

API backend para a aplicação de calculadora financeira, desenvolvida com Spring Boot 3.2 e Kotlin.

## Tecnologias

- **Spring Boot 3.2.0**
- **Kotlin 1.9.20**
- **PostgreSQL**
- **Spring Data JPA**
- **Gradle**

## Pré-requisitos

- Java 17 ou superior
- PostgreSQL instalado e rodando
- Gradle (ou use o wrapper incluído)

## Configuração do Banco de Dados

1. Crie o banco de dados PostgreSQL:
```sql
CREATE DATABASE calculator_db;
```

2. Configure as credenciais no arquivo `application.yml`:
```yaml
spring:
  datasource:
    username: seu_usuario
    password: sua_senha
```

Ou use variáveis de ambiente:
```bash
export DB_USERNAME=postgres
export DB_PASSWORD=postgres
```

## Como Rodar

### Desenvolvimento

```bash
./gradlew bootRun
```

### Build

```bash
./gradlew build
```

### Executar JAR

```bash
./gradlew build
java -jar build/libs/calculator-api-1.0.0.jar
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
├── build.gradle.kts             # Dependências Gradle
└── README.md
```

## Porta Padrão

A API roda na porta **3001** por padrão.

## Migração de Dados

O Spring Boot criará automaticamente as tabelas no PostgreSQL na primeira execução (usando `ddl-auto: update`).

Para migrar dados do SQLite antigo, você pode usar um script de migração ou fazer manualmente.

# calculator-api
