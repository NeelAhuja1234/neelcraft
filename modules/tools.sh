#!/usr/bin/env bash

# ============================================================
#              NEELCRAFT VPS MANAGEMENT TOOLS
# ============================================================

set -u
set -o pipefail

BASE_DIR="/opt/neelcraft"
VM_DIR="$BASE_DIR/vms"
CLOUD_DIR="$BASE_DIR/cloud-init"

GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'

pause_screen() {

    echo
    read -rp "Press Enter to continue..."

}

line() {

    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

}

banner() {

    clear

    echo
    echo -e "${LIGHT_GREEN}NEELCRAFT VPS MANAGEMENT${RESET}"
    echo

    line
}

system_info() {

    banner

    echo -e "${CYAN}SYSTEM INFORMATION${RESET}"
    echo

    echo "Hostname:"
    hostname

    echo
    echo "OS:"

    if [ -f /etc/os-release ]; then

        . /etc/os-release

        echo "$PRETTY_NAME"

    fi

    echo
    echo "Kernel:"
    uname -r

    echo
    echo "CPU:"
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

list_vms() {

    banner

    echo -e "${CYAN}VIRTUAL MACHINES${RESET}"
    echo

    if [ ! -d "$VM_DIR" ]; then

        echo "No VPS directory found."

        pause_screen

        return

    fi

    shopt -s nullglob

    PID_FILES=("$VM_DIR"/*.pid)

    if [ ${#PID_FILES[@]} -eq 0 ]; then

        echo "No VMs found."

        pause_screen

        return

    fi

    for file in "${PID_FILES[@]}"; do

        NAME="$(basename "$file" .pid)"

        PID="$(cat "$file" 2>/dev/null || true)"

        echo -e "${WHITE}Name:${RESET} $NAME"
        echo "PID: $PID"

        if [ -n "$PID" ] &&
           kill -0 "$PID" 2>/dev/null; then

            echo -e "Status: ${GREEN}RUNNING${RESET}"

        else

            echo -e "Status: ${RED}STOPPED${RESET}"

        fi

        echo

    done

    pause_screen
}

stop_vm() {

    banner

    echo -e "${YELLOW}STOP VPS${RESET}"
    echo

    read -rp "VM Name: " VM_NAME

    PID_FILE="$VM_DIR/${VM_NAME}.pid"

    if [ ! -f "$PID_FILE" ]; then

        echo -e "${RED}VM not found.${RESET}"

        pause_screen

        return

    fi

    PID="$(cat "$PID_FILE")"

    if kill -0 "$PID" 2>/dev/null; then

        echo "Stopping VM..."

        kill "$PID" 2>/dev/null || true

        sleep 3

        if kill -0 "$PID" 2>/dev/null; then

            kill -9 "$PID" 2>/dev/null || true

        fi

        echo -e "${GREEN}VM stopped.${RESET}"

    else

        echo -e "${YELLOW}VM was already stopped.${RESET}"

    fi

    pause_screen
}

delete_vm() {

    banner

    echo -e "${RED}DELETE VPS${RESET}"
    echo

    read -rp "VM Name: " VM_NAME

    if [ -z "$VM_NAME" ]; then

        echo -e "${RED}Invalid VM name.${RESET}"

        pause_screen

        return

    fi

    echo
    echo -e "${YELLOW}This will permanently delete the VM.${RESET}"

    read -rp "Type DELETE to confirm: " CONFIRM

    if [ "$CONFIRM" != "DELETE" ]; then

        echo "Cancelled."

        pause_screen

        return

    fi

    PID_FILE="$VM_DIR/${VM_NAME}.pid"

    if [ -f "$PID_FILE" ]; then

        PID="$(cat "$PID_FILE")"

        if kill -0 "$PID" 2>/dev/null; then

            kill "$PID" 2>/dev/null || true

        fi

    fi

    rm -f "$VM_DIR/${VM_NAME}.pid"

    rm -f "$VM_DIR/${VM_NAME}.qcow2"

    rm -f "$VM_DIR/${VM_NAME}.log"

    rm -rf "$CLOUD_DIR/${VM_NAME}"

    echo
    echo -e "${GREEN}VM deleted successfully.${RESET}"

    pause_screen
}

view_logs() {

    banner

    echo -e "${CYAN}VIEW VPS LOGS${RESET}"
    echo

    read -rp "VM Name: " VM_NAME

    LOG_FILE="$VM_DIR/${VM_NAME}.log"

    if [ ! -f "$LOG_FILE" ]; then

        echo -e "${RED}Log file not found.${RESET}"

        pause_screen

        return

    fi

    tail -n 50 "$LOG_FILE"

    pause_screen
}

tools_menu() {

    while true; do

        banner

        echo -e "${GREEN}1)${RESET} System Information"
        echo -e "${GREEN}2)${RESET} List VPS"
        echo -e "${YELLOW}3)${RESET} Stop VPS"
        echo -e "${CYAN}4)${RESET} View VPS Logs"
        echo -e "${RED}5)${RESET} Delete VPS"
        echo -e "${WHITE}6)${RESET} Back"

        echo

        line

        read -rp "Select → " choice

        case "$choice" in

            1)

                system_info
                ;;

            2)

                list_vms
                ;;

            3)

                stop_vm
                ;;

            4)

                view_logs
                ;;

            5)

                delete_vm
                ;;

            6)

                exit 0
                ;;

            *)

                echo -e "${RED}Invalid option.${RESET}"

                sleep 1
                ;;
        esac

    done
}

tools_menu
