#!/bin/bash

set -a


if [ "$EUID" -ne 0 ]; then
  echo "🛡️ Please enter your password to run as root..."
  exec sudo bash -c "$(curl -sSL https://raw.githubusercontent.com/Qteam-official/ICMPTunnel/main/install.sh)"
fi

KEY="net.ipv4.icmp_echo_ignore_all"
CONF_FILE="/etc/sysctl.d/99-icmp-tunnel.conf"

CURRENT=$(sysctl -n $KEY)

if [ "$CURRENT" -eq 1 ]; then
    echo "[✓] ICMP echo ignore is already enabled."
else
    echo "[*] Enabling ICMP echo ignore..."
    sysctl -w $KEY=1

    if [ ! -f "$CONF_FILE" ]; then
        echo "$KEY = 1" > $CONF_FILE
        sysctl --system > /dev/null
        echo "[✓] ICMP echo ignore enabled permanently."
    fi
fi


Version="v1.1.0"
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'
PORT=1010
REPO="Qteam-official/ICMPTunnel"
GITHUB_API="https://api.github.com/repos/$REPO/releases/latest"
BINARY_NAME="ICMPTunnel"
INSTALL_PATH="/usr/local/bin/$BINARY_NAME"
GEOIP_COUNTRY_PATH_DL="https://raw.githubusercontent.com/Qteam-official/ICMPTunnel/main/geoip/geoip-country.mmdb"
GEOIP_COUNTRY_PATH="/usr/local/bin/geoip-country.mmdb"
CONFIG_PATH="/usr/local/bin/config.json"
SERVICE_CLIENT="icmptunnel-client.service"
SERVICE_SERVER="icmptunnel-server.service"
MODE_FILE="/opt/icmptunnel/mode.conf"

