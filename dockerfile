FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xfce4 xfce4-terminal \
    dbus-x11 x11-xserver-utils \
    tigervnc-standalone-server tigervnc-common \
    novnc websockify \
    openssh-server sudo supervisor \
    nano curl ca-certificates \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# SSH setup
RUN mkdir -p /var/run/sshd \
 && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
 && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Create user
ARG USERNAME=kali
RUN useradd -m -s /bin/bash ${USERNAME} \
 && usermod -aG sudo ${USERNAME} \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-sudo-nopasswd

# Create TigerVNC xstartup (baked into image)
RUN mkdir -p /home/${USERNAME}/.config/tigervnc \
 && printf '%s\n' \
'#!/bin/sh' \
'unset SESSION_MANAGER' \
'unset DBUS_SESSION_BUS_ADDRESS' \
'[ -r "$HOME/.Xresources" ] && xrdb "$HOME/.Xresources"' \
'exec dbus-launch --exit-with-session startxfce4' \
 > /home/${USERNAME}/.config/tigervnc/xstartup \
 && chmod +x /home/${USERNAME}/.config/tigervnc/xstartup \
 && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.config

# Supervisor config + entrypoint
COPY start-vnc.sh /usr/local/bin/start-vnc.sh
COPY start-novnc.sh /usr/local/bin/start-novnc.sh
RUN chmod +x /usr/local/bin/start-vnc.sh /usr/local/bin/start-novnc.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 5901 6080
CMD ["/entrypoint.sh"]
