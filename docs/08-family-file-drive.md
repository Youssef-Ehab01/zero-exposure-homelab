# 08 – Family file drive (copyparty)

**Goal:** give each family member a private folder plus a shared folder, reachable from a web page, so files live on the server instead of scattered across devices.

**Why copyparty:** the popular File Browser project was archived on 2026-09-01 and no longer gets security fixes ([Linuxiac](https://linuxiac.com/popular-self-hosted-file-manager-file-browser-is-shutting-down/), [comparison of alternatives](https://jacar.es/en/file-browser-archived-alternatives/)). copyparty is actively maintained, is a single Python program that needs no Docker, uses little memory, and supports per-folder permissions.

## Design

| Decision | Choice | Why |
|---|---|---|
| Accounts | One per family member, random 14-character passwords | No shared logins, nothing guessable |
| Folders | `/srv/family/private/<name>` per person plus `/srv/family/shared` | Privacy by default |
| Permissions | Private: owner has full control. Shared: everyone can add and read; only the admin (me) can delete or move | Least privilege; accidents are recoverable |
| Anonymous access | None | Every request needs a login |
| Network | HTTP on port 3923, allowed from the home network by ufw; reachable over Tailscale | Passwords cross the home Wi-Fi unencrypted, so use unique ones |
| Service | Dedicated `copyparty` user, hardened systemd unit, memory limit | A bug in the app cannot touch the rest of the system |
| Version | Pinned to one release in a virtual environment | Updates are deliberate |
| Abuse protection | Temporary ban after repeated wrong passwords or forbidden requests | Slows guessing |

## Steps (on the server)

### 1. Install

```bash
sudo apt install -y python3-venv
sudo python3 -m venv /opt/copyparty
sudo /opt/copyparty/bin/pip install "copyparty==1.20.26"
sudo useradd --system --home-dir /var/lib/copyparty --create-home --shell /usr/sbin/nologin copyparty
```

### 2. Create the folders, accounts and config

The generator script is in [`scripts/setup-family-drive.sh`](../scripts/setup-family-drive.sh). The first name is the admin.

```bash
sudo /usr/local/sbin/setup-family-drive.sh <admin> <member2> <member3> ...
```

It prints each password once. They go in a password manager, never in git. The generated `/etc/copyparty.conf` contains the passwords and is readable only by root and the service user. **Never commit it.**

### 3. Service and firewall

The unit file is in [`configs/copyparty.service`](../configs/copyparty.service). Create it directly on the server (a file copied from Windows failed with "Bad message", see [troubleshooting](troubleshooting.md)).

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now copyparty
sudo ufw allow from <lan-subnet> to any port 3923 proto tcp
```

### 4. Hub buttons

Two tiles in [`configs/homer-config.yml`](../configs/homer-config.yml): one for the home network and one for use with Tailscale (see [doc 07](07-family-hub.md)).

## Verify

| Test | Expected | Result |
|---|---|---|
| Open `http://<server-lan-ip>:3923` and log in as a family member | Sees only their own folder and `shared` | TODO |
| Log in as a second member in a private window | Cannot see the first member's folder | TODO |
| Upload a file to `shared` as a non-admin | Succeeds | TODO |
| Try to delete it as that non-admin | Refused | TODO |
| Delete it as the admin | Succeeds | TODO |
| Wrong password | Refused | TODO |
| Anonymous request to a folder URL | Refused | TODO |
| `sudo ls -lR /srv/family` after an upload | The file appears in the right folder | TODO |

> **TODO (evidence):** `screenshots/18-file-drive-login.png` and `screenshots/19-file-drive-folders.png` (blur addresses and usernames).

## Operations

- **Logs:** `journalctl -u copyparty -n 50 --no-pager`
- **Lockout:** repeated wrong passwords ban a client for an hour. `sudo systemctl restart copyparty` clears it.
- **Updates:** check the release notes monthly, then `sudo /opt/copyparty/bin/pip install -U copyparty` and restart the service.
- **Backups:** the server has one old disk, so this is the only copy of everything uploaded until the backup step is done.

## Security notes

- Tailscale bypasses ufw (see [doc 05](05-firewall.md)), so any device on my tailnet can reach the login page. The app's own accounts protect the files.
- Plain HTTP on the home network is an accepted trade-off. A later improvement is HTTPS in front of the service.
- Passwords are stored in plain text in a root-and-service-readable config file; file permissions are the protection.

## What I'd do differently

> **TODO:** one or two lines. A suggestion: create small system files such as unit files directly on the server instead of copying them from Windows.
