#!/usr/bin/env bash

# ============================================================
#                    NEELCRAFT
#              ALL-IN-ONE VPS TOOL
#                  Made By - Neel
# ============================================================

set -u

# ============================================================
# COLORS
# ============================================================

GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
RED='\033[0;31m'
RESET='\033[0m'

# ============================================================
# BASIC FUNCTIONS
# ============================================================

clear_screen() {
    clear
}

line() {
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

pause_screen() {
    echo
    read -rp "Press Enter to continue..."
}

require_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo
        echo -e "${RED}✗ Root access is required.${RESET}"
        echo
        echo "Run this script using:"
        echo
        echo "sudo bash install.sh"
        echo
        exit 1
    fi
}

# ============================================================
# BANNER
# ============================================================

banner() {

    clear_screen

    echo -e "${GREEN}"

    cat <<'EOF'

███╗   ██╗███████╗███████╗██╗         ██████╗██████╗  █████╗ ███████╗████████╗
████╗  ██║██╔════╝██╔════╝██║        ██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
██╔██╗ ██║█████╗  █████╗  ██║        ██║     ██████╔╝███████╗█████╗     ██║
██║╚██╗██║██╔══╝  ██╔══╝  ██║        ██║     ██╔══██╗██╔══██║██╔══╝     ██║
██║ ╚████║███████╗███████╗███████╗    ╚██████╗██║  ██║██║  ██║██║        ██║
╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝     ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝

EOF

    echo -e "${RESET}"
    echo -e "${LIGHT_GREEN}                 Made By - Neel${RESET}"
    echo
    line
}

# ============================================================
# INSTALL DOCKER
# ============================================================

install_docker() {

    banner

    echo -e "${LIGHT_GREEN}              INSTALLING DOCKER${RESET}"
    echo

    if command -v docker >/dev/null 2>&1; then

        echo -e "${GREEN}✓ Docker is already installed.${RESET}"
        docker --version

        pause_screen
        return
    fi

    apt-get update

    apt-get install -y \
        ca-certificates \
        curl \
        gnupg

    install -m 0755 -d /etc/apt/keyrings

    curl -fsSL https://download.docker.com/linux/debian/gpg \
        -o /etc/apt/keyrings/docker.asc

    chmod a+r /etc/apt/keyrings/docker.asc

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
        > /etc/apt/sources.list.d/docker.list

    apt-get update

    apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

    systemctl enable docker
    systemctl start docker

    echo
    echo -e "${GREEN}✓ Docker installed successfully.${RESET}"

    docker --version

    pause_screen
}

# ============================================================
# INSTALL GIT
# ============================================================

install_git() {

    banner

    echo -e "${LIGHT_GREEN}                INSTALLING GIT${RESET}"
    echo

    apt-get update
    apt-get install -y git

    echo
    echo -e "${GREEN}✓ Git installed successfully.${RESET}"

    git --version

    pause_screen
}

# ============================================================
# INSTALL JAVA
# ============================================================

install_java() {

    banner

    echo -e "${LIGHT_GREEN}               INSTALLING JAVA${RESET}"
    echo

    echo "1) Java 17"
    echo "2) Java 21"

    echo

    read -rp "Select → " choice

    case "$choice" in

        1)
            apt-get update
            apt-get install -y openjdk-17-jdk
            ;;

        2)
            apt-get update
            apt-get install -y openjdk-21-jdk
            ;;

        *)
            echo -e "${RED}✗ Invalid option.${RESET}"
            pause_screen
            return
            ;;

    esac

    echo
    echo -e "${GREEN}✓ Java installed.${RESET}"

    java -version

    pause_screen
}

# ============================================================
# INSTALL NODE.JS
# ============================================================

install_nodejs() {

    banner

    echo -e "${LIGHT_GREEN}             INSTALLING NODE.JS${RESET}"
    echo

    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

    apt-get install -y nodejs

    echo
    echo -e "${GREEN}✓ Node.js installed.${RESET}"

    node -v
    npm -v

    pause_screen
}

# ============================================================
# INSTALL PYTHON
# ============================================================

install_python() {

    banner

    echo -e "${LIGHT_GREEN}             INSTALLING PYTHON${RESET}"
    echo

    apt-get update

    apt-get install -y \
        python3 \
        python3-pip \
        python3-venv

    echo
    echo -e "${GREEN}✓ Python installed.${RESET}"

    python3 --version

    pause_screen
}

# ============================================================
# INSTALL NGINX
# ============================================================

