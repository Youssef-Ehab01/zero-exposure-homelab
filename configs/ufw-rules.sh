#!/usr/bin/env bash
# Recreates the home server's firewall. Run on the server with sudo.
# Usage: sudo LAN_SUBNET=192.168.x.0/24 ./ufw-rules.sh   (use your own subnet)
set -euo pipefail
: "${LAN_SUBNET:?set LAN_SUBNET, for example LAN_SUBNET=192.168.1.0/24}"

ufw default deny incoming
ufw default allow outgoing

# SSH only over the VPN interface
ufw allow in on tailscale0 to any port 22 proto tcp

# Family Hub (nginx + Homer)
ufw allow from "$LAN_SUBNET" to any port 80 proto tcp
ufw allow in on tailscale0 to any port 80 proto tcp   # redundant: Tailscale bypasses ufw

# Family file drive (copyparty)
ufw allow from "$LAN_SUBNET" to any port 3923 proto tcp

ufw enable
ufw status verbose
