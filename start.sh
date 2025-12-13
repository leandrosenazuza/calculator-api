#!/bin/bash

# Script para iniciar calculator-api e calculator-app simultaneamente
# Execute este script a partir da raiz do projeto (onde estão calculator-api e calculator-app)

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Obtém o diretório do script (calculator-api)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}🚀 Iniciando calculator-api e calculator-app...${NC}\n"

# Verifica se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker não está instalado!${NC}"
    echo -e "${BLUE}💡 Instale Docker Desktop: https://www.docker.com/products/docker-desktop${NC}"
    exit 1
fi

# Verifica se docker-compose está disponível
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ docker-compose não está disponível!${NC}"
    exit 1
fi

# Inicia PostgreSQL via Docker (a partir do diretório da API)
echo -e "${GREEN}🐳 Iniciando PostgreSQL via Docker...${NC}"
cd "$SCRIPT_DIR"
if docker-compose ps postgres | grep -q "Up" 2>/dev/null || docker compose ps postgres | grep -q "Up" 2>/dev/null; then
    echo -e "${BLUE}✅ PostgreSQL já está rodando${NC}\n"
else
    # Tenta docker-compose primeiro, depois docker compose
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d postgres
    else
        docker compose up -d postgres
    fi
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Erro ao iniciar PostgreSQL${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}⏳ Aguardando PostgreSQL ficar pronto...${NC}"
    sleep 5
    echo -e "${GREEN}✅ PostgreSQL está rodando!${NC}\n"
fi

# Função para limpar processos ao sair
cleanup() {
    echo -e "\n${RED}🛑 Parando serviços...${NC}"
    kill $API_PID $APP_PID 2>/dev/null
    # Não para o PostgreSQL automaticamente (deixe rodando)
    # Para parar: cd calculator-api && docker-compose down
    exit
}

# Captura Ctrl+C
trap cleanup SIGINT SIGTERM

# Inicia a API (Spring Boot)
echo -e "${GREEN}📦 Iniciando calculator-api na porta 3001...${NC}"
cd "$SCRIPT_DIR"
./gradlew bootRun > "$PROJECT_ROOT/api.log" 2>&1 &
API_PID=$!

# Aguarda um pouco para a API iniciar
sleep 3

# Inicia o App (Vite)
echo -e "${GREEN}⚛️  Iniciando calculator-app na porta 5173...${NC}"
cd "$PROJECT_ROOT/calculator-app"
npm run dev > "$PROJECT_ROOT/app.log" 2>&1 &
APP_PID=$!

echo -e "\n${BLUE}✅ Serviços iniciados!${NC}"
echo -e "${GREEN}📊 API rodando em: http://localhost:3001${NC}"
echo -e "${GREEN}🌐 App rodando em: http://localhost:5173${NC}"
echo -e "\n${BLUE}📝 Logs:${NC}"
echo -e "  - API: tail -f $PROJECT_ROOT/api.log"
echo -e "  - App: tail -f $PROJECT_ROOT/app.log"
echo -e "\n${RED}Pressione Ctrl+C para parar ambos os serviços${NC}\n"

# Aguarda os processos
wait

