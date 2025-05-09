# Aztec Network: Auto Run Sequencer Node Setup

This guide provides a streamlined process to automatically set up and run a **Sequencer Node** on the Aztec Network Testnet using the auto-run script.

---

## 🚀 Quick Start

1. **Download and Run the Script Directly**

```bash
curl -O https://raw.githubusercontent.com/syvaira/Testnet/refs/heads/main/Aztec-Network/aztec-sequencer-auto-run.sh
chmod +x aztec-sequencer-auto-run.sh
./aztec-sequencer-auto-run.sh
```

The script will automatically:

* Install all necessary dependencies (Docker, Aztec CLI).
* Configure the firewall.
* Prompt for your RPC URL, BEACON URL, Ethereum Private Key, Wallet Address, and Server IP.
* Launch the Sequencer Node in a `screen` session.

---

## 📌 Prerequisites

* A server with **Ubuntu 20.04+** (recommended).
* Sufficient hardware specifications:

  * **Sequencer Node:** 8-core CPU, 16GB RAM, 100GB+ SSD
* An Ethereum wallet with Sepolia testnet ETH.
* RPC URL and BEACON URL (e.g., from [Alchemy](https://dashboard.alchemy.com/) and [drpc](https://drpc.org/)).

---

## ⚙️ How It Works

The script is designed for simplicity and automation:

* Installs all required dependencies.
* Configures Docker and Aztec CLI.
* Secures the system with basic firewall rules.
* Automatically launches the Sequencer Node in a detached `screen` session.

You can reattach to the session using:

```bash
screen -r aztec
```

To stop the node, use:

```bash
screen -XS aztec quit
```

---

## 🌐 Updating Your Node

To update your Sequencer Node:

```bash
aztec-up alpha-testnet
```

---

## 📞 Support

For any issues or questions, please open an issue on this GitHub repository or reach out via the [Aztec Network Discord](https://discord.com/invite/aztecnetwork).
