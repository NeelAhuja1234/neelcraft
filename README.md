# NeelCraft All-in-One VPS Installer

Ek hi command se VPS par Pterodactyl Panel, Wings, Tailscale, Cloudflare Tunnel, MariaDB, Ubuntu VNC Docker, Debian VM aur dashboards setup karne ke liye ek menu-based installer.

## Credits

- **Original script / idea:** LAPIO BHAI (Lapiogamer). Is project ka base unka kaam hai, aur unhe full credit diya gaya hai.
- **Pterodactyl installer:** [pterodactyl-installer.se](https://pterodactyl-installer.se) (community script)
- **Hosting panel source:** [deadlauncherg/Hosting-panel](https://github.com/deadlauncherg/Hosting-panel)
- **ChunkDash / Feastic theme:** deadlauncherg repo se download hota hai
- **nvm:** [nvm-sh/nvm](https://github.com/nvm-sh/nvm)

## Features

- Pterodactyl Panel aur Wings install
- Playit tunnel setup
- Cloudflare Tunnel setup (token ke saath)
- Tailscale install aur `tailscale up`
- MariaDB database setup
- Ubuntu VNC Docker container
- Debian 11 VM (KVM + cloud-init, qemu aur seed ISO ke saath)
- System information aur root password change

## Requirements

- Ubuntu 22.04 / 24.04 ya Debian 11 / 12 (root access ke saath)
- Virtualization (VM ke liye): `egrep -c '(vmx|svm)' /proc/cpuinfo` ka output `0` se bada hona chahiye
- Internet connection

## Install (ek command)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/NeelAhuja1234/neelcraft/refs/heads/main/installer.sh)
```

Ya root ke roop mein:

```bash
sudo bash <(curl -fsSL https://raw.githubusercontent.com/NeelAhuja1234/neelcraft/refs/heads/main/installer.sh)
```

## Menu

```
1) Setup IDX VM (dev.nix + script.sh)
2) Run Ubuntu VNC Docker
3) Install Pterodactyl Panel + Node
4) Install Playit
5) ChunkDash Dashboard
0) Exit
```

## Security

- Koi bhi script root par chalane se pehle uska code khud padh lo.
- Tunnel tokens aur passwords ko kisi public jagah share mat karo.
- Installer ke andar external scripts aur repos chalte hain. Unki security aap khud verify karo.

## Disclaimer

Ye project sirf educational aur personal use ke liye hai. Kisi bhi third-party service ya script ke kaam ki guarantee nahi hai.
