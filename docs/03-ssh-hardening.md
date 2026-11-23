# 03 – SSH hardening

**Goal:** SSH access with keys only; no password logins and no root login.

**Why:** password guessing and credential reuse are the most common ways into SSH servers. Keys remove that whole attack path.

## 1. Create a key pair (on my main laptop)

```powershell
ssh-keygen -t ed25519
```

## 2. Install the public key on the server

```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh <user>@<server-lan-ip> "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

Test with a fresh `ssh <user>@<server-lan-ip>`; it should not ask for the account password.

![screenshots/07-ssh-key-login.png](../screenshots/07-ssh-key-login.png)

## 3. Disable passwords and root login

In `/etc/ssh/sshd_config`:

```
PasswordAuthentication no
PermitRootLogin no
```

```bash
sudo sshd -t                 # config syntax check
sudo systemctl reload ssh
sudo sshd -T | grep -E 'passwordauthentication|permitrootlogin'
```

I kept the existing session open and tested a second login before closing anything, so a mistake could not lock me out.

> **TODO (evidence):** `screenshots/08-sshd-effective-config.png` (both lines should say `no`).

## 4. Prove passwords are rejected

```powershell
ssh -o PreferredAuthentications=password <user>@<server-lan-ip>
# expect: Permission denied (publickey)
```

![screenshots/09-ssh-password-denied.png](../screenshots/09-ssh-password-denied.png)
## Host key verification

After reinstalling the OS, SSH warned that the host key had changed. I did not just delete the entry: I compared the fingerprint on the server's own console with the one in the warning, then removed the stale entry. Details in [troubleshooting](troubleshooting.md).

## What this does and doesn't protect against

- Protects against: password brute force and credential stuffing over SSH.
- Doesn't protect against: a stolen private key (mitigated by a key passphrase), or compromise of my main laptop.

## What I'd do differently

> **TODO:** one or two lines.
