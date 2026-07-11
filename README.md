# Guía de Instalación de Anland Termux (v5.13.0)

## ⚡ Instalación Automática (Recomendado)

Si quieres instalar todo de una sola vez (Actualización de Termux + Ubuntu/Debian + Drivers), ejecuta este comando en tu terminal:

```bash
curl -sSL https://raw.githubusercontent.com/Danielperfull-00/anland-termux-guide/main/install.sh | bash
```

---

## 📋 Instalación Manual

Esta guía proporciona instrucciones paso a paso para instalar y ejecutar Anland en Termux, basándose en la versión 5.13.0.


### 1. Instalación en Android
Descarga e instala el APK oficial:
- `AnlandTermux-5.13.0.apk`

### 2. Instalación en Termux
Ejecuta el siguiente comando para instalar el paquete base:
```bash
pkg install ./anland_5.11.0_aarch64.deb
```

---

## 🚀 Opciones Avanzadas (Opcionales)

### A. En Contenedores (Ubuntu 26.04 / Debian 13 PRoot/Chroot/LXC)
1. **Driver Freedreno:** Instala primero el driver Freedreno parcheado ([Descargar aquí](https://github.com/lfdevs/mesa-for-android-container/releases/tag/mesa-26.2.0-devel-20260709)).
2. **Ubuntu 26.04:**
   ```bash
   sudo apt reinstall ./xwayland_24.1.10-91_arm64.deb
   unzip kwin_anland-5.8-4_6.6.4-0ubuntu92.zip -d kwin-debs-install/
   sudo apt reinstall kwin-debs-install/*.deb
   rm -rf kwin-debs-install/
   sudo apt-mark hold xwayland kwin-common kwin-data kwin-wayland libkwin6 libegl-mesa0 libgbm1 libgl1-mesa-dri libglx-mesa0 mesa-libgallium mesa-vulkan-drivers
   ```
3. **Debian 13:**
   ```bash
   sudo apt reinstall ./xwayland_24.1.6-91_arm64.deb
   unzip kwin_anland-5.8-debian-4_6.3.6-92.zip -d kwin-debs-install/
   sudo apt reinstall kwin-debs-install/*.deb
   rm -rf kwin-debs-install/
   sudo apt-mark hold xwayland kwin-common kwin-data kwin-wayland libkwin6 libegl-mesa0 libgbm1 libgl1-mesa-dri libglx-mesa0 mesa-libgallium mesa-vulkan-drivers
   ```

### B. Termux Nativo (Con Aceleración de Hardware)
1. **Driver Freedreno:** Instala el driver parcheado desde los artefactos de [termux-packages](https://github.com/termux/termux-packages/actions/runs/29028703557?pr=30162#artifacts) (archivos `mesa_26.2.0-1_aarch64.deb` y `mesa-vulkan-icd-freedreno_26.2.0-1_aarch64.deb`).
2. **Entorno de Escritorio:**
   ```bash
   pkg install plasma-desktop konsole dolphin
   pkg install ./xwayland_24.1.12-2_aarch64.deb ./kwin-anland_6.7.2_aarch64.deb
   apt-mark hold xwayland mesa mesa-vulkan-icd-freedreno
   ```

---

## 🛠️ Uso y Ejecución

### Ejecución Básica en Termux
Para iniciar el daemon de Anland:
```bash
killall anland > /dev/null 2>&1
anland > /dev/null 2>&1 &
```

### Iniciando Plasma Wayland (Nativo en Termux)
Utiliza el siguiente script o comandos:
```bash
mkdir -p $TMPDIR/run
chmod -R 700 $TMPDIR/run
mkdir -p $TMPDIR/.X11-unix
chmod 1777 $TMPDIR/.X11-unix

killall anland > /dev/null 2>&1
anland > /dev/null 2>&1 &

killall plasmashell > /dev/null 2>&1; killall kwin_wayland > /dev/null 2>&1; killall startplasma > /dev/null 2>&1;
unset DISPLAY
unset PULSE_SERVER
export XDG_RUNTIME_DIR=$TMPDIR/run
export QT_QPA_PLATFORM=wayland XDG_CURRENT_DESKTOP=KDE XDG_SESSION_DESKTOP=KDE
export ANLAND_SOCKET=$TMPDIR/anland/display_daemon.sock ANLAND=1 ANLAND_NO_DRM_DEVICE=1 EGL_PLATFORM=surfaceless

# Para GPUs Adreno (Aceleración KGSL)
export MESA_LOADER_DRIVER_OVERRIDE=kgsl TURNIP_KMD=kgsl GALLIUM_DRIVER=freedreno FD_FORCE_KGSL=1 XWAYLAND_FORCE_KGSL_SURFACELESS=1

rm -f $XDG_RUNTIME_DIR/wayland-* > /dev/null 2>&1
dbus-run-session startplasma-wayland > /dev/null 2>&1
```

## 🔗 Enlaces Oficiales
- **Repositorio Oficial:** [lfdevs/anland-termux](https://github.com/lfdevs/anland-termux)
- **Versión 5.13.0:** [Releases](https://github.com/lfdevs/anland-termux/releases/tag/5.13.0)
