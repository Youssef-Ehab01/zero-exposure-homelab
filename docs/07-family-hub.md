# 07 – Family Hub (nginx + Homer)

**Goal:** one simple page of big buttons that non-technical family members can open from any device.

**Why:** the server will run several services on different ports, and nobody in the family should have to remember addresses. Homer is a static dashboard (no database, no background process) and nginx serves it using almost no RAM.

## Steps (on the server)

### 1. Install nginx and open port 80

```bash
sudo apt install -y nginx unzip
sudo ufw allow from <lan-subnet> to any port 80 proto tcp
sudo ufw allow in on tailscale0 to any port 80 proto tcp
```

The second rule is redundant because Tailscale bypasses ufw (see [doc 05](05-firewall.md)). It documents the intent.

### 2. Download and unpack Homer

```bash
cd /tmp
curl -fsSLO https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip
sudo mkdir -p /var/www/homer
sudo unzip -o homer.zip -d /var/www/homer
```

### 3. Configure the buttons

The buttons live in `/var/www/homer/assets/config.yml`. A sanitized copy is in [`configs/homer-config.yml`](../configs/homer-config.yml). Homer reads the file in the browser on every page load, so edits need no restart. Keep YAML indentation to spaces only.

### 4. Point nginx at Homer

A copy of the site config is in [`configs/nginx-homer.conf`](../configs/nginx-homer.conf).

```bash
sudo rm /etc/nginx/sites-enabled/default
sudo tee /etc/nginx/sites-available/homer > /dev/null <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    server_tokens off;
    root /var/www/homer;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF
sudo ln -s /etc/nginx/sites-available/homer /etc/nginx/sites-enabled/homer
sudo nginx -t
sudo systemctl reload nginx
```

The quoted `'EOF'` stops the shell from expanding `$uri`. `server_tokens off` stops nginx from advertising its version.

## Verify

| Test | Expected | Result |
|---|---|---|
| Open `http://<server-lan-ip>` from a device on the home network | The Family Hub page loads | TODO |
| Open `http://<tailscale-ip>` with Tailscale on (phone hotspot) | The Family Hub page loads | TODO |
| "Add to Home Screen" on a phone | An app-like icon appears | TODO |

> **TODO (evidence):** `screenshots/17-family-hub.png` (hide the address bar or blur the addresses).

## Design notes

- The page is plain HTTP and static, so it is safe on the home network and over Tailscale (encrypted by the VPN). Never type passwords into it.
- A Hub link can hold only one address, so the LAN address does not work away from home. The file drive therefore has two tiles: one for the home network and one for use with Tailscale. A local DNS name (AdGuard Home) or a reverse proxy could merge them later.
- Tiles for services I have not built yet point to `#` as placeholders.

## Problems and fixes

See [troubleshooting](troubleshooting.md).

## What I'd do differently

> **TODO:** one or two lines. A suggestion: plan addressing up front. Decide whether family devices will use Tailscale everywhere or a local DNS name at home before building the buttons.
