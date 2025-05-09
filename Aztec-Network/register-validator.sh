#!/bin/bash

# Request user input
echo "Enter L1 RPC URL:"
read L1_RPC_URLS

echo "Enter private key (0x<hex value>):"
read PRIVATE_KEY

echo "Enter attester address (0x<eth address>):"
read ATTESTER

echo "Enter proposer EOA address (0x<eth address>):"
read PROPOSER_EOA

# Define ETHEREUM_HOSTS
ETHEREUM_HOSTS=$L1_RPC_URLS

# Create the command with user input
command="aztec add-l1-validator --staking-asset-handler=0xF739D03e98e23A7B65940848aBA8921fF3bAc4b2 \
  --l1-rpc-urls $ETHEREUM_HOSTS \
  --l1-chain-id 11155111 \
  --private-key \"$PRIVATE_KEY\" \
  --attester \"$ATTESTER\" \
  --proposer-eoa \"$PROPOSER_EOA\""

# Display the command that will be executed
echo "The command that will be executed:"
echo $command

# Run the command
$command
