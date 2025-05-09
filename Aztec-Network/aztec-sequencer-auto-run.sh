#!/bin/bash


# Gunakan ANSI 256 color codes
BLUE_LOGO='\e[38;5;67m'    # Biru keunguan (mendekati #4F88C6)
ORANGE_LOGO='\e[38;5;208m' # Oranye (mendekati #F57C2C)
RESET='\e[0m'

# Header ASCII Art - Biru logo
echo -e "${BLUE_LOGO}███████╗██╗   ██╗██╗   ██╗ █████╗ ██╗██████╗  █████╗"
echo -e "██╔════╝╚██╗ ██╔╝██║   ██║██╔══██╗██║██╔══██╗██╔══██╗"
echo -e "███████╗ ╚████╔╝ ██║   ██║███████║██║██████╔╝███████║"
echo -e "╚════██║  ╚██╔╝  ╚██╗ ██╔╝██╔══██║██║██╔══██╗██╔══██║"
echo -e "███████║   ██║    ╚████╔╝ ██║  ██║██║██║  ██║██║  ██║"
echo -e "╚══════╝   ╚═╝     ╚═══╝  ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝${RESET}"

# Box info - Oranye dan biru logo
echo -e "${ORANGE_LOGO}#####################################################"
echo -e "#${BLUE_LOGO}            AZTEC NETWORK SEQUENCER NODE           ${ORANGE_LOGO}#"
echo -e "#${BLUE_LOGO}               Auto Run Setup Script               ${ORANGE_LOGO}#"
echo -e "#${BLUE_LOGO}            Maintained by Syvaira (2025)           ${ORANGE_LOGO}#"
echo -e "#####################################################${RESET}"



set -e

# 1. Update and Install Dependencies
echo -e "\n🔧 Installing Dependencies..."
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install -y curl iptables build-essential git wget lz4 jq make gcc nano \
  automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev \
  tar clang bsdmainutils ncdu unzip libleveldb-dev

# 2. Install Docker
echo -e "\n🐳 Installing Docker..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove -y $pkg; done
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker && sudo systemctl restart docker

# 3. Install Aztec Tools
echo -e "\n🚀 Installing Aztec CLI Tools..."
bash -i <(curl -s https://install.aztec.network)
echo 'export PATH="$HOME/.aztec/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 4. Update Aztec
echo -e "\n🌐 Updating Aztec Network..."
aztec-up alpha-testnet

# 5. Configure Firewall
echo -e "\n🔥 Configuring Firewall..."
ufw allow 22 && ufw allow ssh
ufw allow 40400 && ufw allow 8080
ufw enable

# 6. Run Sequencer Node
echo -e "\n🚦 Running Sequencer Node..."
read -p "Enter RPC URL: " RPC_URL
read -p "Enter BEACON URL: " BEACON_URL
read -p "Enter Ethereum Private Key: " PRIVATE_KEY
read -p "Enter Ethereum Address: " WALLET_ADDRESS
read -p "Enter Server IP: " IP_ADDRESS

screen -dmS aztec aztec start --node --archiver --sequencer \
  --network alpha-testnet \
  --l1-rpc-urls $RPC_URL \
  --l1-consensus-host-urls $BEACON_URL \
  --sequencer.validatorPrivateKey $PRIVATE_KEY \
  --sequencer.coinbase $WALLET_ADDRESS \
  --p2p.p2pIp $IP_ADDRESS \
  --p2p.maxTxPoolSize 1000000000

echo -e "\n✅ Sequencer Node is running in a screen session named 'aztec'.\n"