function install_icmp() {
  INSTALL_MODE=""
  while true; do
    clear
    echo
    echo -e "${CYAN}"
    echo "╭────────────────────────────────────────────────────────────╮"
    echo "│                  🚀  ICMPTunnel Installer                  "
    echo "│                                                            "
    echo "│      🔎 Api Port Server and Client (  1080  )              "
    echo "│      🔍 Listen Port Client Socks5  ( 1010 )                "
    echo "│                                                            "
    echo "│      🛰  Lightweight Tunneling over ICMP Protocol          "
    echo "│      🧠  Developed with 💙  by Q-TEAM                      "
    echo "│      📢  Telegram: @Q_teams                                "
    echo "│      📦 Version : $Version                                 "
    echo "╰────────────────────────────────────────────────────────────╯"
    echo -e "${NC}"
    echo
    echo -e "${YELLOW}💡 Select installation mode:${NC}"
    echo -e "${CYAN}1)${NC} Online Installation (Download from GitHub)"
    echo -e "${CYAN}2)${NC} Offline Installation (Use local file)"
    read -p "➡️  Your choice [1/2]: " install_choice
    if [[ "$install_choice" == "1" ]]; then
      INSTALL_MODE="online"
      break
    elif [[ "$install_choice" == "2" ]]; then
      INSTALL_MODE="offline"
      break
    else
      echo -e "${RED}❌ Invalid option. Please choose 1 or 2.${NC}"
    fi
  done

  while true; do
    clear
    echo
    echo -e "${CYAN}"
    echo "╭────────────────────────────────────────────────────────────╮"
    echo "│                  🚀  ICMPTunnel Installer                  "
    echo "│                                                            "
    echo "│      🔎 Api Port Server and Client (  1080  )              "
    echo "│      🔍 Listen Port Client Socks5  ( 1010 )                "
    echo "│                                                            "
    echo "│      🛰  Lightweight Tunneling over ICMP Protocol          "
    echo "│      🧠  Developed with 💙  by Q-TEAM                      "
    echo "│      📢  Telegram: @Q_teams                                "
    echo "│      📦 Version: $Version                                  "
    echo "╰────────────────────────────────────────────────────────────╯"
    echo -e "${NC}"
    echo
    echo -e "${YELLOW}💡 Select mode to install:${NC}"
    echo -e "${CYAN}1)${NC} Client"
    echo -e "${CYAN}2)${NC} Server"
    read -p "➡️  Your choice [1/2]: " mode
    if [[ "$mode" == "1" || "$mode" == "2" ]]; then
      break
    else
      echo -e "${RED}❌ Invalid option. Please choose 1 or 2.${NC}"
    fi
  done

  mkdir -p /opt/icmptunnel
  echo "$mode" > "$MODE_FILE"

  if [[ "$mode" == "1" ]]; then
    read -p "🌐 Please enter your server IP address: " SERVER_IP

    if [[ -z "$SERVER_IP" ]]; then
        echo "❌ No IP address entered. Exiting..."
        exit 1
    fi
  fi

  read -p "🔒 Would you like your data to be encrypted end-to-end ? (y/n): " encrypt_data_q

  encrypt_data_q=$(echo "$encrypt_data_q" | tr '[:upper:]' '[:lower:]')

  if [ -z "$encrypt_data_q" ] || [ "$encrypt_data_q" = "y" ] || [ "$encrypt_data_q" = "yes" ]; then
      encrypt_data=true
  else
      encrypt_data=false
  fi

  if [ "$encrypt_data" = true ]; then
    read -p "🔑 Enter your encryption key: " encrypt_data_key
    echo "Your encryption key is set."
  fi

  if [[ "$INSTALL_MODE" == "online" ]]; then
    echo -e "${CYAN}📦 Downloading latest release from GitHub...${NC}"
    OS=$(uname | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)

    if [[ "$ARCH" == "x86_64" ]]; then
      ARCH="amd64"
    elif [[ "$ARCH" == "i686" || "$ARCH" == "i386" ]]; then
      ARCH="386"
    elif [[ "$ARCH" == "aarch64" ]]; then
      ARCH="arm64"
    elif [[ "$ARCH" == "armv7l" ]]; then
      ARCH="arm"
    fi

    if [[ "$OS" == "darwin" && "$ARCH" == "x86_64" ]]; then
      ARCH="amd64"
    fi

    TARGET="ICMPTunnel-$OS-$ARCH"
    URL=$(curl -s "$GITHUB_API" | grep browser_download_url | grep "$TARGET" | cut -d '"' -f 4)


    # echo -e "${CYAN}📦 Downloading Geoip from GitHub...${NC}"
    # curl -L -# -o "$GEOIP_COUNTRY_PATH" "$GEOIP_COUNTRY_PATH_DL"
    # echo -e "${GREEN}✅ Geoip Downloaded${NC}"

    if [[ -z "$URL" ]]; then
      echo -e "${RED}❌ Failed to fetch download URL. Exiting.${NC}"
      exit 1
    fi

    TMP_BIN="/tmp/$BINARY_NAME"

    echo -e "${YELLOW}⬇️ Downloading from: $URL${NC}"
    curl -L -# -o "$TMP_BIN" "$URL"
    chmod +x "$TMP_BIN"
    mv "$TMP_BIN" "$INSTALL_PATH"
  elif [[ "$INSTALL_MODE" == "offline" ]]; then
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    LOCAL_BIN="$SCRIPT_DIR/$BINARY_NAME"
    LOCAL_GEOIP="$SCRIPT_DIR/geoip-country.mmdb"
    LOCAL_CONFIG="$SCRIPT_DIR/config.json"
    echo -e "${CYAN}🔍 Checking for local file: $LOCAL_BIN${NC}"
    if [[ -f "$LOCAL_BIN" ]]; then
      echo -e "${GREEN}✅ Local binary found. Installing...${NC}"
      chmod +x "$LOCAL_BIN"
      cp "$LOCAL_BIN" "$INSTALL_PATH"
    else
      echo -e "${RED}❌ Local binary '$BINARY_NAME' not found next to the script. Please place it there or choose online installation. Exiting.${NC}"
      exit 1
    fi
    if [[ -f "$LOCAL_GEOIP" ]]; then
      echo -e "${GREEN}✅ Local binary found. Installing...${NC}"
      chmod +x "$LOCAL_GEOIP"
      cp "$LOCAL_GEOIP" "$GEOIP_COUNTRY_PATH"
    else
      echo -e "${RED}❌ Local binary 'geoip-country.mmdb' not found next to the script. Please place it there or choose online installation. Exiting.${NC}"
      exit 1
    fi

    if [[ -f "$LOCAL_CONFIG" ]]; then
      echo -e "${GREEN}✅ Local Config/json found. Installing...${NC}"
      chmod +x "$LOCAL_CONFIG"
      cp "$LOCAL_CONFIG" "$CONFIG_PATH"
    else
      echo -e "${RED}❌ Local 'config.json' not found next to the script. Please place it there or choose online installation. Exiting.${NC}"
      exit 1
    fi

  fi

  cat <<EOF > /usr/local/bin/icmptunnel-updater.sh
#!/bin/bash
set -e
MODE_FILE="$MODE_FILE"
INSTALL_PATH="$INSTALL_PATH"
BINARY_NAME="$BINARY_NAME"
GITHUB_API="$GITHUB_API"

if [[ -f "\$MODE_FILE" ]]; then
  MODE=\$(cat "\$MODE_FILE")
else
  echo "Could not detect mode."
  exit 1
fi

SERVICE=""
[[ "\$MODE" == "1" ]] && SERVICE="$SERVICE_CLIENT"
[[ "\$MODE" == "2" ]] && SERVICE="$SERVICE_SERVER"

OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [[ "\$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "\$ARCH" == "i686" || "\$ARCH" == "i386" ]]; then
  ARCH="386"
elif [[ "\$ARCH" == "aarch64" ]]; then
  ARCH="arm64"
elif [[ "\$ARCH" == "armv7l" ]]; then
  ARCH="arm"
fi

if [[ "\$OS" == "darwin" && "\$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
fi

BINARY_NAME="ICMPTunnel-\${OS}-\${ARCH}"
TARGET="ICMPTunnel-\$OS-\$ARCH"
URL=\$(curl -s "\$GITHUB_API" | grep browser_download_url | grep "\$TARGET" | cut -d '"' -f 4)
TMP_BIN="/tmp/\$BINARY_NAME.new"
curl -# -L "\$URL" -o "\$TMP_BIN"
chmod +x "\$TMP_BIN"
if ! cmp -s "\$TMP_BIN" "\$INSTALL_PATH"; then
  echo "Updating \$BINARY_NAME..."
  mv "\$TMP_BIN" "\$INSTALL_PATH"
  systemctl restart \$SERVICE || true
else
  rm -f "\$TMP_BIN"
fi

echo -e "\n🔁 Updating install.sh..."

bash <(curl -Ls https://raw.githubusercontent.com/Qteam-official/ICMPTunnel/main/install.sh)

EOF
  chmod +x /usr/local/bin/icmptunnel-updater.sh

cat <<'EOF' > /usr/local/bin/q-icmp
if [ "$EUID" -ne 0 ]; then
  echo "🛡️ Root access required. Relaunching with sudo..."
  exec sudo bash /opt/icmptunnel/q-icmp-panel.sh
else
  bash /opt/icmptunnel/q-icmp-panel.sh
fi
EOF
  chmod +x /usr/local/bin/q-icmp

  cat <<EOF > /opt/icmptunnel/q-icmp-panel.sh
#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

MODE_FILE="$MODE_FILE"
INSTALL_PATH="$INSTALL_PATH"
if [[ -f "\$MODE_FILE" ]]; then
  MODE=\$(cat "\$MODE_FILE")
else
  echo -e "\${RED}❌ No installation mode found. Please run install.sh first.\${NC}"
  exit 1
fi

if [[ "\$MODE" == "1" ]]; then
  ACTIVE_SERVICE="$SERVICE_CLIENT"
elif [[ "\$MODE" == "2" ]]; then
  ACTIVE_SERVICE="$SERVICE_SERVER"
else
  echo -e "\${RED}❌ Invalid mode in config file.\${NC}"
  exit 1
fi
while true; do
  if systemctl is-active --quiet "\$ACTIVE_SERVICE"; then
    statusservice="RUNNING"
  else
    statusservice="STOPPED"
  fi
  clear
  echo
  echo -e "\${CYAN}"
  echo "╭──────────────────────────────────────────"
  echo -e "│        ⚙️  ICMPTunnel Control Panel  ( \${GREEN}\${ACTIVE_SERVICE}\${NC} )    "
  echo -e "│        ⚙️  Status : \${GREEN}\${statusservice}\${NC}"
  echo -e "│        📦 Version : $Version"
  echo "╰──────────────────────────────────────────"
  echo -e "\${NC}"

  echo -e "\${YELLOW}Choose an action:\${NC}"
  echo -e "  \${CYAN}1)\${NC} Start Service"
  echo -e "  \${CYAN}2)\${NC} Stop Service"
  echo -e "  \${CYAN}3)\${NC} Restart Service"
  echo -e "  \${CYAN}4)\${NC} Show Status"
  echo -e "  \${CYAN}5)\${NC} Manual Update"
  echo -e "  \${CYAN}6)\${NC} Uninstall Everything"
  echo -e "  \${CYAN}0)\${NC} Exit"
  echo
  read -p "➡️ Your choice: " choice

  case \$choice in
    1) systemctl start \$ACTIVE_SERVICE || true ;;
    2) systemctl stop \$ACTIVE_SERVICE || true ;;
    3) systemctl restart \$ACTIVE_SERVICE || true ;;
    4) echo -e "${CYAN}Showing service status...${NC}"
  systemctl status \$ACTIVE_SERVICE
  echo
  read -p "🔁 Press enter to return to menu..."
  ;;
    5) /usr/local/bin/icmptunnel-updater.sh ;;
    6)
      echo -e "\${RED}⚠️ This will remove everything related to ICMPTunnel!\${NC}"
      read -p "Are you sure? (yes/no): " confirm
      if [[ "\$confirm" == "yes" ]]; then
        systemctl stop \$ACTIVE_SERVICE || true
        systemctl disable \$ACTIVE_SERVICE || true
        systemctl stop icmptunnel-updater.timer || true
        systemctl disable icmptunnel-updater.timer || true
        rm -f /etc/systemd/system/\$ACTIVE_SERVICE
        rm -f /etc/systemd/system/icmptunnel-updater.service
        rm -f /etc/systemd/system/icmptunnel-updater.timer
        rm -f \$INSTALL_PATH
        rm -f /usr/local/bin/icmptunnel-updater.sh
        rm -f /usr/local/bin/q-icmp
        rm -rf /opt/icmptunnel
        systemctl daemon-reload
        echo -e "\${GREEN}✅ ICMPTunnel completely removed.\${NC}"
      else
        echo "❌ Cancelled."
      fi
      ;;
    0)
      echo "👋 Bye!"
      exit 0
      ;;
    *) echo -e "\${RED}❌ Invalid choice\${NC}" ;;
  esac
