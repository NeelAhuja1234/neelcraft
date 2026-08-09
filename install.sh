#!/usr/bin/env bash

# ============================================================
# NEELPANEL - VPS MANAGEMENT TOOL
# Made by Neel
# ============================================================

set -u

# ---------- COLORS ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
RESET='\033[0m'

# ---------- BASIC FUNCTIONS ----------

pause_screen() {
    echo
    read -rp "Press Enter to continue..."
}

clear_screen() {
    clear
}

require_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}This tool must be run as root.${RESET}"
        echo "Run:"
        echo "sudo bash install.sh"
        exit 1
    fi
}

line() {
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# ---------- BANNER ----------

banner() {
    clear_screen

    line

    echo -e "${RED}"
    cat <<'EOF'

███╗   ██╗███████╗███████╗██╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗
████╗  ██║██╔════╝██╔════╝██║     ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
██╔██╗ ██║█████╗  █████╗  ██║     ██████╔╝███████║██╔██╗ ██║█████╗  ██║
██║╚██╗██║██╔══╝  ██╔══╝  ██║     ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
██║ ╚████║███████╗███████╗███████╗██║     ██║  ██║██║ ╚████║███████╗███████╗
╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

EOF
    echo -e "${RESET}"

    echo -e "${WHITE}                 Made By - Neel${RESET}"

    line
}

# ---------- PANEL MENU ----------

panel_menu() {

    while true; do

        banner

        echo -e "${RED}                 PANELS MENU${RESET}"
        echo

        echo -e "${RED}1)${RESET} Pterodactyl Panel"
        echo -e "${RED}2)${RESET} Air-Link Panel"
        echo -e "${RED}3)${RESET} Back to Main Menu"

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
                echo -e "${RED}Invalid option.${RESET}"
                sleep 1
                ;;

        esac

    done
}

# ---------- PTERODACTYL MENU ----------

pterodactyl_menu() {

    while true; do

        banner

        echo -e "${RED}             PTERODACTYL MANAGER${RESET}"
        echo

        echo -e "${RED}1)${RESET} Panel Installation"
        echo -e "${RED}2)${RESET} Wings Installation"
        echo -e "${RED}3)${RESET} Uninstall Tools"
        echo -e "${RED}4)${RESET} Blueprint + Theme + Extensions"
        echo -e "${RED}5)${RESET} Cloudflare Setup"
        echo -e "${RED}6)${RESET} System Information"
        echo -e "${RED}7)${RESET} Tailscale"
        echo -e "${RED}8)${RESET} Database Setup"
        echo -e "${RED}9)${RESET} Back"

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
                echo -e "${RED}Invalid option.${RESET}"
                sleep 1
                ;;

        esac

    done
}

# ---------- PANEL INSTALL ----------

panel_install() {

    banner

    echo -e "${CYAN}Pterodactyl Panel Installation${RESET}"
    echo

    echo -e "${YELLOW}This module is ready for the official installer integration.${RESET}"
    echo
    echo "The actual installation will:"
    echo " - Check OS"
    echo " - Check root access"
    echo " - Install dependencies"
    echo " - Configure PHP"
    echo " - Configure MariaDB/MySQL"
    echo " - Configure Redis"
    echo " - Install Nginx"
    echo " - Download Pterodactyl"
    echo " - Configure the Panel"
    echo
    echo -e "${GREEN}Pterodactyl installation module selected.${RESET}"

    pause_screen
}

# ---------- WINGS ----------

wings_install() {

    banner

    echo -e "${CYAN}Pterodactyl Wings Installation${RESET}"
    echo

    echo "Wings installation module selected."
    echo
    echo "This module will later:"
    echo " - Install Docker"
    echo " - Download Wings"
    echo " - Configure Wings"
    echo " - Create systemd service"
    echo " - Start Wings"

    pause_screen
}

# ---------- AIRLINK ----------

airlink_menu() {

    banner

    echo -e "${CYAN}Air-Link Panel${RESET}"
    echo

    echo "Air-Link installation module."
    echo
    echo -e "${YELLOW}Installer module will be added here.${RESET}"

    pause_screen
}

# ---------- TOOLS ----------

tools_menu() {

    while true; do

        banner

        echo -e "${RED}                  TOOLS${RESET}"
        echo

        echo -e "${RED}1)${RESET} Docker"
        echo -e "${RED}2)${RESET} Git"
        echo -e "${RED}3)${RESET} Java"
        echo -e "${RED}4)${RESET} Node.js"
        echo -e "${RED}5)${RESET} Python"
        echo -e "${RED}6)${RESET} Nginx"
        echo -e "${RED}7)${RESET} MariaDB"
        echo -e "${RED}8)${RESET} Redis"
        echo -e "${RED}9)${RESET} Back"

        echo
        line

        read -rp "Select → " tool

        case "$tool" in

            1) install_docker ;;
            2) install_git ;;
            3) install_java ;;
            4) install_node ;;
            5) install_python ;;
            6) install_nginx ;;
            7) install_mariadb ;;
            8) install_redis ;;
            9) return ;;

            *)
                echo -e "${RED}Invalid option.${RESET}"
                sleep 1
                ;;

        esac

    done
}