install_nginx() {

    banner

    echo -e "${LIGHT_GREEN}              INSTALLING NGINX${RESET}"
    echo

    apt-get update
    apt-get install -y nginx

    systemctl enable nginx
    systemctl start nginx

    echo
    echo -e "${GREEN}✓ Nginx installed successfully.${RESET}"

    pause_screen
}

# ============================================================
# INSTALL MARIADB
# ============================================================

install_mariadb() {

    banner

    echo -e "${LIGHT_GREEN}             INSTALLING MARIADB${RESET}"
    echo

    apt-get update
    apt-get install -y mariadb-server

    systemctl enable mariadb
    systemctl start mariadb

    echo
    echo -e "${GREEN}✓ MariaDB installed successfully.${RESET}"

    pause_screen
}

# ============================================================
# INSTALL REDIS
# ============================================================

install_redis() {

    banner

    echo -e "${LIGHT_GREEN}               INSTALLING REDIS${RESET}"
    echo

    apt-get update
    apt-get install -y redis-server

    systemctl enable redis-server
    systemctl start redis-server

    echo
    echo -e "${GREEN}✓ Redis installed successfully.${RESET}"

    pause_screen
}

# ============================================================
# DATABASE MENU
# ============================================================

database_menu() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}              DATABASE SETUP${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Install MariaDB"
        echo -e "${GREEN}2)${RESET} Install Redis"
        echo -e "${GREEN}3)${RESET} Back"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            1)
                install_mariadb
                ;;

            2)
                install_redis
                ;;

            3)
                return
                ;;

            *)
                echo -e "${RED}✗ Invalid option.${RESET}"
                sleep 1
                ;;

        esac

    done
}

# ============================================================
# TOOLS MENU
# ============================================================

tools_menu() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}                    TOOLS${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Install Docker"
        echo -e "${GREEN}2)${RESET} Install Git"
        echo -e "${GREEN}3)${RESET} Install Java"
        echo -e "${GREEN}4)${RESET} Install Node.js"
        echo -e "${GREEN}5)${RESET} Install Python"
        echo -e "${GREEN}6)${RESET} Install Nginx"
        echo -e "${GREEN}7)${RESET} Database Setup"
        echo -e "${GREEN}8)${RESET} System Information"
        echo -e "${GREEN}9)${RESET} Back"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            1)
                install_docker
                ;;

            2)
                install_git
                ;;

            3)
                install_java
                ;;

            4)
                install_nodejs
                ;;

            5)
                install_python
                ;;

            6)
                install_nginx
                ;;

            7)
                database_menu
                ;;

            8)
                system_information
                ;;

            9)
                return
                ;;

            *)
                echo -e "${RED}✗ Invalid option.${RESET}"
                sleep 1
                ;;

        esac

    done
}

# ============================================================
# CLOUDFLARED INSTALL
# ============================================================

install_cloudflared() {

    banner

    echo -e "${LIGHT_GREEN}          INSTALLING CLOUDFLARED${RESET}"
    echo

    if command -v cloudflared >/dev/null 2>&1; then

        echo -e "${GREEN}✓ Cloudflared is already installed.${RESET}"
        echo

        cloudflared --version

        pause_screen
        return

    fi

    apt-get update

    apt-get install -y \
        curl \
        wget \
        gnupg

    mkdir -p --mode=0755 /usr/share/keyrings

    curl -fsSL \
        https://pkg.cloudflare.com/cloudflare-main.gpg \
        -o /usr/share/keyrings/cloudflare-main.gpg

    if [ $? -ne 0 ]; then

        echo
        echo -e "${RED}✗ Failed to download Cloudflare key.${RESET}"

        pause_screen
        return

    fi

    echo \
        "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" \
        > /etc/apt/sources.list.d/cloudflared.list

    apt-get update

    apt-get install -y cloudflared

    echo

    if command -v cloudflared >/dev/null 2>&1; then

        echo -e "${GREEN}✓ Cloudflared installed successfully.${RESET}"
        echo

        cloudflared --version

    else

        echo -e "${RED}✗ Cloudflared installation failed.${RESET}"

    fi

    pause_screen
}

# ============================================================
# CLOUDFLARE TUNNEL SETUP
# ============================================================

