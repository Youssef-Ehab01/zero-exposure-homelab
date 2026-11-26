# Troubleshooting

A running list of real problems and how I solved them.

| Symptom                                                                                | Cause                                                                            | Fix                                                                                                                                                                                                                                                                       |
| -------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Installer: "No network mirror was selected. Continue without a network mirror?"        | A mirror was skipped; continuing would leave only a minimal base system          | Answer **No**, go back to mirror selection, pick `http`, a nearby country and `deb.debian.org`. Check the Ethernet cable if it still fails                                                                                                                                |
| Software-selection screen skipped ahead when I pressed Enter on an item                | In this installer, **Space** ticks a box and **Enter** presses Continue          | Untick desktops with Space, tick **SSH server** and **standard system utilities**, then Tab to Continue and press Enter                                                                                                                                                   |
| `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!` when connecting after the reinstall | The reinstall created new SSH host keys; my laptop still remembered the old ones | Compare the fingerprint shown in the warning with the one on the server console (`ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub`). If they match, remove the stale entry with `ssh-keygen -R <server-lan-ip>` and reconnect. If they don't match, stop and investigate |
| `grep -qw lm /proc/cpuinfo` printed "32-bit only" on a machine that was clearly 64-bit | The one-liner is fragile; it only means something in a real x86 Linux shell. The laptop had already run 64-bit Kali | Use `uname -m` (expect `x86_64`), `dpkg --print-architecture` (expect `amd64`) and `lscpu` on the server itself |
| `Failed to enable unit: Unit copyparty.service does not exist` | The unit file was only in my home folder; it was never installed into `/etc/systemd/system/` | `sudo install -m 644 ~/copyparty.service /etc/systemd/system/copyparty.service`, then `sudo systemctl daemon-reload` |
| `Failed to enable unit: File copyparty.service: Bad message` | The file copied from Windows had the wrong encoding or line endings | Recreate it on the server with `sudo tee /etc/systemd/system/copyparty.service <<'EOF' ... EOF`, check with `file` (expect "ASCII text"), then `daemon-reload` |
| The file drive page works over Tailscale but not from the home network | Tailscale traffic bypasses ufw; the rule for the port was missing | `sudo ufw allow from <lan-subnet> to any port 3923 proto tcp` |
| `tailscale ping` printed "is local Tailscale IP" | I ran it on the server, so it pinged itself | Run it from the other device |
| Redaction boxes in terminal screenshots looked like missing text | Black boxes on a black background are invisible | Use a mid-gray box so readers can see something was redacted |


## Habit

When a warning mentions a possible attack, verify first and then act. The host-key warning is almost always harmless, but checking the fingerprint takes under a minute.

## Known behavior (not hit yet)

- **File drive lockout:** copyparty temporarily bans a client after repeated wrong passwords or forbidden requests (one hour with my settings). Restarting the service clears the ban: `sudo systemctl restart copyparty`.
