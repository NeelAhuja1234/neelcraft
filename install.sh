#!/usr/bin/env bash

# ============================================================
#                    NEELCRAFT
#              VPS MANAGEMENT TOOL
#                  Made By - Neel
# ============================================================

set -u
set -o pipefail

# ============================================================
# SETTINGS
# ============================================================

GITHUB_RAW="https://raw.githubusercontent.com/NeelAhuja1234/neelcraft/main"

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
        echo "Run with root access."
        echo

        exit 1
    fi
}

# ============================================================
# RUN GITHUB MODULE
# ============================================================

run_module() {

    local module="$1"
    local temp_file="/tmp/neelcraft-${module}"

    echo
    echo -e "${CYAN}Downloading ${module}...${RESET}"
    echo

    if ! command -v curl >/dev/null 2>&1; then

        echo -e "${YELLOW}curl not found. Installing...${RESET}"

        apt-get update
        apt-get install -y curl

    fi

    if ! curl -fsSL \
        "${GITHUB_RAW}/modules/${module}" \
        -o "$temp_file"; then

        echo
        echo -e "${RED}✗ Failed to download ${module}.${RESET}"
        echo

        echo "Check:"
        echo "• Internet connection"
        echo "• GitHub repository"
        echo "• File path"

        pause_screen
        return
    fi

    chmod +x "$temp_file"

    bash "$temp_file"

    rm -f "$temp_file"
}

# ============================================================
# BANNER
# ============================================================

banner() {

    clear_screen

    echo -e "${GREEN}"

    cat <<'EOF'

███╗   ██╗███████╗███████╗██╗         ██████╗██████╗  █████╗  ███████╗████████╗
████╗  ██║██╔════╝██╔════╝██║        ██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
██╔██╗ ██║█████╗  █████╗  ██║        ██║       ██████╔╝███████║█████╗     ██║
██║╚██╗██║██╔══╝  ██╔══╝  ██║        ██║      ██╔══██╗ ██╔══██║██╔══╝     ██║
██║ ╚████║███████╗███████╗███████╗  ╚██████╗██║  ██║ ██║  ██║██║         ██║
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
        echo -e "${GREEN}2)${RESET} Wings Information"
        echo -e "${GREEN}3)${RESET} System Information"
        echo -e "${GREEN}4)${RESET} Database Setup"
        echo -e "${GREEN}5)${RESET} Back"

        echo
        line

        read -rp "Select → " option

        case "$option" in

            1)
                panel_install
                ;;

            2)
                wings_install
                ;;

            3)
                system_information
                ;;

            4)
                database_menu
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
# PTERODACTYL PANEL INSTALLER
# ============================================================

panel_install() {

    banner

    echo -e "${LIGHT_GREEN}        NEELCRAFT PTERODACTYL INSTALLER${RESET}"
    echo

    if [ ! -f /etc/os-release ]; then

        echo -e "${RED}Unable to detect OS.${RESET}"
        pause_screen
        return

    fi

    . /etc/os-release

    case "${ID:-}" in

        ubuntu|debian)
            ;;
        *)
            echo -e "${RED}Ubuntu or Debian required.${RESET}"
            pause_screen
            return
            ;;
    esac

    echo -e "${LIGHT_GREEN}PANEL DETAILS${RESET}"
    echo

    read -rp "Panel Domain       : " PANEL_DOMAIN
    read -rp "Admin Email        : " ADMIN_EMAIL
    read -rp "Admin Username     : " ADMIN_USERNAME
    read -rp "Admin First Name   : " ADMIN_FIRST

    echo -n "Admin Password     : "
    read -rs ADMIN_PASSWORD

    echo
    echo

    if [ -z "$PANEL_DOMAIN" ] ||
       [ -z "$ADMIN_EMAIL" ] ||
       [ -z "$ADMIN_USERNAME" ] ||
       [ -z "$ADMIN_FIRST" ] ||
       [ -z "$ADMIN_PASSWORD" ]; then

        echo -e "${RED}All fields are required.${RESET}"
        pause_screen
        return
    fi

    echo
    echo -e "${YELLOW}The panel installer will now start.${RESET}"
    echo
    echo "Domain: $PANEL_DOMAIN"
    echo "Email : $ADMIN_EMAIL"
    echo "User  : $ADMIN_USERNAME"

    echo

    read -rp "Continue? [Y/n]: " confirm

    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        return
    fi

    export DEBIAN_FRONTEND=noninteractive

    PANEL_DIR="/var/www/pterodactyl"

    DB_NAME="panel"
    DB_USER="pterodactyl"
    DB_PASSWORD="$(openssl rand -hex 24)"

    echo
    echo -e "${LIGHT_GREEN}[1/7] Installing dependencies...${RESET}"

    apt-get update

    apt-get install -y \
        curl \
        wget \
        ca-certificates \
        gnupg \
        git \
        unzip \
        tar \
        nginx \
        mariadb-server \
        redis-server \
        openssl \
        cron

    echo
    echo -e "${LIGHT_GREEN}[2/7] Installing PHP dependencies...${RESET}"

    apt-get install -y \
        php \
        php-cli \
        php-common \
        php-gd \
        php-mysql \
        php-mbstring \
        php-bcmath \
        php-xml \
        php-curl \
        php-zip \
        php-fpm

    echo
    echo -e "${LIGHT_GREEN}[3/7] Installing Composer...${RESET}"

    if ! command -v composer >/dev/null 2>&1; then

        curl -sS https://getcomposer.org/installer \
            | php -- \
            --install-dir=/usr/local/bin \
            --filename=composer

    fi

    echo
    echo -e "${LIGHT_GREEN}[4/7] Creating database...${RESET}"

    systemctl enable --now mariadb
    systemctl enable --now redis-server

    mysql <<MYSQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS '${DB_USER}'@'127.0.0.1'
IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.*
TO '${DB_USER}'@'127.0.0.1';

FLUSH PRIVILEGES;
MYSQL

    echo
    echo -e "${LIGHT_GREEN}[5/7] Downloading Panel...${RESET}"

    mkdir -p "$PANEL_DIR"

    cd "$PANEL_DIR" || return

    curl -fL \
        https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz \
        -o panel.tar.gz

    if [ ! -s panel.tar.gz ]; then

        echo -e "${RED}Panel download failed.${RESET}"
        pause_screen
        return

    fi

    tar -xzf panel.tar.gz

    rm -f panel.tar.gz

    echo
    echo -e "${LIGHT_GREEN}[6/7] Installing Composer packages...${RESET}"

    COMPOSER_ALLOW_SUPERUSER=1 \
    composer install \
        --no-dev \
        --optimize-autoloader

    cp -n .env.example .env

    php artisan key:generate --force

    echo
    echo -e "${LIGHT_GREEN}[7/7] Configuring database...${RESET}"

    php artisan p:environment:setup \
        --author="$ADMIN_EMAIL" \
        --url="http://${PANEL_DOMAIN}" \
        --timezone="UTC" \
        --cache="redis" \
        --session="redis" \
        --queue="redis"

    php artisan p:environment:database \
        --host="127.0.0.1" \
        --port="3306" \
        --database="$DB_NAME" \
        --username="$DB_USER" \
        --password="$DB_PASSWORD"

    php artisan migrate --seed --force

    php artisan p:user:make \
        --email="$ADMIN_EMAIL" \
        --username="$ADMIN_USERNAME" \
        --name-first="$ADMIN_FIRST" \
        --name-last="Admin" \
        --password="$ADMIN_PASSWORD" \
        --admin=1

    chown -R www-data:www-data "$PANEL_DIR"

    echo
    echo -e "${GREEN}Panel installation completed.${RESET}"
    echo
    echo "Panel directory:"
    echo "$PANEL_DIR"

    echo
    echo -e "${YELLOW}Nginx and SSL configuration should be completed after DNS points to the server.${RESET}"

    pause_screen
}

# ============================================================
# WINGS
# ============================================================

wings_install() {

    banner

    echo -e "${LIGHT_GREEN}PTERODACTYL WINGS${RESET}"
    echo

    echo "Wings installation can be added as a separate module."
    echo
    echo "Requirements:"
    echo "• Docker"
    echo "• Correct Wings configuration"
    echo "• Server allocation"

    pause_screen
}

# ============================================================
# AIR-LINK
# ============================================================

airlink_menu() {

    banner

    echo -e "${LIGHT_GREEN}AIR-LINK PANEL${RESET}"
    echo

    echo -e "${YELLOW}This module is not configured yet.${RESET}"

    pause_screen
}

