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

    echo -e "${LIGHT_GREEN}        NEELCRAFT PTERODACTYL INSTALLER${RESET}"
    echo

    # =========================================================
    # ROOT CHECK
    # =========================================================

    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}✗ Root access required.${RESET}"
        pause_screen
        return
    fi

    # =========================================================
    # OS CHECK
    # =========================================================

    if [ ! -f /etc/os-release ]; then
        echo -e "${RED}✗ Unable to detect operating system.${RESET}"
        pause_screen
        return
    fi

    . /etc/os-release

    case "$ID" in

        ubuntu)
            if [[ "$VERSION_ID" != "22.04" &&
                  "$VERSION_ID" != "24.04" ]]; then

                echo -e "${RED}✗ Supported Ubuntu versions: 22.04 / 24.04${RESET}"
                pause_screen
                return
            fi
            ;;

        debian)
            if [[ "$VERSION_ID" != "11" &&
                  "$VERSION_ID" != "12" &&
                  "$VERSION_ID" != "13" ]]; then

                echo -e "${RED}✗ Supported Debian versions: 11 / 12 / 13${RESET}"
                pause_screen
                return
            fi
            ;;

        *)
            echo -e "${RED}✗ Ubuntu/Debian required.${RESET}"
            pause_screen
            return
            ;;

    esac

    # =========================================================
    # ONLY 5 USER INPUTS
    # =========================================================

    echo -e "${LIGHT_GREEN}             PANEL DETAILS${RESET}"
    echo

    read -rp "Panel Domain       : " PANEL_DOMAIN
    read -rp "Admin Email        : " ADMIN_EMAIL
    read -rp "Admin Username     : " ADMIN_USERNAME
    read -rp "Admin First Name   : " ADMIN_FIRST

    echo -n "Admin Password     : "
    read -rs ADMIN_PASSWORD
    echo
    echo

    # =========================================================
    # VALIDATION
    # =========================================================

    if [ -z "$PANEL_DOMAIN" ] ||
       [ -z "$ADMIN_EMAIL" ] ||
       [ -z "$ADMIN_USERNAME" ] ||
       [ -z "$ADMIN_FIRST" ] ||
       [ -z "$ADMIN_PASSWORD" ]; then

        echo -e "${RED}✗ All five fields are required.${RESET}"
        pause_screen
        return
    fi

    # Basic domain validation
    if [[ ! "$PANEL_DOMAIN" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo -e "${RED}✗ Invalid domain.${RESET}"
        pause_screen
        return
    fi

    # =========================================================
    # AUTOMATIC VALUES
    # =========================================================

    DB_NAME="panel"
    DB_USER="pterodactyl"
    DB_PASSWORD="$(openssl rand -hex 24)"

    ADMIN_LAST="Admin"

    PANEL_DIR="/var/www/pterodactyl"

    # =========================================================
    # SUMMARY
    # =========================================================

    clear_screen
    banner

    echo -e "${LIGHT_GREEN}             INSTALLATION SUMMARY${RESET}"
    echo

    echo -e "${GREEN}Domain:${RESET}       $PANEL_DOMAIN"
    echo -e "${GREEN}Admin Email:${RESET}  $ADMIN_EMAIL"
    echo -e "${GREEN}Username:${RESET}     $ADMIN_USERNAME"
    echo -e "${GREEN}First Name:${RESET}   $ADMIN_FIRST"
    echo
    echo -e "${YELLOW}Database password will be generated automatically.${RESET}"
    echo

    read -rp "Start installation? [Y/n]: " CONFIRM

    if [[ "$CONFIRM" =~ ^[Nn]$ ]]; then
        echo
        echo "Installation cancelled."
        pause_screen
        return
    fi

    # =========================================================
    # INSTALL DEPENDENCIES
    # =========================================================

    clear_screen
    banner

    echo -e "${LIGHT_GREEN}[1/9] Installing system dependencies...${RESET}"
    echo

    export DEBIAN_FRONTEND=noninteractive

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
        cron \
        certbot \
        python3-certbot-nginx \
        software-properties-common \
        apt-transport-https

    # =========================================================
    # PHP REPOSITORY
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}[2/9] Installing PHP 8.3...${RESET}"
    echo

    if [ "$ID" = "ubuntu" ]; then

        if ! grep -Rqs "ondrej/php" /etc/apt/sources.list.d/ 2>/dev/null; then
            add-apt-repository -y ppa:ondrej/php
        fi

    else

        apt-get install -y lsb-release ca-certificates

        curl -fsSL \
            https://packages.sury.org/php/apt.gpg \
            | gpg --dearmor \
            -o /usr/share/keyrings/php.gpg

        echo "deb [signed-by=/usr/share/keyrings/php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" \
            > /etc/apt/sources.list.d/php.list

    fi

    apt-get update

    apt-get install -y \
        php8.3 \
        php8.3-cli \
        php8.3-common \
        php8.3-gd \
        php8.3-mysql \
        php8.3-mbstring \
        php8.3-bcmath \
        php8.3-xml \
        php8.3-curl \
        php8.3-zip \
        php8.3-fpm

    systemctl enable --now php8.3-fpm
    systemctl enable --now nginx
    systemctl enable --now mariadb
    systemctl enable --now redis-server
    systemctl enable --now cron

    # =========================================================
    # COMPOSER
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}[3/9] Installing Composer 2...${RESET}"
    echo

    if ! command -v composer >/dev/null 2>&1; then

        curl -sS https://getcomposer.org/installer \
            | php -- \
            --install-dir=/usr/local/bin \
            --filename=composer

        chmod +x /usr/local/bin/composer

    fi

    composer --version

    # =========================================================
    # DATABASE
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}[4/9] Creating Pterodactyl database...${RESET}"
    echo

    mysql <<MYSQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS '${DB_USER}'@'127.0.0.1'