setup_cloudflare_tunnel() {

    banner

    echo -e "${LIGHT_GREEN}           CLOUDFLARE TUNNEL SETUP${RESET}"
    echo

    if ! command -v cloudflared >/dev/null 2>&1; then

        echo -e "${YELLOW}Cloudflared is not installed.${RESET}"
        echo

        install_cloudflared

    fi

    if ! command -v cloudflared >/dev/null 2>&1; then

        echo -e "${RED}✗ Cloudflared installation is required.${RESET}"

        pause_screen
        return

    fi

    banner

    echo -e "${LIGHT_GREEN}           CLOUDFLARE TUNNEL SETUP${RESET}"
    echo

    echo -e "${CYAN}Steps:${RESET}"
    echo

    echo "1. Open Cloudflare Dashboard"
    echo "2. Go to Networking"
    echo "3. Go to Tunnels"
    echo "4. Create a Tunnel"
    echo "5. Select Cloudflared"
    echo "6. Copy the Tunnel Token"

    echo
    line
    echo

    read -rp "Paste Tunnel Token: " TUNNEL_TOKEN

    if [ -z "$TUNNEL_TOKEN" ]; then

        echo
        echo -e "${RED}✗ Tunnel token cannot be empty.${RESET}"

        pause_screen
        return

    fi

    echo
    echo -e "${YELLOW}Installing tunnel service...${RESET}"
    echo

    systemctl stop cloudflared 2>/dev/null || true
    systemctl disable cloudflared 2>/dev/null || true

    cloudflared service uninstall 2>/dev/null || true

    cloudflared service install "$TUNNEL_TOKEN"

    if [ $? -ne 0 ]; then

        echo
        echo -e "${RED}✗ Tunnel installation failed.${RESET}"

        pause_screen
        return

    fi

    systemctl daemon-reload

    systemctl enable cloudflared

    systemctl restart cloudflared

    sleep 3

    echo

    if systemctl is-active --quiet cloudflared; then

        echo -e "${GREEN}✓ CLOUDFLARE TUNNEL IS RUNNING!${RESET}"

    else

        echo -e "${RED}✗ Tunnel failed to start.${RESET}"
        echo

        journalctl -u cloudflared \
            --no-pager \
            -n 20

    fi

    pause_screen
}

# ============================================================
# CLOUDFLARE STATUS
# ============================================================

cloudflare_status() {

    banner

    echo -e "${LIGHT_GREEN}           CLOUDFLARE TUNNEL STATUS${RESET}"
    echo

    if ! command -v cloudflared >/dev/null 2>&1; then

        echo -e "${RED}✗ Cloudflared is not installed.${RESET}"

        pause_screen
        return

    fi

    cloudflared --version

    echo
    line
    echo

    systemctl status cloudflared \
        --no-pager

    pause_screen
}

# ============================================================
# RESTART CLOUDFLARE
# ============================================================

restart_cloudflare() {

    banner

    echo -e "${LIGHT_GREEN}          RESTARTING CLOUDFLARE${RESET}"
    echo

    systemctl restart cloudflared

    sleep 2

    if systemctl is-active --quiet cloudflared; then

        echo -e "${GREEN}✓ Tunnel restarted successfully.${RESET}"

    else

        echo -e "${RED}✗ Tunnel restart failed.${RESET}"

    fi

    pause_screen
}

# ============================================================
# STOP CLOUDFLARE
# ============================================================

stop_cloudflare() {

    banner

    echo -e "${RED}            STOP CLOUDFLARE TUNNEL${RESET}"
    echo

    read -rp "Are you sure? [Y/n]: " CONFIRM

    if [[ "$CONFIRM" =~ ^[Nn]$ ]]; then

        return

    fi

    systemctl stop cloudflared

    echo
    echo -e "${GREEN}✓ Tunnel stopped.${RESET}"

    pause_screen
}

# ============================================================
# REMOVE CLOUDFLARE
# ============================================================

remove_cloudflare_tunnel() {

    banner

    echo -e "${RED}          REMOVE CLOUDFLARE TUNNEL${RESET}"
    echo

    read -rp "Are you sure? [Y/n]: " CONFIRM

    if [[ "$CONFIRM" =~ ^[Nn]$ ]]; then

        return

    fi

    systemctl stop cloudflared 2>/dev/null || true

    systemctl disable cloudflared 2>/dev/null || true

    cloudflared service uninstall 2>/dev/null || true

    systemctl daemon-reload

    echo
    echo -e "${GREEN}✓ Tunnel service removed.${RESET}"

    pause_screen
}

# ============================================================
# CLOUDFLARE MENU
# ============================================================

