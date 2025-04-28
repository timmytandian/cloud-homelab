#!/bin/bash

# output log
exec > >(tee /var/log/user-data.log) 2>&1  # Log to file
echo "User data started at $(date)"

# some variables to perform exponential backoff in case the curl command
# have time out because the NAT gateway is not ready yet
MAX_ATTEMPTS=10
ATTEMPT=0
SUCCESS=false

# Test connection with exponential backoff
while [ $ATTEMPT -lt $MAX_ATTEMPTS ] && [ "$SUCCESS" = false ]; do
  ATTEMPT=$((ATTEMPT+1))
  echo "Attempt $ATTEMPT to connect to internet..."
  
  if curl --max-time 30 -s https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg > /dev/null; then
    echo "Connection successful!"
    SUCCESS=true
  else
    echo "Connection failed. Waiting before retry..."
    SLEEP_TIME=$((2**ATTEMPT))
    sleep $SLEEP_TIME
  fi
done

# Install Tailscale if the connection is good
if [ "$SUCCESS" = true ]; then
  # Add Tailscale's package signing key and repository
  curl -fsSL --connect-timeout 300 -v https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
  curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

  # Install Tailscale
  sudo apt-get update && sudo apt-get install -y tailscale

  # Connect your machine to your Tailscale network using pre-auth-key
  AUTH_KEY=$(aws ssm get-parameter --name "/ec2/tailscale-auth-key" --with-decryption --query Parameter.Value --output text)
  sudo tailscale up --auth-key=$AUTH_KEY
else
  echo "Failed to establish connection after $MAX_ATTEMPTS attempts"
  exit 1
fi
