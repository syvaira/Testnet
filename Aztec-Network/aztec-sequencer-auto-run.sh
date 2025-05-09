#!/bin/bash

###############################################################################
#                                                                             #
#     ██████╗ ███████╗████████╗ ██████╗ ███████╗ ██████╗███╗   ██╗███████╗     #
#    ██╔═══██╗██╔════╝╚══██╔══╝██╔═══██╗██╔════╝██╔════╝████╗  ██║██╔════╝     #
#    ██║   ██║███████╗   ██║   ██║   ██║█████╗  ██║     ██╔██╗ ██║█████╗       #
#    ██║   ██║╚════██║   ██║   ██║   ██║██╔══╝  ██║     ██║╚██╗██║██╔══╝       #
#    ╚██████╔╝███████║   ██║   ╚██████╔╝███████╗╚██████╗██║ ╚████║███████╗     #
#     ╚═════╝ ╚══════╝   ╚═╝    ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═══╝╚══════╝     #
#                                                                             #
#                 AZTEC NETWORK SEQUENCER NODE - SETUP SCRIPT                #
#                          Maintained by Syvaira - 2025                      #
###############################################################################

set -e

# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
RESET="\033[0m"

echo -e "${CYAN}\n🔧 Step 1: Installing Dependencies...${RESET}"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install -y curl iptables build-essential git wget lz4 jq make gcc nano \
  automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev \
  tar clang bsdmainutils ncdu unzip libleveldb-dev

echo -e "${CYAN}\n🐳 Step 2: Installing Docker...${RESET}"
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
  sudo apt-get remove -y $pkg
done

sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker && sudo systemctl restart docker

echo -e "${CYAN}\n🚀 Step 3: Installing Aztec CLI Tools...${RESET}"
bash -i <(curl -s https://install.aztec.network)
echo 'export PATH="$HOME/.aztec/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo -e "${CYAN}\n🌐 Step 4: Updating Aztec Network...${RESET}"
aztec-up alpha-testnet

echo -e "${CYAN}\n🔥 Step 5: Configuring Firewall...${RESET}"
ufw allow 22 && ufw allow ssh
ufw allow 40400 && ufw allow 8080
ufw enable

echo -e "${CYAN}\n🚦 Step 6: Running Sequencer Node...${RESET}"
read -p "🔗 Enter RPC URL: " RPC_URL
read -p "🛰️  Enter BEACON URL: " BEACON_URL
read -p "🔐 Enter Ethereum Private Key: " PRIVATE_KEY
read -p "👛 Enter Ethereum Wallet Address: " WALLET_ADDRESS
read -p "🌍 Enter Server Public IP: " IP_ADDRESS

screen -dmS aztec aztec start --node --archiver --sequencer \
  --network alpha-testnet \
  --l1-rpc-urls $RPC_URL \
  --l1-consensus-host-urls $BEACON_URL \
  --sequencer.validatorPrivateKey $PRIVATE_KEY \
  --sequencer.coinbase $WALLET_ADDRESS \
  --p2p.p2pIp $IP_ADDRESS \
  --p2p.maxTxPoolSize 1000000000

echo -e "${GREEN}\n✅ Sequencer Node is now running in a screen session named 'aztec'.${RESET}\n"