cloudflare_menu() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}             CLOUDFLARE TUNNEL${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Install Cloudflared"
        echo -e "${GREEN}2)${RESET} Setup Tunnel"
        echo -e "${GREEN}3)${RESET} Check Tunnel Status"
        echo -e "${GREEN}4)${RESET} Restart Tunnel"
        echo -e "${GREEN}5)${RESET} Stop Tunnel"
        echo -e "${GREEN}6)${RESET} Remove Tunnel"
        echo -e "${GREEN}7)${RESET} Back"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            1)
                install_cloudflared
                ;;

            2)
                setup_cloudflare_tunnel
                ;;

            3)
                cloudflare_status
                ;;

            4)
                restart_cloudflare
                ;;

            5)
                stop_cloudflare
                ;;

            6)
                remove_cloudflare_tunnel
                ;;

            7)
                return
                ;;

            *)
                echo -e "${RED}✗ Invalid option.${RESET}"
                sleep 1
                ;;

        esac

    done
}

# ============================================================
# SYSTEM INFORMATION
# ============================================================

system_information() {

    banner

    echo -e "${LIGHT_GREEN}             SYSTEM INFORMATION${RESET}"
    echo

    echo -e "${CYAN}Hostname:${RESET}"
    hostname

    echo

    echo -e "${CYAN}Operating System:${RESET}"
    cat /etc/os-release | grep PRETTY_NAME

    echo

    echo -e "${CYAN}Kernel:${RESET}"
    uname -r

    echo

    echo -e "${CYAN}CPU:${RESET}"
    nproc

    echo

    echo -e "${CYAN}Memory:${RESET}"
    free -h

    echo

    echo -e "${CYAN}Disk:${RESET}"
    df -h /

    echo

    pause_screen
}

# ============================================================
# VPS MAKER
# ============================================================

vps_maker() {

    banner

    echo -e "${LIGHT_GREEN}                  VPS MAKER${RESET}"
    echo

    echo -e "${YELLOW}VPS Maker module is currently under development.${RESET}"
    echo

    echo "This VPS must support nested virtualization"
    echo "and have /dev/kvm available."

    echo
    echo

    if [ -e /dev/kvm ]; then

        echo -e "${GREEN}✓ KVM is available.${RESET}"

    else

        echo -e "${RED}✗ KVM is not available on this VPS.${RESET}"

    fi

    pause_screen
}

# ============================================================
# SYSTEM EDIT
# ============================================================

system_edit() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}                 SYSTEM EDIT${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Change Hostname"
        echo -e "${GREEN}2)${RESET} View Timezone"
        echo -e "${GREEN}3)${RESET} Back"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            1)

                echo
                read -rp "New hostname: " NEW_HOSTNAME

                if [ -n "$NEW_HOSTNAME" ]; then

                    hostnamectl set-hostname "$NEW_HOSTNAME"

                    echo
                    echo -e "${GREEN}✓ Hostname changed.${RESET}"

                fi

                pause_screen
                ;;

            2)

                timedatectl status

                pause_screen
                ;;

            3)

                return
                ;;

            *)

                echo -e "${RED}✗ Invalid option.${RESET}"

                sleep 1
                ;;

        esac

    done
}

# ============================================================
# PANEL MENU
# ============================================================

panel_menu() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}                    PANEL${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Pterodactyl Panel"
        echo -e "${GREEN}2)${RESET} Back"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            1)

                echo
                echo -e "${YELLOW}Pterodactyl installer module.${RESET}"
                echo

                echo "Your existing Pterodactyl installer"
                echo "can be connected here."

                pause_screen
                ;;

            2)

                return
                ;;

            *)

                echo -e "${RED}✗ Invalid option.${RESET}"

                sleep 1
                ;;

        esac

    done
}

# ============================================================
# MAIN MENU
# ============================================================

main_menu() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}                  MAIN MENU${RESET}"
        echo

        echo -e "${GREEN}A)${RESET} Panel"
        echo -e "${GREEN}B)${RESET} VPS Maker"
        echo -e "${GREEN}C)${RESET} Tools"
        echo -e "${GREEN}D)${RESET} Cloudflare Tunnel"
        echo -e "${GREEN}E)${RESET} System Edit"
        echo -e "${GREEN}F)${RESET} System Information"
        echo -e "${GREEN}G)${RESET} Exit"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            A|a)
                panel_menu
                ;;

            B|b)
                vps_maker
                ;;

            C|c)
                tools_menu
                ;;

            D|d)
                cloudflare_menu
                ;;

            E|e)
                system_edit
                ;;

            F|f)
                system_information
                ;;

            G|g)

                clear_screen

                echo
                echo -e "${LIGHT_GREEN}Thanks for using NEELCRAFT!${RESET}"
                echo

                exit 0
                ;;

            *)

                echo
                echo -e "${RED}✗ Invalid option.${RESET}"

                sleep 1
                ;;

        esac

    done
}

# ============================================================
# START
# ============================================================

require_root

main_menu
