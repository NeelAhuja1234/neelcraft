# if you use Ubuntu

sudo apt update && sudo apt upgrade -y

sudo apt install lxc lxc-utils -y

sudo apt install snapd -y
sudo systemctl enable --now snapd.socket

sudo snap install lxd

sudo usermod -aG lxd $USER


newgrp lxd

sudo lxd init


sudo apt update


sudo apt install lxc lxc-utils bridge-utils uidmap -y
