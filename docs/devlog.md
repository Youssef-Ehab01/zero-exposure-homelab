# Dev log

Short, dated notes, newest first. Add an entry after every session on the server.

## Template

```
## YYYY-MM-DD – what I did
- **Changed:**
- **Result:**
- **Learned:**
- **Next:**
```

Dates marked (approx.) were reconstructed from memory; correct any that are off.

---

## 2026-11-26 – End-to-end check and docs catch-up
- **Changed:** updated docs 01–06 with real results, added doc 07 (Family Hub) and doc 08 (family file drive), refreshed troubleshooting.
- **Result:** the Hub and the file drive both work from the home network and over Tailscale.
- **Learned:** write each doc page the same day, while the commands and error messages are fresh.
- **Next:** backups to an external USB drive, then AdGuard Home.

## 2026-11-25 – File drive service problems
- **Changed:** started the copyparty service. Hit `Unit copyparty.service does not exist`, then `Bad message`, and later found the web page unreachable from the home network. Added the LAN firewall rule for port 3923.
- **Result:** unit file recreated directly on the server with `tee`; the page works from the home network and over Tailscale.
- **Learned:** files copied from Windows can carry encoding or line-ending problems, so small system files are safer to create on the server. Tailscale bypasses ufw, so a service can work over the VPN while its LAN rule is still missing.
- **Next:** test that the private and shared folders are isolated with two accounts.

## 2026-11-24 – Family file drive
- **Changed:** chose copyparty (File Browser was archived on 2026-09-01 and no longer gets security fixes). Installed it in a virtual environment pinned to one version, with a dedicated service user, a hardened systemd unit and a script that creates the folders and random passwords.
- **Result:** a private folder per person plus a shared folder where only the admin can delete or move files.
- **Learned:** least privilege applies to family files too: everyone can add and read in the shared folder, but deleting needs the admin.
- **Next:** start the service and open the firewall for the home network.

## 2026-11-23 – Lynis round 2 and the Family Hub
- **Changed:** updated Lynis and fixed more findings (fail2ban, libpam-tmpdir, extra SSH settings, kernel modules, packages). Built the Family Hub with nginx and Homer.
- **Result:** Lynis index 78. The Hub opens from the home network and over Tailscale.
- **Learned:** upgrading the audit tool mid-project changes the tests, so record the version with each score.
- **Next:** family file drive.

## 2026-11-22 – Lynis fixes, round 1
- **Changed:** worked through the first batch of findings (malware scanner, kernel modules, packages, banners, accounting, auditd).
- **Result:** index 66 → 76.
- **Next:** re-audit and decide on the remaining suggestions.

## 2026-11-21 – Baseline audit and nmap checks
- **Changed:** ran the baseline Lynis audit (66). Scanned the server with nmap from a Kali VM, once via the home-network address and once via the Tailscale address.
- **Result:** from the home network, ports 22/80/443 were `filtered`; over Tailscale, 22 was `open` and 80/443 were `closed`.
- **Learned:** Tailscale accepts traffic before ufw, which explains the difference (see doc 05).
- **Next:** fix the Lynis findings.

## 2026-11-19 – GitHub repo and docs (approx.)
- **Changed:** created the repo, pushed the README and docs pages, started redacting screenshots.
- **Learned:** black redaction boxes are invisible on a black terminal; use a visible gray box.
- **Next:** fill in the evidence for each page.

## 2026-11-17 – SSH keys, Tailscale and firewall (approx.)
- **Changed:** DHCP reservation; first SSH from the main laptop (verified the changed host-key fingerprint on the server console); key login; Tailscale (tested from a phone hotspot); `ufw` default-deny with SSH over Tailscale.
- **Result:** the server is reachable only over the VPN.
- **Learned:** a "host key changed" warning after a reinstall is expected, but verify the fingerprint before removing the old entry.
- **Next:** security audit with Lynis.

## 2026-11-16 – First boot (approx.)
- **Changed:** updated the system and installed the base packages (`ufw`, `unattended-upgrades`, `tmux`, `htop`, `curl`).
- **Next:** reserve the server's address on the router and SSH in from the main laptop.

## 2026-11-15 – Debian installer
- **Changed:** booted the Debian 13 netinst USB on the HP Compaq 6720s and worked through the installer (mirror, software selection, GRUB).
- **Result:** reached the GRUB and software-selection screens with Ethernet connected.
- **Learned:** in the installer, Space ticks boxes and Enter presses Continue; choose the internal disk for GRUB, not the USB stick.
- **Next:** first boot, updates, and SSH from the main laptop.

## 2026-11-14 – Kali was too heavy
- **Changed:** decided to replace Kali with a CLI-only Debian. Downloaded the Debian netinst ISO and verified its checksum.
- **Result:** ready to install.
- **Learned:** a desktop and a heavy terminal UI on 3 GB of RAM kept both cores near 100%.
- **Next:** boot the installer.
