#!/usr/bin/env bash

# ============================================================
#                    NEELCRAFT
#              VPS MANAGEMENT TOOL
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
        echo "Run the script with:"
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
██╔██╗ ██║█████╗  █████╗  ██║        ██║     ██████╔╝███████║█████╗     ██║
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
# PANEL MENU
# ============================================================

panel_menu() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}                    PANEL${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Pterodactyl Panel"
        echo -e "${GREEN}2)${RESET} Air-Link Panel"
        echo -e "${GREEN}3)${RESET} Back to Main Menu"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            1)
                pterodactyl_menu
                ;;

            2)
                airlink_menu
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
# PTERODACTYL MENU
# ============================================================

pterodactyl_menu() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}             PTERODACTYL MANAGER${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Panel Installation"
        echo -e "${GREEN}2)${RESET} Wings Installation"
        echo -e "${GREEN}3)${RESET} Uninstall Tools"
        echo -e "${GREEN}4)${RESET} Blueprint + Theme + Extensions"
        echo -e "${GREEN}5)${RESET} Cloudflare Setup"
        echo -e "${GREEN}6)${RESET} System Information"
        echo -e "${GREEN}7)${RESET} Tailscale"
        echo -e "${GREEN}8)${RESET} Database Setup"
        echo -e "${GREEN}9)${RESET} Back"

        echo
        line

        read -rp "Select an option [1-9]: " option

        case "$option" in

            1)
                panel_install
                ;;

            2)
                wings_install
                ;;

            3)
                uninstall_tools
                ;;

            4)
                blueprint_menu
                ;;

            5)
                cloudflare_menu
                ;;

            6)
                system_information
                ;;

            7)
                tailscale_menu
                ;;

            8)
                database_menu
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
# PTERODACTYL PANEL INSTALLER
# ============================================================

panel_install() {

    banner

    echo -e "${LIGHT_GREEN}        PTERODACTYL PANEL INSTALLATION${RESET}"
    echo

    echo -e "${YELLOW}Pterodactyl installer module is not connected yet.${RESET}"
    echo

    echo "The final installer will perform:"
    echo
    echo "  • OS compatibility check"
    echo "  • Root access check"
    echo "  • PHP installation"
    echo "  • MariaDB/MySQL installation"
    echo "  • Redis installation"
    echo "  • Nginx configuration"
    echo "  • Composer setup"
    echo "  • Pterodactyl download"
    echo "  • Database configuration"
    echo "  • Queue configuration"
    echo "  • Cron configuration"
    echo "  • SSL configuration"
    echo

    echo -e "${GREEN}✓ Panel installation option selected.${RESET}"

    pause_screen
}

# ============================================================
# WINGS INSTALLER
# ============================================================

wings_install() {

    banner

    echo -e "${LIGHT_GREEN}           PTERODACTYL WINGS${RESET}"
    echo

    echo -e "${YELLOW}Wings installer module is not connected yet.${RESET}"
    echo

    echo "The final installer will perform:"
    echo
    echo "  • Docker installation"
    echo "  • Wings installation"
    echo "  • Configuration"
    echo "  • Systemd service setup"
    echo "  • Wings startup"

    echo
    echo -e "${GREEN}✓ Wings installation option selected.${RESET}"

    pause_screen
}

# ============================================================
# AIR-LINK
# ============================================================

airlink_menu() {

    banner

    echo -e "${LIGHT_GREEN}                 AIR-LINK PANEL${RESET}"
    echo

    echo "Air-Link Panel installer module."

    echo
    echo -e "${YELLOW}Installer will be added here.${RESET}"

    pause_screen
}

# ============================================================
# TOOLS MENU
# ============================================================

tools_menu() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}                    TOOLS${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Docker"
        echo -e "${GREEN}2)${RESET} Git"
        echo -e "${GREEN}3)${RESET} Java"
        echo -e "${GREEN}4)${RESET} Node.js"
        echo -e "${GREEN}5)${RESET} Python"
        echo -e "${GREEN}6)${RESET} Nginx"
        echo -e "${GREEN}7)${RESET} MariaDB"
        echo -e "${GREEN}8)${RESET} Redis"
        echo -e "${GREEN}9)${RESET} Back"

        echo
        line

        read -rp "Select → " tool

        case "$tool" in

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
                install_node
                ;;

            5)
                install_python
                ;;

            6)
                install_nginx
                ;;

            7)
                install_mariadb
                ;;

            8)
                install_redis
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
# DOCKER
# ============================================================

