#!/usr/bin/env bash
set -euo pipefail

WEBROOT="/usr/share/novnc"
# some distros use /usr/share/novnc/core as the real root
[ -f "/usr/share/novnc/vnc.html" ] || WEBROOT="/usr/share/novnc/core"

exec websockify --web="$WEBROOT" --wrap-mode=ignore 0.0.0.0:6080 localhost:5901
