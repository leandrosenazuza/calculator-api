#!/bin/bash

# Script para parar o banco de dados e a API

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}🛑 Parando serviços...${NC}\n"

echo -e "${GREEN}📦 Parando calculator-api...${NC}"
pkill -f "gradlew.*bootRun" 2>/dev/null || pkill -f "java.*calculator.*api" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${BLUE}✅ API parada${NC}"
else
    echo -e "${BLUE}ℹ️  API não estava rodando${NC}"
fi

cd "$SCRIPT_DIR"
if docker compose ps postgres 2>/dev/null | grep -q "running"; then
    echo -e "${GREEN}🐳 Parando PostgreSQL...${NC}"
    docker compose down
    echo -e "${BLUE}✅ PostgreSQL parado${NC}"
else
    echo -e "${BLUE}ℹ️  PostgreSQL já está parado${NC}"
fi

echo -e "\n${GREEN}✅ Todos os serviços parados!${NC}"
