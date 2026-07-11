#!/bin/bash
set -e

# Colores para la salida
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}🚀 Instalador Automático de Anland Termux para S21 Ultra${NC}"
echo -e "${BLUE}====================================================${NC}"

# 1. Actualizar Termux
echo -e "\n${YELLOW}[1/5] Actualizando Termux...${NC}"
pkg update -y && pkg upgrade -y

# 2. Instalar herramientas base
echo -e "\n${YELLOW}[2/5] Instalando herramientas base (proot-distro, wget, etc)...${NC}"
pkg install proot-distro wget curl unzip -y

# 3. Instalar Ubuntu
echo -e "\n${YELLOW}[3/5] Instalando Ubuntu via proot-distro...${NC}"
if proot-distro install ubuntu; then
    echo -e "${GREEN}✓ Ubuntu instalado correctamente.${NC}"
else
    echo -e "${YELLOW}Ubuntu ya estaba instalado o hubo un problema menor. Continuando...${NC}"
fi

# 4. Instalar Anland Base en Termux
echo -e "\n${YELLOW}[4/5] Buscando Anland Base (.deb)...${NC}"
if [ -f "anland_5.11.0_aarch64.deb" ]; then
    echo -e "📦 Instalando anland_5.11.0_aarch64.deb..."
    pkg install ./anland_5.11.0_aarch64.deb
else
    echo -e "${YELLOW}⚠️  No se encontró 'anland_5.11.0_aarch64.deb' en el home. ${NC}"
    echo -e "Recuerda descargarlo para que el sistema funcione."
fi

# 5. Configuración interna de Ubuntu
echo -e "\n${YELLOW}[5/5] Configurando entorno interno de Ubuntu (Driver Freedreno)...${NC}"
proot-distro login ubuntu -- bash -c "
    apt update && apt upgrade -y
    apt install wget unzip -y

    echo 'Descargando e instalando Driver Freedreno...'
    wget https://github.com/lfdevs/mesa-for-android-container/releases/download/mesa-26.2.0-devel-20260709/mesa-26.2.0-devel-20260709.deb -O mesa.deb
    apt install ./mesa.deb -y
    rm mesa.deb

    echo 'Configuración de base de Ubuntu completada.'
"

echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}✅ ¡Instalación Base Completada!${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "\n${YELLOW}PASOS FINALES PARA TU S21 ULTRA:${NC}"
echo -e "1. Instala el APK: ${GREEN}AnlandTermux-5.13.0.apk${NC}"
echo -e "2. Ejecuta el daemon en Termux: ${GREEN}anland > /dev/null 2>&1 &${NC}"
echo -e "3. Entra a Ubuntu y termina de instalar XWayland y KWin siguiendo la guía."
echo -e "\n📖 Guía completa: https://github.com/Danielperfull-00/anland-termux-guide"
