
Kali Remote Desktop — Browser-Based Kali via noVNC

A clean, containerized Kali Linux desktop environment accessible directly from a web browser.

This project provides a practical way to run a full Kali Linux graphical desktop using Docker and noVNC, without installing a local desktop environment or VNC client. The entire stack runs inside containers and is exposed through a standard web interface.

It is designed for professionals, students, and researchers who need fast, reproducible access to a Kali desktop in isolated environments such as VPS servers, cloud instances, or private labs.

────────────────────
Overview
────────────────────

Kali Remote Desktop runs a lightweight Kali Linux desktop session inside a Docker container. A VNC server provides graphical access, while noVNC bridges the VNC session to the browser over HTTP.

Docker Compose orchestrates all services and ensures the correct startup order. Supporting scripts handle session initialization and process supervision, keeping the setup predictable and easy to inspect.

No local GUI, VNC client, or additional software is required beyond Docker.

────────────────────
Use cases
────────────────────

• Remote Kali Linux desktop on a VPS
• Security training and controlled testing environments
• Temporary Kali setups without local installation
• Demonstrations, workshops, or lab access via browser

This project is intended for authorized and ethical use only.

────────────────────
Requirements
────────────────────

• Linux system (VPS or local server)
• Docker installed and running
• Docker Compose available

You can verify your setup with:
docker –version
docker compose version

────────────────────
Getting started
────────────────────

Clone the repository and enter the project directory:
git clone git@github.com:hrco/kali-remote.git
cd kali-remote

Start the environment using Docker Compose:
docker compose up -d

On the first run, Docker will build the image and download required layers. This may take several minutes depending on system resources and network speed.

Once running, open your browser and navigate to:
http://SERVER_IP:PORT

Replace SERVER_IP with your server address. The exposed port is defined in the Docker Compose configuration.

────────────────────
Working with the environment
────────────────────

All interaction with Kali happens through the browser-based desktop. The environment behaves like a standard Kali Linux installation, including terminal access and preinstalled tools.

Useful operational commands:

Check container status:
docker compose ps

View logs:
docker compose logs -f

Stop the environment:
docker compose down

Stopping the stack does not remove images or volumes unless explicitly requested. The environment can be restarted at any time.

────────────────────
Security considerations
────────────────────

This setup does not include authentication or encryption by default. If exposed to the internet, it should be secured using firewall rules, a reverse proxy, TLS, or additional authentication mechanisms.

Only deploy and use this project on systems you own or are authorized to test.

────────────────────
Notes
────────────────────

The repository prioritizes clarity and simplicity over abstraction. All configuration is intentionally visible and modifiable, making the project suitable as both a working tool and a learning reference.

