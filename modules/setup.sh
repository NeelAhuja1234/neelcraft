#!/usr/bin/env bash

# ============================================================
#              NEELCRAFT VPS SETUP
# ============================================================

set -u
set -o pipefail

GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

BASE_DIR="/opt/neelcraft"

pause_screen() {
    echo
    read -rp "Press Enter to continue..."
}

require_root() {

    if [ "$(id -u)" -ne 0 ]; then

        echo -e "${RED}Root access required.${RESET}"
        exit 1

    fi
}

main() {

    clear

    echo -e "${LIGHT_GREEN}NEELCRAFT VPS DEPENDENCY SETUP${RESET}"
    echo

    require_root

    if ! command -v apt-get >/dev/null 2>&1; then

        echo -e "${RED}This module currently supports Debian/Ubuntu systems.${RESET}"
        exit 1

    fi

    echo -e "${GREEN}[1/3] Updating packages...${RESET}"

    apt-get update

    echo
    echo -e "${GREEN}[2/3] Installing dependencies...${RESET}"

    export DEBIAN_FRONTEND=noninteractive

    apt-get install -y \
        curl \
        wget \
        ca-certificates \
        qemu-system-x86 \
        qemu-utils \
        cloud-image-utils \
        openssh-client \
        iproute2 \
        net-tools \
        procps

    echo
    echo -e "${GREEN}[3/3] Creating directories...${RESET}"

    mkdir -p "$BASE_DIR/images"
    mkdir -p "$BASE_DIR/vms"
    mkdir -p "$BASE_DIR/cloud-init"

    echo
    echo -e "${LIGHT_GREEN}SETUP COMPLETED${RESET}"

    echo

    if [ -e /dev/kvm ]; then

        echo -e "${GREEN}✓ KVM detected.${RESET}"

    else

        echo -e "${YELLOW}⚠ /dev/kvm is not available.${RESET}"
        echo "You can use No-KVM mode."

    fi

    pause_screen
}

main
