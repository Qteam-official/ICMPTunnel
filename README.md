<p align="center">
  <img src="assets/Q-TEAM.small.png" width="200" alt="Q-TEAM">
</p>

<div align="center">

  [![Releases](https://img.shields.io/badge/Releases-v1.1.0-blue?logo=github)](https://github.com/Qteam-official/ICMPTunnel/releases)
  &nbsp;&nbsp;&nbsp;
  [![Telegram](https://img.shields.io/badge/Telegram-Q_T_E_A_M-green?logo=telegram&logoColor=fff)](https://t.me/Q_teams)
  &nbsp;&nbsp;&nbsp;
  [![License](https://img.shields.io/badge/©_License-Q%20T%20E%20A%20M-red.svg)](https://github.com/Qteam-official/ICMPTunnel/blob/main/LICENSE)

</div>



---

# ICMPTunnel

This project implements an ICMP-based tunneling mechanism over IPv4, allowing data transmission between a client and a server through ICMP packets (such as Echo Request / Echo Reply).


---

## ⚠️ Note ! 


### Before starting, make sure to ping the destination server to verify that ICMP traffic is allowed and the server is reachable.


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
chmod +x install.sh
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


#### Server Configuration Example:
```json
{
  "type": "server",
  "listen_port_socks": "1010",
  "server": "",
  "timeout": 20,
  "dns":"8.8.8.8",
  "key": 12345678,  
  "api_port" : "1080",
  "encrypt_data" : true,
  "encrypt_data_key" : "Ysh!io19HSwqi1ldm"
}
```

#### Client Configuration Example:
```json
{
  "type": "client",
  "listen_port_socks": "1010",
  "server": "1.2.3.4.5",
  "timeout": 20,
  "dns":"8.8.8.8",
  "key": 12345678,  
  "api_port" : "1080",
  "encrypt_data" : true,
  "encrypt_data_key" : "Ysh!io19HSwqi1ldm"
}
```



---

## 🔧 Configuration

Tunnel configuration is done via `config.json` using key/value pairs:

| Key                 | Description                                                              | Accepted Values                        |
|---------------------|--------------------------------------------------------------------------|----------------------------------------|
| `type`              | Switch between server/client mode                                        | `"server"`/`"client"`                  |
| `listen_port_socks` | (Client mode only) SOCKS5 port to listen on                              | Unused Valid Port (Min: 0, Max: 65535) |
| `server`            | (Client mode only) Server endpoint to connect to                         | Server IP (e.g. 127.0.0.1)             |
| `timeout`           | Connection timeout in seconds                                            | Integer Value > 0                      |
| `dns`               | Custom Upstream DNS server                                               | DNS over IP (e.g. `"8.8.8.8"`          |
| `key`               | Private key for security purposes                                        | Integer Value                          |
| `api_port`          | API port to access usage data&monitoring                                 | Unused Valid Port (Min: 0, Max: 65535) |
| `encrypt_data`      | If you want data encryption to be enabled, set it to **true**, and if you do not want it to be enabled, set it to **false**. |
| `api_port`          | Enter the encryption key in this section.                                 | Simple : Sr!ks2kcPosd |


> ⚠️ **Note:** `key` should be the same on both server and client configurations. 

---

## 📊 Statistics API

You can access real-time system and traffic stats via this endpoint:
> http://`your_ip`:`api_port`/stats?key=`key`

- `your_ip`: Your server's public IP address (Or `localhost` in case of local access)
- `api_port`: Configured in `config.json` (See [Configuration](#configuration))
- `key`: Configured in `config.json` (See [Configuration](#configuration))

#### Example:
- IP = 192.168.1.100
- api_port = 1080
- key = 12345678

In this example, `http://192.168.1.100:1080/stats?key=1234` would return system and traffic stats.

Try using curl command on localhost:
```bash
curl http://localhost:1080/stats?key=1234
```

---

## ✅ Supported Platforms:

+ Linux (amd64, arm64, arm, 386)
+ Windows (amd64, 386)

## ✅ Tested on:

+ 🐧 Ubuntu 18.04, 20.04, 22.04+
+ 🐧 Debian 10/11/12+
+ 🐧 Kali, Mint, Fedora, CentOS, AlmaLinux, Rocky
+ 🐧 Arch, Manjaro, openSUSE
+ 🐧 Pop!_OS, Zorin OS, and other modern distros
+ 🪟 Windows 10/11 (both 64-bit and 32-bit)

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

© 2026 Q-TEAM. All rights reserved.