install_docker() {

    banner

    echo -e "${LIGHT_GREEN}              DOCKER INSTALLATION${RESET}"
    echo

    if command -v docker >/dev/null 2>&1; then

        echo -e "${GREEN}✓ Docker is already installed.${RESET}"

    else

        echo "Updating packages..."
        apt-get update

        echo
        echo "Installing Docker..."
        apt-get install -y docker.io

        systemctl enable --now docker

        echo
        echo -e "${GREEN}✓ Docker installed successfully.${RESET}"

    fi

    echo
    docker --version 2>/dev/null || true

    pause_screen
}

# ============================================================
# GIT
# ============================================================

install_git() {

    banner

    echo -e "${LIGHT_GREEN}                 GIT INSTALLATION${RESET}"
    echo

    apt-get update
    apt-get install -y git

    echo
    echo -e "${GREEN}✓ Git installed successfully.${RESET}"

    git --version 2>/dev/null || true

    pause_screen
}

# ============================================================
# JAVA
# ============================================================

install_java() {

    banner

    echo -e "${LIGHT_GREEN}                JAVA INSTALLATION${RESET}"
    echo

    apt-get update

    apt-get install -y openjdk-21-jre-headless

    echo
    echo -e "${GREEN}✓ Java installed successfully.${RESET}"
    echo

    java -version

    pause_screen
}

# ============================================================
# NODE.JS
# ============================================================

install_node() {

    banner

    echo -e "${LIGHT_GREEN}              NODE.JS INSTALLATION${RESET}"
    echo

    apt-get update

    apt-get install -y nodejs npm

    echo
    echo -e "${GREEN}✓ Node.js installed successfully.${RESET}"
    echo

    node --version 2>/dev/null || true
    npm --version 2>/dev/null || true

    pause_screen
}

# ============================================================
# PYTHON
# ============================================================

install_python() {

    banner

    echo -e "${LIGHT_GREEN}              PYTHON INSTALLATION${RESET}"
    echo

    apt-get update

    apt-get install -y python3 python3-pip

    echo
    echo -e "${GREEN}✓ Python installed successfully.${RESET}"
    echo

    python3 --version

    pause_screen
}

# ============================================================
# NGINX
# ============================================================

install_nginx() {

    banner

    echo -e "${LIGHT_GREEN}              NGINX INSTALLATION${RESET}"
    echo

    apt-get update

    apt-get install -y nginx

    systemctl enable --now nginx

    echo
    echo -e "${GREEN}✓ Nginx installed successfully.${RESET}"

    pause_screen
}

# ============================================================
# MARIADB
# ============================================================

install_mariadb() {

    banner

    echo -e "${LIGHT_GREEN}             MARIADB INSTALLATION${RESET}"
    echo

    apt-get update

    apt-get install -y mariadb-server

    systemctl enable --now mariadb

    echo
    echo -e "${GREEN}✓ MariaDB installed successfully.${RESET}"

    pause_screen
}

# ============================================================
# REDIS
# ============================================================

install_redis() {

    banner

    echo -e "${LIGHT_GREEN}              REDIS INSTALLATION${RESET}"
    echo

    apt-get update

    apt-get install -y redis-server

    systemctl enable --now redis-server

    echo
    echo -e "${GREEN}✓ Redis installed successfully.${RESET}"

    pause_screen
}

# ============================================================
# SYSTEM INFORMATION
# ============================================================

system_information() {

    banner

    echo -e "${LIGHT_GREEN}             SYSTEM INFORMATION${RESET}"
    echo

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME="$PRETTY_NAME"
    else
        OS_NAME="Unknown"
    fi

    echo -e "${GREEN}Hostname       :${RESET} $(hostname)"
    echo -e "${GREEN}OS             :${RESET} $OS_NAME"
    echo -e "${GREEN}Kernel         :${RESET} $(uname -r)"
    echo -e "${GREEN}Architecture   :${RESET} $(uname -m)"
    echo -e "${GREEN}CPU Cores      :${RESET} $(nproc)"
    echo -e "${GREEN}RAM            :${RESET} $(free -h | awk '/Mem:/ {print $2}')"
    echo -e "${GREEN}Disk           :${RESET} $(df -h / | awk 'NR==2 {print $2}')"
    echo -e "${GREEN}Used Disk      :${RESET} $(df -h / | awk 'NR==2 {print $3}')"
    echo -e "${GREEN}Free Disk      :${RESET} $(df -h / | awk 'NR==2 {print $4}')"
    echo -e "${GREEN}Uptime         :${RESET} $(uptime -p)"

    echo
    line

    pause_screen
}

# ============================================================
# UNINSTALL TOOLS
# ============================================================