# ============================================================
# VPS MAKER
# ============================================================

vps_maker() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}                  VPS MAKER${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Create KVM VPS"
        echo -e "${GREEN}2)${RESET} Create No-KVM VPS"
        echo -e "${GREEN}3)${RESET} Install VPS Dependencies"
        echo -e "${GREEN}4)${RESET} VPS Management Tools"
        echo -e "${GREEN}5)${RESET} Back"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            1)
                run_module "kvm.sh"
                ;;

            2)
                run_module "nokvm.sh"
                ;;

            3)
                run_module "setup.sh"
                ;;

            4)
                run_module "tools.sh"
                ;;

            5)
                return
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
# TOOLS MENU
# ============================================================

tools_menu() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}TOOLS${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Install Docker"
        echo -e "${GREEN}2)${RESET} Install Git"
        echo -e "${GREEN}3)${RESET} Install Java"
        echo -e "${GREEN}4)${RESET} Install Node.js"
        echo -e "${GREEN}5)${RESET} Install Python"
        echo -e "${GREEN}6)${RESET} Back"

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
                install_node
                ;;

            5)
                install_python
                ;;

            6)
                return
                ;;

            *)
                echo -e "${RED}Invalid option.${RESET}"
                sleep 1
                ;;
        esac

    done
}

install_docker() {

    apt-get update

    apt-get install -y docker.io

    systemctl enable --now docker

    echo -e "${GREEN}Docker installed.${RESET}"

    pause_screen
}

install_git() {

    apt-get update
    apt-get install -y git

    echo -e "${GREEN}Git installed.${RESET}"

    pause_screen
}

install_java() {

    apt-get update
    apt-get install -y default-jdk

    java -version

    pause_screen
}

install_node() {

    apt-get update
    apt-get install -y nodejs npm

    node -v

    pause_screen
}

install_python() {

    apt-get update
    apt-get install -y python3 python3-pip

    python3 --version

    pause_screen
}

# ============================================================
# DATABASE MENU
# ============================================================

database_menu() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}DATABASE SETUP${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Install MariaDB"
        echo -e "${GREEN}2)${RESET} Install Redis"
        echo -e "${GREEN}3)${RESET} Back"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            1)
                apt-get update
                apt-get install -y mariadb-server
                systemctl enable --now mariadb
                pause_screen
                ;;

            2)
                apt-get update
                apt-get install -y redis-server
                systemctl enable --now redis-server
                pause_screen
                ;;

            3)
                return
                ;;

            *)
                echo -e "${RED}Invalid option.${RESET}"
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

    echo -e "${LIGHT_GREEN}SYSTEM INFORMATION${RESET}"
    echo

    echo "Hostname:"
    hostname

    echo
    echo "Operating System:"

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$PRETTY_NAME"
    fi

    echo
    echo "Kernel:"
    uname -r

    echo
    echo "CPU Cores:"
    nproc

    echo
    echo "Memory:"
    free -h

    echo
    echo "Disk:"
    df -h /

    echo
    echo "KVM:"

    if [ -e /dev/kvm ]; then
        echo -e "${GREEN}AVAILABLE${RESET}"
    else
        echo -e "${RED}NOT AVAILABLE${RESET}"
    fi

    pause_screen
}

# ============================================================
# SYSTEM EDIT
# ============================================================

system_edit() {

    while true; do

        banner

        echo -e "${LIGHT_GREEN}SYSTEM EDIT${RESET}"
        echo

        echo -e "${GREEN}1)${RESET} Change Hostname"
        echo -e "${GREEN}2)${RESET} Show Timezone"
        echo -e "${GREEN}3)${RESET} Back"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            1)

                read -rp "New hostname: " new_hostname

                if [ -n "$new_hostname" ]; then

                    hostnamectl set-hostname "$new_hostname"

                    echo -e "${GREEN}Hostname changed.${RESET}"

                fi

                pause_screen
                ;;

            2)

                timedatectl

                pause_screen
                ;;

            3)

                return
                ;;

            *)

                echo -e "${RED}Invalid option.${RESET}"
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

        echo -e "${LIGHT_GREEN}MAIN MENU${RESET}"
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
                echo -e "${LIGHT_GREEN}GOODBYE NEELCRAFT!${RESET}"
                echo

                exit 0
                ;;

            *)

                echo -e "${RED}Invalid option.${RESET}"
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
