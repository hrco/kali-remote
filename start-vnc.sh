#!/usr/bin/env bash
set -euo pipefail

USERNAME="${USERNAME:-kali}"
VNC_PASSWORD="${VNC_PASSWORD:-ChangeMe_VNCPassword}"
VNC_GEOMETRY="${VNC_GEOMETRY:-1920x1080}"
VNC_DEPTH="${VNC_DEPTH:-24}"

# Stop any previous VNC on :1
su - "$USERNAME" -c "bash -lc 'tigervncserver -kill :1 >/dev/null 2>&1 || true'"
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 || true
rm -f /home/"$USERNAME"/.vnc/*:1.pid || true

# Password file
su - "$USERNAME" -c "bash -lc '
  mkdir -p ~/.config/tigervnc ~/.vnc
  if [ ! -f ~/.config/tigervnc/passwd ]; then
    printf \"%s\n\" \"$VNC_PASSWORD\" | vncpasswd -f > ~/.config/tigervnc/passwd
    chmod 600 ~/.config/tigervnc/passwd
  fi
'"

# Start VNC server (foreground)
su - "$USERNAME" -c "bash -lc '
  export DISPLAY=:1
  Xtigervnc :1 \
    -rfbauth ~/.config/tigervnc/passwd \
    -SecurityTypes VncAuth \
    -geometry \"$VNC_GEOMETRY\" -depth \"$VNC_DEPTH\" \
    -AlwaysShared -localhost no &
  echo \$! > ~/.vnc/xtigervnc.pid

  # Start desktop session after X is up
  sleep 1
  unset SESSION_MANAGER
  unset DBUS_SESSION_BUS_ADDRESS
  dbus-launch --exit-with-session startxfce4 &
  echo \$! > ~/.vnc/xfce4.pid

  # Keep script alive so Supervisor doesn't restart it
  wait -n
'"
