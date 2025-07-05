<p align="center">
  <img src="assets/Q-TEAM.small.png" width="200" alt="Q-TEAM">
</p>

<p align="center">
  <a href="https://github.com/Qteam-official/ICMPTunnel/releases">
    <img src="https://img.shields.io/badge/Releases-v1.3.0-blue.svg" alt="Release">
  </a>
  &nbsp;&nbsp;&nbsp;
  <a href="https://github.com/Qteam-official/ICMPTunnel/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/License-Q T E A M-red.svg" alt="License">
  </a>
   &nbsp;&nbsp;&nbsp;
  <a href="https://t.me/Qteam_official">
    <img src="https://img.shields.io/badge/Telegram-Q T E A M-green.svg" alt="Telegram">
  </a>
</p>



---

# ICMPTunnel

**ICMPTunnel** is a proprietary binary tool developed by **Q-TEAM**.  
It demonstrates tunneling over the ICMP protocol (commonly used by ping).


---

## 🛠️ Installation

### 📥 Installer (Recommended)

1. Just run this command to download and start:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/Qteam-official/ICMPTunnel/main/install.sh)
```

2. You can manage the tunnel using the following command:
```bash
q-icmp
```

### 📦 Offline Installation (Internet restrictions)

If you want to install ICMPTunnel without downloading from GitHub (e.g. in an offline environment), follow these steps:

1. **Download the latest release binary** (`ICMPTunnel`) from the [Releases page](https://github.com/Qteam-official/ICMPTunnel/releases) using another computer with internet access.
2. **Copy** both `install.sh` and the downloaded `ICMPTunnel` binary to your target (offline) Linux machine, placing them in the same directory.
3. **Make sure both files are executable:**

```bash
chmod +x install.sh ICMPtunnel
```

4. **Run the installer:**

```bash
sudo ./install.sh
```

5. When prompted, select `2` for **Offline Installation**.
6. Follow the interactive prompts to choose Client or Server mode and complete the setup.

After installation, you can manage the tunnel using:

```bash
q-icmp
```

> **Note:** The binary file must be named exactly `ICMPTunnel` and be in the same directory as `install.sh` during installation.

### 🚢 Install With Docker Compose

1. **Install Docker** using the official installation script:

```bash
curl -fsSL https://get.docker.com | sh
```

2. **Make** a new working directory:

```bash
mkdir ICMPTunnel && cd ICMPTunnel
```

3. **Create** docker compose configuration file.

- Open `docker-compose.yml` in your favorite editor (e.g. nano):

```bash
nano docker-compose.yml
```

- Copy&Paste the following and save. (`ctrl + x`, `y` and `enter` for nano)

```yaml
services:
  icmptunnel:
    image: thisispogger/icmptunnel:latest
    container_name: icmptunnel
    restart: unless-stopped
    network_mode: host
    privileged: true
    cap_add:
      - NET_ADMIN
      - NET_RAW
    volumes:
      - ./config.json:/app/config.json:ro
    healthcheck:
      test: ["CMD", "pgrep", "-x", "ICMPTunnel"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 5s
```

4. **Create** the proper ICMPTunnel configuration file:

- Open `config.json` in your favorite editor (e.g. nano):

```bash
nano config.json
```

#### Server Configuration Example:
```json
{
  "type": "server",
  "listen_port_socks": "1010",
  "server": "",
  "timeout": 60,
  "block_country": "IR",
  "dns": "8.8.8.8",
  "key": 1234
}
```

#### Client Configuration Example:
```json
{
  "type": "client",
  "listen_port_socks": "1010",
  "server": "127.0.0.1",
  "timeout": 60,
  "block_country": "IR",
  "dns": "8.8.8.8",
  "key": 1234
}
```

> Refer to [Configuration](#configuration) for more details

5. **Run ICMPTunnel**:

```bash
docker compose up -d
```

---

## Configuration

Tunnel configuration is done via `config.json` using key/value pairs:

| Key                 | Description                                                              | Accepted Values                      |
|---------------------|--------------------------------------------------------------------------|--------------------------------------|
| `type`              | Switch between server/client mode                                        | `"server"`/`"client"`                |
| `listen_port_socks` | (Client mode only) SOCKS5 port to listen on                              | Min: 0, Max: 65535                   |
| `server`            | (Client mode only) Server endpoint to connect to                         | Server IP (e.g. 127.0.0.1)           |
| `timeout`           | Connection timeout in seconds                                            | Integer Value > 0                    |
| `block_country`     | Used to block outgoing traffic to specific countries' IPs based on GeoIP | 2-Letter country codes (e.g. `"IR"`) |
| `dns`               | Custom Upstream DNS server                                               | DNS over IP (e.g. `"8.8.8.8"`        |
| `key`               | Private key for security purposes                                        | Integer Value                        |

> ⚠️ **Note:** `key` should be the same on both server and client configurations. 

---

## ✅ Supported Platforms:

+ Linux (amd64, arm64, arm, 386)
+ Windows (amd64, 386)
+ macOS (darwin-amd64, darwin-arm64)

## ✅ Tested on:

+ 🐧 Ubuntu 18.04, 20.04, 22.04+
+ 🐧 Debian 10/11/12+
+ 🐧 Kali, Mint, Fedora, CentOS, AlmaLinux, Rocky
+ 🐧 Arch, Manjaro, openSUSE
+ 🐧 Pop!_OS, Zorin OS, and other modern distros
+ 🪟 Windows 10/11 (both 64-bit and 32-bit)
+ 🍎 macOS (Intel & Apple Silicon)

---

### Ensure ICMP (ping) is allowed on both sides (no firewall blocks)
### Root is NOT required in most modern systems
### No ports need to be opened manually — it works via ICMP!

---

## 🧱 Binary Distribution

This repository contains the official binary release of **ICMPTunnel**, developed by **Q-TEAM**.

It is provided as a ready-to-use executable with no additional components.

---

## 🚫 Usage Restrictions

This binary is the **intellectual property of Q-TEAM**.

You are **not allowed** to:
- Copy or redistribute this binary
- Modify or reverse engineer it
- Use it for unauthorized or illegal purposes

without **explicit written permission** from Q-TEAM.


---


## ⚠️ Disclaimer

ICMP-based tunneling may be restricted on some networks.  
Use of this tool is limited to **legal, educational, or testing purposes in controlled environments only**.

**Q-TEAM is not responsible for any misuse of this software.**

---

## 📈 Star History

[![Star Chart](https://api.star-history.com/svg?repos=Qteam-official/ICMPTunnel&type=Date&theme=dark)](https://star-history.com/#Qteam-official/ICMPTunnel&Date)

> Growth of the community over time 🚀 — Thank you for every ⭐!


---

© 2025 Q-TEAM. All rights reserved.
