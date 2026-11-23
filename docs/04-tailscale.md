# 04 – Tailscale VPN

**Goal:** reach the server securely from anywhere without opening any port on the home router.

**Why:** port forwarding exposes a service to the whole internet, and many home connections can't forward ports at all. Tailscale builds an encrypted WireGuard-based overlay network instead.

## Install and join

On the server:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

Open the login URL on another device, then install Tailscale on my main laptop and sign in with the same account.

```bash
tailscale ip -4        # the server's 100.x.x.x address
```

For an always-on server, I disabled key expiry for this machine in the Tailscale admin console.

## Test from outside the home network

Main laptop on a phone hotspot:

```powershell
ssh <user>@<tailscale-ip>
```

> **TODO (evidence):** `screenshots/12-hotspot-ssh-test.png` (redact addresses).

## Direct vs relayed

At home, traffic between two devices on the same LAN should go directly, not through the internet:

```powershell
tailscale status
tailscale ping <server-name>     # "via 192.168.x.x" = direct, "via DERP" = relayed
```

![screenshots/11-tailscale-status.png](../screenshots/11-tailscale-status.PNG)

## Trade-offs

- Relies on Tailscale's coordination service (traffic itself is end-to-end encrypted).
- Every device needs the app.
- Future options: raw WireGuard on the server, or self-hosting a coordination server.

## Next

> **TODO:** access rules (ACLs) so each device can reach only what it needs.

## What I'd do differently

> **TODO:** one or two lines.
