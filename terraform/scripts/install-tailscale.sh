#!/bin/bash

# Add Tailscale's package signing key and repository
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# Install Tailscale
sudo apt-get update && sudo apt-get install -y tailscale

# Connect your machine to your Tailscale network using pre-auth-key
sudo tailscale up --auth-key=tskey-auth-kuZrN7rHXr11CNTRL-jNs8FXSroDQbsSxM9ShXDQJ4fuJ5XrgL