# ---------- TOOLS FUNCTIONS ----------

install_docker() {
    banner
    echo -e "${CYAN}Installing Docker...${RESET}"
    echo

    if command -v docker >/dev/null 2>&1; then
        echo -e "${GREEN}Docker is already installed.${RESET}"
    else
        apt-get update
        apt-get install -y docker.io
        systemctl enable --now docker

        echo -e "${GREEN}Docker installed successfully.${RESET}"
    fi

    pause_screen
}

install_git() {
    banner
    echo -e "${CYAN}Installing Git...${RESET}"
    apt-get update
    apt-get install -y git
    echo -e "${GREEN}Git installed.${RESET}"
    pause_screen
}

install_java() {
    banner
    echo -e "${CYAN}Installing Java...${RESET}"
    apt-get update
    apt-get install -y openjdk-21-jre-headless
    echo -e "${GREEN}Java installed.${RESET}"
    java -version
    pause_screen
}

install_node() {
    banner
    echo -e "${CYAN}Installing Node.js...${RESET}"
    apt-get update
    apt-get install -y nodejs npm
    echo -e "${GREEN}Node.js installed.${RESET}"
    node --version
    pause_screen
}

install_python() {
    banner
    echo -e "${CYAN}Installing Python...${RESET}"
    apt-get update
    apt-get install -y python3 python3-pip
    echo -e "${GREEN}Python installed.${RESET}"
    python3 --version
    pause_screen
}

install_nginx() {
    banner
    echo -e "${CYAN}Installing Nginx...${RESET}"
    apt-get update
    apt-get install -y nginx
    systemctl enable --now nginx
    echo -e "${GREEN}Nginx installed.${RESET}"
    pause_screen
}

install_mariadb() {
    banner
    echo -e "${CYAN}Installing MariaDB...${RESET}"
    apt-get update
    apt-get install -y mariadb-server
    systemctl enable --now mariadb
    echo -e "${GREEN}MariaDB installed.${RESET}"
    pause_screen
}

install_redis() {
    banner
    echo -e "${CYAN}Installing Redis...${RESET}"
    apt-get update
    apt-get install -y redis-server
    systemctl enable --now redis-server
    echo -e "${GREEN}Redis installed.${RESET}"
    pause_screen
}

# ---------- SYSTEM INFORMATION ----------

system_information() {

    banner

    echo -e "${CYAN}SYSTEM INFORMATION${RESET}"
    echo

    echo "Hostname       : $(hostname)"
    echo "OS             : $(. /etc/os-release && echo "$PRETTY_NAME")"
    echo "Kernel         : $(uname -r)"
    echo "Architecture   : $(uname -m)"
    echo "CPU             : $(nproc) cores"
    echo "RAM             : $(free -h | awk '/Mem:/ {print $2}')"
    echo "Disk            : $(df -h / | awk 'NR==2 {print $2}')"
    echo "Uptime          : $(uptime -p)"

    echo
    line

    pause_screen
}

