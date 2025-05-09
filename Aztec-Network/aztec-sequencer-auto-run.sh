#!/bin/bash

# ========================== CONFIGURATIONS ===========================
BLUE_LOGO='\e[38;5;67m'    # Biru keunguan
ORANGE_LOGO='\e[38;5;208m' # Oranye cerah
RESET='\e[0m'

# =========================== ASCII HEADER ============================
clear
cat << "EOF"
${BLUE_LOGO}███████╗██╗   ██╗██╗   ██╗ █████╗ ██╗██████╗  █████╗
██╔════╝╚██╗ ██╔╝██║   ██║██╔══██╗██║██╔══██╗██╔══██╗
███████╗ ╚████╔╝ ██║   ██║███████║██║██████╔╝███████║
╚════██║  ╚██╔╝  ╚██╗ ██╔╝██╔══██║██║██╔══██╗██╔══██║
███████║   ██║    ╚████╔╝ ██║  ██║██║██║  ██║██║  ██║
╚══════╝   ╚═╝     ╚═══╝  ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝${RESET}
EOF

# =========================== INFO BOX ================================
echo -e "${ORANGE_LOGO}#####################################################"
echo -e "#${BLUE_LOGO}            AZTEC NETWORK SEQUENCER NODE           ${ORANGE_LOGO}#"
echo -e "#${BLUE_LOGO}               Auto Run Setup Script               ${ORANGE_LOGO}#"
echo -e "#${BLUE_LOGO}            Maintained by Syvaira (2025)           ${ORANGE_LOGO}#"
echo -e "#####################################################${RESET}\n"

set -e

# ========================== FUNCTION DEFINITIONS ====================
show_step() { clear; echo -e "\n${BLUE_LOGO}🔧 $1...${RESET}"; }

install_dependencies() {
  show_step "Installing Dependencies"
  sudo apt-get update -qq && sudo apt-get upgrade -y -qq
  sudo apt install -y -qq curl iptables build-essential git wget lz4 jq make gcc nano \
    automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev \
    tar clang bsdmainutils ncdu unzip libleveldb-dev
}

install_docker() {
  show_step "Installing Docker"
  sudo apt-get remove -y -qq docker.io docker-doc docker-compose podman-docker containerd runc
  sudo apt-get install -y -qq ca-certificates curl gnupg
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo apt-get update -qq && sudo apt install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin
  sudo systemctl enable docker --quiet && sudo systemctl restart docker
}

install_aztec_tools() {
  show_step "Installing Aztec CLI Tools"
  bash -i <(curl -s https://install.aztec.network) > /dev/null 2>&1
  echo 'export PATH="$HOME/.aztec/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
}

configure_firewall() {
  show_step "Configuring Firewall"
  ufw allow 22 && ufw allow ssh
  ufw allow 40400 && ufw allow 8080
  ufw --force enable > /dev/null
}

run_sequencer_node() {
  show_step "Running Sequencer Node"
  read -p "Enter RPC URL: " RPC_URL
  read -p "Enter BEACON URL: " BEACON_URL
  read -p "Enter Ethereum Private Key: " PRIVATE_KEY
  read -p "Enter Ethereum Address: " WALLET_ADDRESS
  read -p "Enter Server IP: " IP_ADDRESS

  screen -dmS aztec aztec start --node --archiver --sequencer \
    --network alpha-testnet \
    --l1-rpc-urls "$RPC_URL" \
    --l1-consensus-host-urls "$BEACON_URL" \
    --sequencer.validatorPrivateKey "$PRIVATE_KEY" \
    --sequencer.coinbase "$WALLET_ADDRESS" \
    --p2p.p2pIp "$IP_ADDRESS" \
    --p2p.maxTxPoolSize 1000000000

  echo -e "\n✅ Sequencer Node is running in a screen session named 'aztec'.\n"
}

# =========================== MAIN SCRIPT ============================
install_dependencies
install_docker
install_aztec_tools
configure_firewall
run_sequencer_node
