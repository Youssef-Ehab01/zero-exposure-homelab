#!/usr/bin/env bash
# Creates the family folders and a copyparty config with random passwords.
# Usage: sudo setup-family-drive.sh ADMIN_USER [OTHER_USER ...]
set -euo pipefail

ROOT="${FAMILY_ROOT:-/srv/family}"
CONF="${CONF:-/etc/copyparty.conf}"
SVC_USER="${SVC_USER:-copyparty}"

[ "$#" -ge 1 ] || { echo "usage: sudo $0 ADMIN_USER [OTHER_USER ...]"; exit 1; }
id "$SVC_USER" >/dev/null 2>&1 || { echo "service user '$SVC_USER' does not exist yet"; exit 1; }
USERS=("$@")
ADMIN="$1"
for u in "${USERS[@]}"; do
  [[ "$u" =~ ^[a-z][a-z0-9_-]{1,31}$ ]] || { echo "bad username '$u' (lowercase letters, digits, - or _ only)"; exit 1; }
done

umask 077
mkdir -p "$ROOT/shared"
declare -A PW
RWLIST="$(printf '%s, ' "${USERS[@]}")"; RWLIST="${RWLIST%, }"

{
  cat <<EOF
[global]
  p: 3923
  name: Family Files
  usernames
  chpw
  chpw-len: 10
  chpw-db: /var/lib/copyparty/chpw.json
  hist: /var/lib/copyparty/hist
  http-only
  no-crt
  no-thumb
  no-robots
  ban-pw: 9,60,60
  ban-403: 9,2,60

[accounts]
EOF
  for u in "${USERS[@]}"; do
    PW[$u]="$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 14)"
    echo "  $u: ${PW[$u]}"
  done
  cat <<EOF

[/shared]
  $ROOT/shared
  accs:
    rw: $RWLIST
    A: $ADMIN
EOF
  for u in "${USERS[@]}"; do
    mkdir -p "$ROOT/private/$u"
    cat <<EOF

[/$u]
  $ROOT/private/$u
  accs:
    rwmd: $u
EOF
  done
} > "$CONF"

chown root:"$SVC_USER" "$CONF"; chmod 640 "$CONF"
chown -R "$SVC_USER":"$SVC_USER" "$ROOT"; chmod -R u=rwX,g=rX,o= "$ROOT"

echo
echo "Done. Credentials (shown once - save them in a password manager, NOT in git):"
for u in "${USERS[@]}"; do printf '  %-14s %s\n' "$u" "${PW[$u]}"; done
echo
echo "Config: $CONF   Folders: $ROOT"