# ---------- UNINSTALL ----------

uninstall_tools() {

    banner

    echo -e "${CYAN}UNINSTALL TOOLS${RESET}"
    echo

    echo -e "${RED}1)${RESET} Remove Docker"
    echo -e "${RED}2)${RESET} Remove Nginx"
    echo -e "${RED}3)${RESET} Remove Redis"
    echo -e "${RED}4)${RESET} Back"

    echo
    line

    read -rp "Select → " choice

    case "$choice" in

        1)
            apt-get remove -y docker.io
            echo -e "${GREEN}Docker removed.${RESET}"
            pause_screen
            ;;

        2)
            apt-get remove -y nginx
            echo -e "${GREEN}Nginx removed.${RESET}"
            pause_screen
            ;;

        3)
            apt-get remove -y redis-server
            echo -e "${GREEN}Redis removed.${RESET}"
            pause_screen
            ;;

        4)
            return
            ;;

        *)
            echo -e "${RED}Invalid option.${RESET}"
            sleep 1
            ;;

    esac
}

# ---------- BLUEPRINT ----------

blueprint_menu() {

    banner

    echo -e "${CYAN}BLUEPRINT / THEME / EXTENSIONS${RESET}"
    echo
    echo "1) Blueprint"
    echo "2) Theme"
    echo "3) Extensions"
    echo "4) Back"

    echo
    line

    read -rp "Select → " choice

    case "$choice" in
        1) echo "Blueprint module selected." ;;
        2) echo "Theme module selected." ;;
        3) echo "Extensions module selected." ;;
        4) return ;;
        *) echo "Invalid option." ;;
    esac

    pause_screen
}

# ---------- CLOUDFLARE ----------

cloudflare_menu() {

    banner

    echo -e "${CYAN}CLOUDFLARE SETUP${RESET}"
    echo

    echo "Cloudflare setup module selected."
    echo
    echo "Domain → Cloudflare → DNS → SSL configuration"

    pause_screen
}

# ---------- TAILSCALE ----------

tailscale_menu() {

    banner

    echo -e "${CYAN}TAILSCALE${RESET}"
    echo

    echo "Tailscale setup module selected."

    pause_screen
}

# ---------- DATABASE ----------

database_menu() {

    banner

    echo -e "${CYAN}DATABASE SETUP${RESET}"
    echo

    echo "1) MariaDB"
    echo "2) Redis"
    echo "3) Back"

    echo
    line

    read -rp "Select → " choice

    case "$choice" in
        1) install_mariadb ;;
        2) install_redis ;;
        3) return ;;
        *) echo "Invalid option." ; pause_screen ;;
    esac
}

# ---------- MAIN MENU ----------

main_menu() {

    while true; do

        banner

        echo -e "${RED}                  MAIN MENU${RESET}"
        echo

        echo -e "${RED}A)${RESET} Panel"
        echo -e "${RED}B)${RESET} VPS Maker"
        echo -e "${RED}C)${RESET} Tools"
        echo -e "${RED}D)${RESET} System Edit"
        echo -e "${RED}E)${RESET} Exit"

        echo
        line

        read -rp "Select → " choice

        case "$choice" in

            A|a)
                panel_menu
                ;;

            B|b)
                echo
                echo -e "${YELLOW}VPS Maker module coming soon.${RESET}"
                pause_screen
                ;;

            C|c)
                tools_menu
                ;;

            D|d)
                system_information
                ;;

            E|e)
                clear
                echo -e "${GREEN}Thanks for using NEELPANEL.${RESET}"
                exit 0
                ;;

            *)
                echo -e "${RED}Invalid option.${RESET}"
                sleep 1
                ;;

        esac

    done
}

# ---------- START ----------

require_root
main_menu
