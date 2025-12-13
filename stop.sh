#!/bin/bash

# Script para parar os serviços Docker e processos da API/App
# Execute este script a partir da raiz do projeto ou de dentro de calculator-api

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Obtém o diretório do script (calculator-api)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}🛑 Parando serviços...${NC}\n"

# Para processos da API (Spring Boot)
echo -e "${GREEN}📦 Parando calculator-api...${NC}"
pkill -f "gradlew.*bootRun" 2>/dev/null || pkill -f "java.*calculator.*api" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${BLUE}✅ API parada${NC}"
else
    echo -e "${BLUE}ℹ️  API não estava rodando${NC}"
fi

# Para processos do App (Vite)
echo -e "${GREEN}⚛️  Parando calculator-app...${NC}"
pkill -f "vite" 2>/dev/null || pkill -f "node.*vite" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${BLUE}✅ App parado${NC}"
else
    echo -e "${BLUE}ℹ️  App não estava rodando${NC}"
fi

# Para PostgreSQL (Docker)
cd "$SCRIPT_DIR"
if docker-compose ps postgres | grep -q "Up" 2>/dev/null || docker compose ps postgres | grep -q "Up" 2>/dev/null; then
    echo -e "${GREEN}🐳 Parando PostgreSQL...${NC}"
    if command -v docker-compose &> /dev/null; then
        docker-compose down
    else
        docker compose down
    fi
    echo -e "${BLUE}✅ PostgreSQL parado${NC}"
else
    echo -e "${BLUE}ℹ️  PostgreSQL já está parado${NC}"
fi

echo -e "\n${GREEN}✅ Todos os serviços parados!${NC}"

