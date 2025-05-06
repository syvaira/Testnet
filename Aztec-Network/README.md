# Aztec Network: Run a Sequencer Node on Testnet

A step-by-step guide to running a **Sequencer Node** on the Aztec Network Testnet and earning the **Apprentice** role.

---

## 🔧 Node Types

* **Sequencer**: Proposes blocks, validates others, and votes on upgrades.
* **Prover**: Generates ZK proofs for rollup integrity.

*Note: This guide focuses on Sequencer Node setup. Prover Nodes require \~40 high-spec machines.*

## 🎖 Roles Information

Refer to this message in Discord: [#operators | start-here](https://discord.com/channels/1144692727120937080/1367196595866828982/1367323893324582954)

## 💻 Hardware Requirements

* **Sequencer**: 8-core CPU, 16GB RAM, 100GB+ SSD
* **Prover**: \~40x 16-core CPUs, 128GB RAM machines

---

## 1. Install Dependencies

```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install curl iptables build-essential git wget lz4 jq make gcc nano \
automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev \
tar clang bsdmainutils ncdu unzip libleveldb-dev -y
```

### Docker Installation

```bash
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo docker run hello-world
sudo systemctl enable docker && sudo systemctl restart docker
```

## 2. Install Aztec Tools

```bash
bash -i <(curl -s https://install.aztec.network)
echo 'export PATH="$HOME/.aztec/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
aztec
```

## 3. Update Aztec

```bash
aztec-up alpha-testnet
```

## 4. Get RPC URLs

* **RPC URL**: Use [Alchemy](https://dashboard.alchemy.com/)
* **BEACON URL**: Use [drpc](https://drpc.org/)

*You can also run your own Geth & Prysm nodes.*

## 5. Generate Ethereum Wallet

Create or import a wallet that provides:

* Public address
* Private key

## 6. Fund Wallet

Get Sepolia ETH from a faucet or transfer.

## 7. Find Server IP

```bash
curl ipv4.icanhazip.com
```

## 8. Configure Firewall

```bash
ufw allow 22 && ufw allow ssh
ufw allow 40400 && ufw allow 8080
ufw enable
```

## 9. Run Sequencer Node

```bash
screen -S aztec

aztec start --node --archiver --sequencer \
  --network alpha-testnet \
  --l1-rpc-urls RPC_URL \
  --l1-consensus-host-urls BEACON_URL \
  --sequencer.validatorPrivateKey 0xYourPrivateKey \
  --sequencer.coinbase 0xYourAddress \
  --p2p.p2pIp IP_ADDRESS \
  --p2p.maxTxPoolSize 1000000000
```

Replace:

* `RPC_URL`, `BEACON_URL`: From Step 4
* `0xYourPrivateKey`: Your Ethereum wallet private key
* `0xYourAddress`: Your wallet public address
* `IP_ADDRESS`: Your server IP

### Screen Commands

* Detach: `Ctrl+A+D`
* Reattach: `screen -r aztec`
* Kill: `Ctrl+C` or `screen -XS aztec quit`

## 10. Wait for Node Sync

Wait a few minutes for node to fully sync.

## 11. Get the Apprentice Role

### Step 1: Get Latest Proven Block

```bash
curl -s -X POST -H 'Content-Type: application/json' \
-d '{"jsonrpc":"2.0","method":"node_getL2Tips","params":[],"id":67}' \
http://localhost:8080 | jq -r ".result.proven.number"
```

### Step 2: Generate Sync Proof

```bash
curl -s -X POST -H 'Content-Type: application/json' \
-d '{"jsonrpc":"2.0","method":"node_getArchiveSiblingPath","params":["BLOCK","BLOCK"],"id":67}' \
http://localhost:8080 | jq -r ".result"
```

### Step 3: Register via Discord

Use command: `/operator start` in Discord with:

* `address`: Validator address
* `block-number`: From Step 1
* `proof`: Base64 string from Step 2

## 12. Register Validator

```bash
aztec add-l1-validator \
  --l1-rpc-urls RPC_URL \
  --private-key YOUR_PRIVATE_KEY \
  --attester YOUR_ADDRESS \
  --proposer-eoa YOUR_ADDRESS \
  --staking-asset-handler 0xF739D03e98e23A7B65940848aBA8921fF3bAc4b2 \
  --l1-chain-id 11155111
```

## 13. Check Validator Status

View your validator in [Aztec Scan](https://aztecscan.xyz/validators)

---

## 🔃 Update Your Node

```bash
# Stop Node
screen -XS aztec quit

docker stop $(docker ps -q --filter "ancestor=aztecprotocol/aztec") && \
docker rm $(docker ps -a -q --filter "ancestor=aztecprotocol/aztec")

# Update
aztec-up alpha-testnet

# Remove old data
rm -rf ~/.aztec/alpha-testnet/data/
```

Then [re-run the node](#9-run-sequencer-node).

---

## 🛠️ Common Error: block\_stream Error

```text
ERROR: world-state:block_stream Error processing block stream: Error: Obtained L1 to L2 messages failed to be hashed to the block inHash
```

### Solution

```bash
# Stop node
Ctrl+C

# Remove data
rm -r /root/.aztec/alpha-testnet

# Restart node
# (Return to Step 9)
```
