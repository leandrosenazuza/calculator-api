#!/bin/bash

# Script para iniciar o banco de dados e a API
# Execute este script a partir do diretório calculator-api

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}🚀 Iniciando calculator-api...${NC}\n"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker não está instalado!${NC}"
    echo -e "${BLUE}💡 Instale Docker Desktop: https://www.docker.com/products/docker-desktop${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ docker-compose não está disponível!${NC}"
    exit 1
fi

echo -e "${GREEN}🐳 Iniciando PostgreSQL via Docker...${NC}"
cd "$SCRIPT_DIR"
if docker compose ps postgres 2>/dev/null | grep -q "running"; then
    echo -e "${BLUE}✅ PostgreSQL já está rodando${NC}\n"
else
    docker compose up -d postgres

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Erro ao iniciar PostgreSQL${NC}"
        exit 1
    fi

    echo -e "${BLUE}⏳ Aguardando PostgreSQL ficar pronto...${NC}"
    sleep 5
    echo -e "${GREEN}✅ PostgreSQL está rodando!${NC}\n"
fi

cleanup() {
    echo -e "\n${RED}🛑 Parando API...${NC}"
    kill $API_PID 2>/dev/null
    exit
}

trap cleanup SIGINT SIGTERM

echo -e "${GREEN}📦 Iniciando calculator-api na porta 3001...${NC}"
cd "$SCRIPT_DIR"
./gradlew bootRun &
API_PID=$!

wait $API_PID
