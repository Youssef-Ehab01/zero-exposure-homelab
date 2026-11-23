# Screenshots and evidence

Evidence for the docs pages. Prefer **text output** pasted into the docs as code blocks (searchable and easy to redact) and use images only where visuals matter.

## Capture checklist

| File | What to capture | How | Redact | Used in |
|---|---|---|---|---|
| `01-hardware-specs.png` | Specs output | Run the commands in doc 01 | Hostname | 01 |
| `02-kali-resource-usage.png` | Kali CPU and RAM usage | Photo of the old Kali screen | **Public IP, username, hostname** | 01 |
| `03-iso-checksum-match.png` | `True` from the checksum comparison | PowerShell | Username in path | 02 |
| `04-installer-software-selection.png` | Software selection screen | Photo of installer | None | 02 |
| `05-installer-grub-device.png` | GRUB device list (internal disk chosen) | Photo of installer | None | 02 |
| `06-os-release-and-idle.png` | `cat /etc/os-release; free -h; uptime` | Server terminal | Hostname | 01, 02 |
| `07-ssh-key-login.png` | Login without a password prompt | PowerShell | User, address | 03 |
| `08-sshd-effective-config.png` | `sshd -T` showing both settings `no` | Server terminal | None | 03 |
| `09-ssh-password-denied.png` | `Permission denied (publickey)` | PowerShell | User, address | 03 |
| `10-hostkey-warning.png` (optional) | The host-key warning | PowerShell | **PC username in path, address** | troubleshooting |
| `11-tailscale-status.png` | `tailscale status` | Terminal | Addresses, device and account names | 04 |
| `12-hotspot-ssh-test.png` | SSH over Tailscale from a phone hotspot | PowerShell | User, addresses | 04 |
| `13-ufw-status-verbose.png` | `sudo ufw status verbose` | Server terminal | LAN subnet if shown | 05 |
| `14-listening-ports.png` | `sudo ss -tulpn` | Server terminal | None | 05 |
| `15-nmap-from-lan.png` | nmap against my own server, ports `filtered` | PowerShell | Address | 05 |
| `16-lynis-before.png` | Lynis score before fixes | Server terminal | Hostname | 06 |
| `17-lynis-after.png` | Lynis score after fixes | Server terminal | Hostname | 06 |

The network diagram goes in `diagrams/`, not here.

## Rules

- PNG format, one idea per image, cropped tight.
- On Windows, **Win + Shift + S** takes a cropped screenshot.
- Blur or replace anything private: public IPs, LAN addresses, usernames, hostnames, MAC addresses, account names.
- Photos of a screen: crop out the surroundings.
- Run `git diff --staged` before every commit and look at each image once more.
