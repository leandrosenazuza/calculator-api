#!/bin/bash

# Script para parar os serviços Docker
# Execute este script a partir da raiz do projeto ou de dentro de calculator-api

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Obtém o diretório do script (calculator-api)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}🛑 Parando serviços...${NC}\n"

# Para PostgreSQL (Docker)
cd "$SCRIPT_DIR"
if docker-compose ps postgres | grep -q "Up" 2>/dev/null || docker compose ps postgres | grep -q "Up" 2>/dev/null; then
    echo -e "${GREEN}🐳 Parando PostgreSQL...${NC}"
    if command -v docker-compose &> /dev/null; then
        docker-compose down
    else
        docker compose down
    fi
else
    echo -e "${BLUE}ℹ️  PostgreSQL já está parado${NC}"
fi

echo -e "\n${GREEN}✅ Serviços parados!${NC}"