uninstall_tools() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}              UNINSTALL TOOLS${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Remove Docker"
        echo -e "${GREEN}2)${RESET} Remove Nginx"
        echo -e "${GREEN}3)${RESET} Remove Redis"
        echo -e "${GREEN}4)${RESET} Remove Node.js"
        echo -e "${GREEN}5)${RESET} Back"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            1)
                apt-get remove -y docker.io
                echo -e "${GREEN}✓ Docker removed.${RESET}"
                pause_screen
                ;;

            2)
                apt-get remove -y nginx
                echo -e "${GREEN}✓ Nginx removed.${RESET}"
                pause_screen
                ;;

            3)
                apt-get remove -y redis-server
                echo -e "${GREEN}✓ Redis removed.${RESET}"
                pause_screen
                ;;

            4)
                apt-get remove -y nodejs npm
                echo -e "${GREEN}✓ Node.js removed.${RESET}"
                pause_screen
                ;;

            5)
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
# BLUEPRINT / THEME
# ============================================================

blueprint_menu() {

    banner

    echo -e "${LIGHT_GREEN}       BLUEPRINT / THEME / EXTENSIONS${RESET}"
    echo

    echo -e "${GREEN}1)${RESET} Blueprint"
    echo -e "${GREEN}2)${RESET} Theme"
    echo -e "${GREEN}3)${RESET} Extensions"
    echo -e "${GREEN}4)${RESET} Back"

    echo
    line

    read -rp "Select → " choice

    case "$choice" in

        1)
            echo
            echo "Blueprint module selected."
            ;;

        2)
            echo
            echo "Theme module selected."
            ;;

        3)
            echo
            echo "Extensions module selected."
            ;;

        4)
            return
            ;;

        *)
            echo -e "${RED}✗ Invalid option.${RESET}"
            ;;

    esac

    pause_screen
}

# ============================================================
# CLOUDFLARE
# ============================================================

cloudflare_menu() {

    banner

    echo -e "${LIGHT_GREEN}              CLOUDFLARE SETUP${RESET}"
    echo

    echo "Cloudflare setup module."

    echo
    echo "This module can later handle:"
    echo
    echo "  • Domain configuration"
    echo "  • DNS"
    echo "  • SSL"
    echo "  • Cloudflare API"
    echo

    pause_screen
}

# ============================================================
# TAILSCALE
# ============================================================

tailscale_menu() {

    banner

    echo -e "${LIGHT_GREEN}                 TAILSCALE${RESET}"
    echo

    echo "Tailscale setup module."

    echo
    echo -e "${YELLOW}Tailscale installer will be added here.${RESET}"

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

        echo -e "${GREEN}1)${RESET} MariaDB"
        echo -e "${GREEN}2)${RESET} Redis"
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
# VPS MAKER
# ============================================================

vps_maker() {

    banner

    echo -e "${LIGHT_GREEN}                  VPS MAKER${RESET}"
    echo

    echo -e "${YELLOW}VPS Maker module is currently under development.${RESET}"
    echo

    echo "Future features:"
    echo
    echo "  • VPS creation"
    echo "  • User management"
    echo "  • Resource allocation"
    echo "  • SSH management"
    echo "  • VPS monitoring"

    pause_screen
}

# ============================================================
# SYSTEM EDIT
# ============================================================

system_edit() {

    banner

    echo -e "${LIGHT_GREEN}                 SYSTEM EDIT${RESET}"
    echo

    echo "System management tools."

    echo
    echo "1) Hostname"
    echo "2) Timezone"
    echo "3) Firewall"
    echo "4) Back"

    echo
    line

    read -rp "Select → " choice

    case "$choice" in

        1)
            echo
            read -rp "New hostname: " new_hostname

            if [ -n "$new_hostname" ]; then
                hostnamectl set-hostname "$new_hostname"
                echo -e "${GREEN}✓ Hostname changed.${RESET}"
            fi

            pause_screen
            ;;

        2)
            echo
            timedatectl status
            pause_screen
            ;;

        3)
            echo
            echo "Firewall module will be added later."
            pause_screen
            ;;

        4)
            return
            ;;

        *)
            echo -e "${RED}✗ Invalid option.${RESET}"
            sleep 1
            ;;

    esac
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
        echo -e "${GREEN}D)${RESET} System Edit"
        echo -e "${GREEN}E)${RESET} Exit"

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
                system_edit
                ;;

            E|e)
                clear_screen

                echo
                echo -e "${LIGHT_GREEN}Thanks for using NEELCRAFT!${RESET}"
                echo

                exit 0
                ;;

            *)
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
