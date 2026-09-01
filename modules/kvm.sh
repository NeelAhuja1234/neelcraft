#!/usr/bin/env bash

# ============================================================
#               NEELCRAFT KVM VPS CREATOR
# ============================================================

set -u
set -o pipefail

BASE_DIR="/opt/neelcraft"
IMAGE_DIR="$BASE_DIR/images"
VM_DIR="$BASE_DIR/vms"
CLOUD_DIR="$BASE_DIR/cloud-init"

IMAGE_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"

BASE_IMAGE="$IMAGE_DIR/ubuntu-24.04.img"

GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

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

check_requirements() {

    if [ ! -e /dev/kvm ]; then

        echo
        echo -e "${RED}KVM is not available.${RESET}"
        echo
        echo "/dev/kvm was not found."
        echo
        echo "Use No-KVM mode instead."

        pause_screen

        exit 1

    fi

    for command in \
        qemu-system-x86_64 \
        qemu-img \
        cloud-localds \
        curl; do

        if ! command -v "$command" >/dev/null 2>&1; then

            echo -e "${RED}Missing dependency: $command${RESET}"
            echo
            echo "Run VPS Setup first."

            pause_screen

            exit 1

        fi

    done
}

prepare_directories() {

    mkdir -p "$IMAGE_DIR"
    mkdir -p "$VM_DIR"
    mkdir -p "$CLOUD_DIR"

}

download_image() {

    if [ -f "$BASE_IMAGE" ]; then

        echo -e "${GREEN}Ubuntu image already exists.${RESET}"

        return

    fi

    echo
    echo -e "${CYAN}Downloading Ubuntu 24.04 cloud image...${RESET}"
    echo

    if ! curl \
        -L \
        --fail \
        --progress-bar \
        "$IMAGE_URL" \
        -o "$BASE_IMAGE"; then

        echo
        echo -e "${RED}Image download failed.${RESET}"

        exit 1

    fi
}

validate_number() {

    [[ "$1" =~ ^[0-9]+$ ]]

}

get_vm_details() {

    clear

    echo -e "${LIGHT_GREEN}KVM VPS CONFIGURATION${RESET}"
    echo

    read -rp "VM Name: " VM_NAME
    read -rp "RAM (MB) [2048]: " VM_RAM
    read -rp "CPU Cores [2]: " VM_CPU
    read -rp "Disk (GB) [20]: " VM_DISK
    read -rp "SSH Port [2222]: " SSH_PORT

    VM_RAM="${VM_RAM:-2048}"
    VM_CPU="${VM_CPU:-2}"
    VM_DISK="${VM_DISK:-20}"
    SSH_PORT="${SSH_PORT:-2222}"

    if [ -z "$VM_NAME" ]; then

        echo -e "${RED}VM name cannot be empty.${RESET}"

        exit 1

    fi

    if [[ ! "$VM_NAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then

        echo -e "${RED}Invalid VM name.${RESET}"

        exit 1

    fi

    if ! validate_number "$VM_RAM" ||
       ! validate_number "$VM_CPU" ||
       ! validate_number "$VM_DISK" ||
       ! validate_number "$SSH_PORT"; then

        echo -e "${RED}RAM, CPU, Disk and Port must be numbers.${RESET}"

        exit 1

    fi

    read -rsp "Root Password: " VM_PASSWORD

    echo

    if [ -z "$VM_PASSWORD" ]; then

        echo -e "${RED}Password cannot be empty.${RESET}"

        exit 1

    fi
}

check_port() {

    if ss -lnt 2>/dev/null | \
        awk '{print $4}' | \
        grep -q ":${SSH_PORT}$"; then

        echo -e "${RED}Port $SSH_PORT is already in use.${RESET}"

        exit 1

    fi
}

create_disk() {

    VM_DISK_PATH="$VM_DIR/${VM_NAME}.qcow2"

    if [ -f "$VM_DISK_PATH" ]; then

        echo -e "${RED}A VM with this name already exists.${RESET}"

        exit 1

    fi

    echo
    echo -e "${GREEN}Creating VM disk...${RESET}"

    qemu-img create \
        -f qcow2 \
        -F qcow2 \
        -b "$BASE_IMAGE" \
        "$VM_DISK_PATH" \
        "${VM_DISK}G"
}

create_cloud_init() {

    VM_CLOUD_DIR="$CLOUD_DIR/$VM_NAME"

    mkdir -p "$VM_CLOUD_DIR"

    cat > "$VM_CLOUD_DIR/user-data" <<EOF
#cloud-config

hostname: ${VM_NAME}

users:
  - name: root
    lock_passwd: false
    plain_text_passwd: "${VM_PASSWORD}"

ssh_pwauth: true

package_update: true

packages:
  - openssh-server

runcmd:
  - systemctl enable ssh
  - systemctl restart ssh
EOF

    cat > "$VM_CLOUD_DIR/meta-data" <<EOF
instance-id: ${VM_NAME}
local-hostname: ${VM_NAME}
EOF

    cloud-localds \
        "$VM_CLOUD_DIR/seed.iso" \
        "$VM_CLOUD_DIR/user-data" \
        "$VM_CLOUD_DIR/meta-data"
}

start_vm() {

    LOG_FILE="$VM_DIR/${VM_NAME}.log"
    PID_FILE="$VM_DIR/${VM_NAME}.pid"

    echo
    echo -e "${GREEN}Starting KVM VPS...${RESET}"

    nohup qemu-system-x86_64 \
        -enable-kvm \
        -machine q35 \
        -m "$VM_RAM" \
        -smp "$VM_CPU" \
        -drive file="$VM_DISK_PATH",format=qcow2,if=virtio \
        -drive file="$VM_CLOUD_DIR/seed.iso",media=cdrom,readonly=on \
        -netdev user,id=net0,hostfwd=tcp::${SSH_PORT}-:22 \
        -device virtio-net-pci,netdev=net0 \
        -display none \
        > "$LOG_FILE" 2>&1 &

    echo $! > "$PID_FILE"

    sleep 5

    PID="$(cat "$PID_FILE")"

    if ! kill -0 "$PID" 2>/dev/null; then

        echo
        echo -e "${RED}VM stopped unexpectedly.${RESET}"
        echo

        tail -n 30 "$LOG_FILE" 2>/dev/null || true

        exit 1

    fi

    echo
    echo -e "${LIGHT_GREEN}KVM VPS CREATED SUCCESSFULLY${RESET}"
    echo

    echo "VM Name : $VM_NAME"
    echo "RAM     : ${VM_RAM} MB"
    echo "CPU     : $VM_CPU"
    echo "Disk    : ${VM_DISK} GB"
    echo "SSH Port: $SSH_PORT"

    echo
    echo "SSH Command:"
    echo
    echo "ssh root@YOUR_SERVER_IP -p $SSH_PORT"

    echo
    echo "PID: $PID"
}

main() {

    clear

    require_root
    check_requirements
    prepare_directories
    download_image
    get_vm_details
    check_port
    create_disk
    create_cloud_init
    start_vm

    pause_screen
}

main
