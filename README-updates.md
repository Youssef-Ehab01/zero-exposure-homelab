# README updates

Paste these blocks into your current `README.md`, replacing the matching sections.

## Progress

```
- [x] Install Debian 13 (netinst, CLI-only)
- [x] Reserve a DHCP address for the server on the router
- [x] SSH key login from my main laptop
- [x] Tailscale working from outside the home network (tested on a phone hotspot)
- [x] Disable SSH password and root login
- [ ] Keep running with the lid closed   (tick it if you have done this)
- [x] `ufw` default-deny with Tailscale-only SSH
- [x] Lynis audit (66 → 78)
- [x] "Family Hub" page (nginx + Homer)
- [x] Family file drive (copyparty)
- [ ] Backups to an external USB drive
- [ ] Network-wide DNS filtering (AdGuard Home)
- [ ] Forward logs to a SIEM (Wazuh or Splunk)
```

## Results

| Check | Before hardening | After hardening |
|---|---|---|
| Lynis hardening index | 66 | 78 |
| Listening ports (`ss -tulpn`) | TODO | TODO |
| SSH password authentication | enabled | disabled |

## Documentation

1. [Hardware and OS choice](docs/01-hardware-and-os.md)
2. [Installing Debian (CLI-only)](docs/02-install-debian.md)
3. [SSH hardening](docs/03-ssh-hardening.md)
4. [Tailscale VPN](docs/04-tailscale.md)
5. [Firewall with ufw](docs/05-firewall.md)
6. [Lynis audit](docs/06-lynis-audit.md)
7. [Family Hub (nginx + Homer)](docs/07-family-hub.md)
8. [Family file drive (copyparty)](docs/08-family-file-drive.md)
9. [Troubleshooting](docs/troubleshooting.md)
10. [Dev log](docs/devlog.md)

## Skills demonstrated (replace the line)

Linux server administration (Debian) · SSH key authentication and hardening · VPN design (Tailscale, WireGuard-based) · host firewalling (`ufw`) and understanding how it interacts with Tailscale · intrusion prevention and auditing (fail2ban, auditd, Lynis) · least-privilege service design (dedicated users, hardened systemd units, per-folder permissions) · self-hosted web services (nginx) · technical documentation

## Problems I hit and how I solved them (add these bullets)

- **A service worked over Tailscale but not from the home network.** Tailscale bypasses ufw, so the VPN path worked even though the LAN firewall rule was missing. Fix: add the rule for the home subnet.
- **`systemctl enable` failed with "Bad message".** The unit file copied from Windows had the wrong encoding or line endings. Fix: recreate it on the server with `tee` and check it with `file`.

## Roadmap (replace the list)

- [ ] Backups of the family files to an external drive
- [ ] AdGuard Home with a friendly local name
- [ ] Home SIEM receiving this server's logs (detections mapped to MITRE ATT&CK)
- [ ] Tailscale ACLs so each device reaches only what it needs
- [ ] Web application security write-up (OWASP Juice Shop, then my own app)
- [ ] Rebuild the server from the repo with Ansible (stretch)