IDENTIFIED BY '${DB_PASSWORD}';

ALTER USER '${DB_USER}'@'127.0.0.1'
IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.*
TO '${DB_USER}'@'127.0.0.1';

FLUSH PRIVILEGES;
MYSQL

    echo -e "${GREEN}✓ Database created.${RESET}"

    # =========================================================
    # DOWNLOAD PANEL
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}[5/9] Downloading Pterodactyl Panel...${RESET}"
    echo

    mkdir -p "$PANEL_DIR"

    cd "$PANEL_DIR" || return

    curl -fL \
        https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz \
        -o panel.tar.gz

    if [ ! -s panel.tar.gz ]; then
        echo -e "${RED}✗ Panel download failed.${RESET}"
        pause_screen
        return
    fi

    tar -xzf panel.tar.gz

    rm -f panel.tar.gz

    # =========================================================
    # COMPOSER
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}[6/9] Installing Panel dependencies...${RESET}"
    echo

    COMPOSER_ALLOW_SUPERUSER=1 composer install \
        --no-dev \
        --optimize-autoloader

    cp -n .env.example .env

    php artisan key:generate --force

    # =========================================================
    # ENVIRONMENT
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}Configuring Panel...${RESET}"
    echo

    php artisan p:environment:setup \
        --author="$ADMIN_EMAIL" \
        --url="https://$PANEL_DOMAIN" \
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

    # =========================================================
    # DATABASE MIGRATION
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}Creating Panel tables...${RESET}"
    echo

    php artisan migrate --seed --force

    # =========================================================
    # ADMIN USER
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}Creating administrator account...${RESET}"
    echo

    php artisan p:user:make \
        --email="$ADMIN_EMAIL" \
        --username="$ADMIN_USERNAME" \
        --name-first="$ADMIN_FIRST" \
        --name-last="$ADMIN_LAST" \
        --password="$ADMIN_PASSWORD" \
        --admin=1

    # =========================================================
    # PERMISSIONS
    # =========================================================

    chown -R www-data:www-data "$PANEL_DIR"

    chmod -R 755 \
        "$PANEL_DIR/storage" \
        "$PANEL_DIR/bootstrap/cache"

    # =========================================================
    # NGINX
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}[7/9] Configuring Nginx...${RESET}"
    echo

    cat > /etc/nginx/sites-available/pterodactyl.conf <<NGINX
server {
    listen 80;
    server_name ${PANEL_DOMAIN};

    root ${PANEL_DIR}/public;

    index index.php;

    charset utf-8;

    client_max_body_size 100m;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;

        fastcgi_index index.php;

        include fastcgi_params;

        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
    }

    location ~ /\.ht {
        deny all;
    }
}
NGINX

    rm -f /etc/nginx/sites-enabled/default

    ln -sf \
        /etc/nginx/sites-available/pterodactyl.conf \
        /etc/nginx/sites-enabled/pterodactyl.conf

    nginx -t

    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Nginx configuration failed.${RESET}"
        pause_screen
        return
    fi

    systemctl restart nginx

    # =========================================================
    # QUEUE WORKER
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}[8/9] Configuring queue worker...${RESET}"
    echo

    cat > /etc/systemd/system/pteroq.service <<SERVICE
[Unit]
Description=Pterodactyl Queue Worker
After=redis-server.service

[Service]
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php ${PANEL_DIR}/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

    systemctl daemon-reload
    systemctl enable --now pteroq

    # =========================================================
    # CRON
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}[9/9] Configuring cron...${RESET}"
    echo

    CRON_LINE="* * * * * php ${PANEL_DIR}/artisan schedule:run >> /dev/null 2>&1"

    (
        crontab -u www-data -l 2>/dev/null |
        grep -Fv "${PANEL_DIR}/artisan schedule:run"
        echo "$CRON_LINE"
    ) | crontab -u www-data -

    # =========================================================
    # SSL
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}Configuring SSL...${RESET}"
    echo

    certbot --nginx \
        -d "$PANEL_DOMAIN" \
        --non-interactive \
        --agree-tos \
        -m "$ADMIN_EMAIL" \
        --redirect

    # =========================================================
    # FINAL CHECK
    # =========================================================

    echo
    echo -e "${LIGHT_GREEN}Checking installation...${RESET}"
    echo

    if systemctl is-active --quiet nginx &&
       systemctl is-active --quiet mariadb &&
       systemctl is-active --quiet redis-server &&
       systemctl is-active --quiet pteroq; then

        echo -e "${GREEN}✓ Nginx: Running${RESET}"
        echo -e "${GREEN}✓ MariaDB: Running${RESET}"
        echo -e "${GREEN}✓ Redis: Running${RESET}"
        echo -e "${GREEN}✓ Pterodactyl Queue: Running${RESET}"

    else

        echo -e "${YELLOW}⚠ One or more services need attention.${RESET}"

    fi

    # =========================================================
    # COMPLETE
    # =========================================================

    echo
    line
    echo

    echo -e "${LIGHT_GREEN}       ✓ NEELCRAFT PANEL INSTALLED${RESET}"
    echo

    echo -e "${GREEN}Panel URL:${RESET}"
    echo "https://${PANEL_DOMAIN}"

    echo
    echo -e "${GREEN}Username:${RESET}"
    echo "$ADMIN_USERNAME"

    echo
    echo -e "${YELLOW}Database credentials were generated automatically.${RESET}"
    echo -e "${YELLOW}The database password is stored in:${RESET}"
    echo
    echo "$PANEL_DIR/.env"

    echo
    line

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
