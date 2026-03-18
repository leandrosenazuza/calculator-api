#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$SCRIPT_DIR/../calculator-app"
POSTGRES_DB="calculator_db"
POSTGRES_USER="${DB_USERNAME:-postgres}"
POSTGRES_PASSWORD="${DB_PASSWORD:-postgres}"
POSTGRES_PORT=5433
REQUIRED_NODE_VERSION="20.17.0"

cd "$SCRIPT_DIR" || exit 1

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║                                                                       ║"
echo "║                    █████╗ ██████╗ ██╗                                ║"
echo "║                   ██╔══██╗██╔══██╗██║                                ║"
echo "║                   ███████║██████╔╝██║                                ║"
echo "║                   ██╔══██║██╔═══╝ ██║                                ║"
echo "║                   ██║  ██║██║     ██║                                ║"
echo "║                   ╚═╝  ╚═╝╚═╝     ╚═╝                                ║"
echo "║                                                                       ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

## Docker-related helpers (currently not in use)
#isDockerRunning() {
#    docker ps > /dev/null 2>&1
#}

isApiRunning() {
    lsof -i :8080 -sTCP:LISTEN > /dev/null 2>&1
}

loadNvm() {
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

    if [ -s "$NVM_DIR/nvm.sh" ]; then
        # shellcheck disable=SC1090
        . "$NVM_DIR/nvm.sh"
        return 0
    fi

    return 1
}

nodeVersionAtLeast() {
    current_version="$1"
    required_version="$2"

    if [ "$(printf '%s\n%s\n' "$required_version" "$current_version" | sort -V | head -n1)" = "$required_version" ]; then
        return 0
    fi

    return 1
}

ensureNodeVersion() {
    if ! command -v node > /dev/null 2>&1; then
        echo "ERROR: Node.js is not installed."
        exit 1
    fi

    current_node_version="$(node -v | sed 's/^v//')"

    if nodeVersionAtLeast "$current_node_version" "$REQUIRED_NODE_VERSION"; then
        echo "Node.js $current_node_version is compatible."
        return 0
    fi

    echo "Node.js $current_node_version is not compatible. Trying to switch to $REQUIRED_NODE_VERSION..."

    if loadNvm; then
        if nvm install "$REQUIRED_NODE_VERSION" > /dev/null 2>&1 && nvm use "$REQUIRED_NODE_VERSION" > /dev/null 2>&1; then
            echo "Node.js $(node -v) is now active."
            return 0
        fi
    fi

    echo "ERROR: Please install Node.js $REQUIRED_NODE_VERSION or newer before starting the frontend."
    exit 1
}

startLocalPostgres() {
    echo "Starting local PostgreSQL..."

    if command -v systemctl > /dev/null 2>&1; then
        sudo systemctl start postgresql
    elif command -v service > /dev/null 2>&1; then
        sudo service postgresql start
    else
        echo "ERROR: Unable to start local PostgreSQL automatically."
        exit 1
    fi

    sleep 3
}

waitForLocalPostgres() {
    echo "Waiting for local PostgreSQL to be healthy..."

    for i in {1..12}; do
        if PGPASSWORD="$POSTGRES_PASSWORD" pg_isready -h localhost -p "$POSTGRES_PORT" -U "$POSTGRES_USER" > /dev/null 2>&1; then
            echo "Local PostgreSQL is ready!"
            return 0
        fi

        if [ "$i" -eq 12 ]; then
            echo "ERROR: Local PostgreSQL did not become ready in time!"
            exit 1
        fi

        echo "Waiting... ($i/12)"
        sleep 5
    done
}

ensureLocalDatabase() {
    if ! command -v psql > /dev/null 2>&1 || ! command -v createdb > /dev/null 2>&1; then
        echo "WARNING: psql or createdb is not available. Skipping local database check."
        return 0
    fi

    if ! PGPASSWORD="$POSTGRES_PASSWORD" psql -h localhost -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'" | grep -q 1; then
        echo "Creating local database $POSTGRES_DB..."
        PGPASSWORD="$POSTGRES_PASSWORD" createdb -h localhost -p "$POSTGRES_PORT" -U "$POSTGRES_USER" "$POSTGRES_DB"
    fi
}

#startDockerPostgres() {
#    echo "Docker is running. Starting PostgreSQL container..."
#    if ! docker-compose up -d db; then
#        echo "Docker PostgreSQL failed to start."
#        return 1
#    fi
#
#    echo "Waiting for PostgreSQL container to be healthy..."
#    for i in {1..12}; do
#        if docker-compose exec -T db pg_isready -U postgres > /dev/null 2>&1; then
#            echo "PostgreSQL is ready!"
#            return 0
#        fi
#
#        if [ "$i" -eq 12 ]; then
#            echo "ERROR: PostgreSQL did not become ready in time!"
#            return 1
#        fi
#
#        echo "Waiting... ($i/12)"
#        sleep 5
#    done
#
#    return 1
#}
#
#stopDockerPostgres() {
#    if command -v docker-compose > /dev/null 2>&1; then
#        docker-compose down > /dev/null 2>&1
#    fi
#}

waitForApi() {
    echo "Waiting for backend to be ready..."

    for i in {1..12}; do
        if isApiRunning; then
            echo "Backend is ready!"
            return 0
        fi

        if [ "$i" -eq 12 ]; then
            echo "ERROR: Backend did not become ready in time!"
            exit 1
        fi

        echo "Waiting... ($i/12)"
        sleep 5
    done
}

# Always use local PostgreSQL (Docker disabled)
startLocalPostgres
waitForLocalPostgres
ensureLocalDatabase
SPRING_DATASOURCE_URL="jdbc:postgresql://localhost:${POSTGRES_PORT}/calculator_db"
SPRING_DATASOURCE_USERNAME="$POSTGRES_USER"
SPRING_DATASOURCE_PASSWORD="$POSTGRES_PASSWORD"

if isApiRunning; then
    echo "Backend is running."
else
    echo "Backend is not running. Starting it in the background..."
    SPRING_DATASOURCE_URL="$SPRING_DATASOURCE_URL" \
    SPRING_DATASOURCE_USERNAME="$SPRING_DATASOURCE_USERNAME" \
    SPRING_DATASOURCE_PASSWORD="$SPRING_DATASOURCE_PASSWORD" \
    sh ./gradlew bootRun > /tmp/calculator-api.log 2>&1 &
    BACKEND_PID=$!
    echo "Backend started in background (PID: $BACKEND_PID)."
    waitForApi
fi

echo "Starting frontend..."
cd "$APP_DIR" || exit 1
ensureNodeVersion
npm run dev