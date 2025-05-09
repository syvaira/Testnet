#!/bin/bash

# Function to print messages in bold and color
print_message() {
  echo -e "\033[1;36m$1\033[0m"
}

# Request user input with enhanced appearance
print_message "===================================================="
print_message "Please enter the following details to run the command:"
print_message "===================================================="
echo ""

# User input prompts with formatting
print_message "Enter L1 RPC URL:"
read L1_RPC_URLS

print_message "Enter Private Key (0x<hex value>):"
read PRIVATE_KEY

print_message "Enter Attester Address (0x<eth address>):"
read ATTESTER

print_message "Enter Proposer EOA Address (0x<eth address>):"
read PROPOSER_EOA

echo ""

# Define ETHEREUM_HOSTS
ETHEREUM_HOSTS=$L1_RPC_URLS

# Create the command with user input
command="aztec add-l1-validator --staking-asset-handler=0xF739D03e98e23A7B65940848aBA8921fF3bAc4b2 \
  --l1-rpc-urls $ETHEREUM_HOSTS \
  --l1-chain-id 11155111 \
  --private-key $PRIVATE_KEY \
  --attester $ATTESTER \
  --proposer-eoa $PROPOSER_EOA\ "

# Display the constructed command
print_message "===================================================="
print_message "The command that will be executed:"
print_message "===================================================="
echo -e "\033[1;33m$command\033[0m"
echo ""

# Confirmation before executing the command
print_message "Are you sure you want to execute this command? (y/n):"
read confirmation

if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
  # Run the command
  print_message "Executing the command..."
  echo ""
  $command
else
  print_message "Operation cancelled."
fi
