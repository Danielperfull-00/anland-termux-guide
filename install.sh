#!/bin/bash
set -e

# Colores para la salida
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}🚀 Instalador Universal de Anland Termux v5.13.0${NC}"
echo -e "${BLUE}====================================================${NC}"

# 1. Actualizar Termux
echo -e "\n${YELLOW}[1/6] Actualizando Termux...${NC}"
pkg update -y && pkg upgrade -y

# 2. Instalar herramientas base
echo -e "\n${YELLOW}[2/6] Instalando herramientas base...${NC}"
pkg install proot-distro wget curl unzip -y

# 3. Preguntar Distro
echo -e "\n${BLUE}¿Qué distribución deseas instalar?${NC}"
echo -e "1) Debian 13 (Ligero y Estable)"
echo -e "2) Ubuntu 26.04 (Recomendado para principiantes)"

DISTRO_CHOICE=""
while [[ "$DISTRO_CHOICE" != "1" && "$DISTRO_CHOICE" != "2" ]]; do
    read -p "Tu elección [1 o 2]: " DISTRO_CHOICE < /dev/tty
    if [[ "$DISTRO_CHOICE" != "1" && "$DISTRO_CHOICE" != "2" ]]; then
        echo -e "${RED}Opción no válida. Por favor, escribe 1 o 2.${NC}"
    fi
done

if [ "$DISTRO_CHOICE" == "2" ]; then
    DISTRO="ubuntu"
    XWAYLAND_FILE="xwayland_24.1.10-91_arm64.deb"
    KWIN_FILE="kwin_anland-5.8-4_6.6.4-0ubuntu92.zip"
    HOLD_PKGS="xwayland kwin-common kwin-data kwin-wayland libkwin6 libegl-mesa0 libgbm1 libgl1-mesa-dri libglx-mesa0 mesa-libgallium mesa-vulkan-drivers"
else
    DISTRO="debian"
    XWAYLAND_FILE="xwayland_24.1.6-91_arm64.deb"
    KWIN_FILE="kwin_anland-5.8-debian-4_6.3.6-92.zip"
    HOLD_PKGS="xwayland kwin-common kwin-data kwin-wayland libkwin6 libegl-mesa0 libgbm1 libgl1-mesa-dri libglx-mesa0 mesa-libgallium mesa-vulkan-drivers"
fi

# 4. Instalar la Distro elegida
echo -e "\n${YELLOW}[3/6] Instalando $DISTRO via proot-distro...${NC}"
if proot-distro install $DISTRO; then
    echo -e "${GREEN}✓ $DISTRO instalado correctamente.${NC}"
else
    echo -e "${YELLOW}$DISTRO ya estaba instalado. Continuando...${NC}"
fi

# 5. Instalar Anland Base en Termux
echo -e "\n${YELLOW}[4/6] Buscando Anland Base (.deb)...${NC}"
if [ -f "anland_5.11.0_aarch64.deb" ]; then
    echo -e "📦 Instalando anland_5.11.0_aarch64.deb..."
    pkg install ./anland_5.11.0_aarch64.deb
else
    echo -e "${YELLOW}⚠️  No se encontró 'anland_5.11.0_aarch64.deb' en el home.${NC}"
fi

# 6. Configuración Completa dentro de la Distro (Drivers + XWayland + KWin)
echo -e "\n${YELLOW}[5/6] Configurando entorno interno de $DISTRO...${NC}"
proot-distro login $DISTRO -- bash -c "
    apt update && apt upgrade -y
    apt install wget unzip -y

    echo '--- Instalando Driver Freedreno ---'
    wget https://github.com/lfdevs/mesa-for-android-container/releases/download/mesa-26.2.0-devel-20260709/mesa-26.2.0-devel-20260709.deb -O mesa.deb
    apt install ./mesa.deb -y
    rm mesa.deb

    echo '--- Instalando XWayland y KWin ---'
    wget https://github.com/lfdevs/anland-termux/releases/download/5.13.0/$XWAYLAND_FILE -O xwayland.deb
    wget https://github.com/lfdevs/anland-termux/releases/download/5.13.0/$KWIN_FILE -O kwin.zip
    
    apt install ./xwayland.deb -y
    unzip -o kwin.zip -d kwin-install/
    apt install kwin-install/*.deb -y
    
    rm -rf kwin-install xwayland.deb kwin.zip

    echo '--- Bloqueando paquetes para evitar roturas ---'
    apt-mark hold $HOLD_PKGS
    
    echo 'Configuración de $DISTRO completada con éxito.'
"

echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}✅ ¡INSTALACIÓN TOTAL COMPLETADA!${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "\n${YELLOW}ÚLTIMOS PASOS PARA TU S21 ULTRA:${NC}"
echo -e "1. Instala el APK: ${GREEN}AnlandTermux-5.13.0.apk${NC}"
echo -e "2. En Termux, inicia el daemon: ${GREEN}anland > /dev/null 2>&1 &${NC}"
echo -e "3. ¡Disfruta de tu escritorio Linux! 🚀"
echo -e "\n📖 Guía: https://github.com/Danielperfull-00/anland-termux-guide"
