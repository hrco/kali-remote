#!/usr/bin/env bash
set -euo pipefail

USERNAME="${USERNAME:-kali}"
USER_PASSWORD="${USER_PASSWORD:-ChangeMe_StrongPassword}"

# Ensure the user exists first
if ! id "${USERNAME}" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "${USERNAME}"
fi

# Put user in sudo group (no harm if already there)
usermod -aG sudo "${USERNAME}" || true

# Now set the password
echo "${USERNAME}:${USER_PASSWORD}" | chpasswd

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