done
EOF
  if [[ "$mode" == "1" ]]; then
      
      PIDS=$(timeout 2s lsof -ti tcp:$PORT 2>/dev/null)

      if [ -n "$PIDS" ]; then
        kill -9 $PIDS
      else
        echo "✅ Port $PORT is not in use."
      fi

      if timeout 2s pgrep -x "$BINARY_NAME" > /dev/null; then
        pkill -9 "$BINARY_NAME"
      else
        echo "✅ No running process named '$BINARY_NAME'."
      fi


    cat <<EOF > /usr/local/bin/config.json
{
  "type": "client",
  "listen_port_socks": "1010",
  "server": "$SERVER_IP",
  "timeout": 20,
  "block_country": "",
  "dns":"8.8.8.8",
  "key": 20201204,
  "api_port" : "1080",
  "encrypt_data" : $encrypt_data,
  "encrypt_data_key" : "$encrypt_data_key"
}
EOF
    cat <<EOF > "/etc/systemd/system/$SERVICE_CLIENT"

[Unit]
Description=ICMPTunnel Client Mode
After=network.target

[Service]
ExecStart=$INSTALL_PATH -config $CONFIG_PATH
WorkingDirectory=/usr/local/bin
User=root
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target

EOF
    systemctl enable $SERVICE_CLIENT
    systemctl start $SERVICE_CLIENT
  else
    cat <<EOF > /usr/local/bin/config.json
{
  "type": "server",
  "listen_port_socks": "1010",
  "server": "",
  "timeout": 20,
  "block_country": "",
  "dns":"8.8.8.8",
  "key": 20201204,
  "api_port" : "1080",
  "encrypt_data" : $encrypt_data,
  "encrypt_data_key" : "$encrypt_data_key"
}
EOF
    cat <<EOF > "/etc/systemd/system/$SERVICE_SERVER"
[Unit]
Description=ICMPTunnel Client Mode
After=network.target

[Service]
ExecStart=$INSTALL_PATH -config $CONFIG_PATH
WorkingDirectory=/usr/local/bin
User=root
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
    systemctl enable $SERVICE_SERVER
    systemctl start $SERVICE_SERVER
  fi

  cat <<EOF > /etc/systemd/system/icmptunnel-updater.service
[Unit]
Description=ICMPTunnel Auto Updater

[Service]
Type=oneshot
ExecStart=/usr/local/bin/icmptunnel-updater.sh
EOF



  systemctl daemon-reexec
  systemctl daemon-reload
  clear
  echo -e "${GREEN}✅ Installation complete!${NC}"
  echo -e "${CYAN}🛠 You can manage with command: ${YELLOW}q-icmp${NC}"
  clear
  sudo q-icmp
}

install_icmp
