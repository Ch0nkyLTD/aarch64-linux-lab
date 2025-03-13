#!/bin/bash
# Exit on error, treat unset variables as errors, and catch errors in pipelines.
set -euo pipefail

# Log file location; adjust if desired.
LOGFILE="/tmp/setup.log"
# Redirect stdout and stderr to the log file, while also printing to terminal.
exec > >(tee -a "$LOGFILE") 2>&1

# Function for logging with timestamp
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting setup script."

# Update package lists
log "Running: sudo apt-get update"
sudo apt-get update

# Install required packages
log "Installing packages..."
sudo apt-get install -y \
  qemu-kvm qemu-utils virt-manager libvirt-daemon-system cpu-checker \
  magic-wormhole libguestfs-tools git curl zsh python3 python3-venv \
  python3-pip pipx sshfs build-essential tmux make vim

# Install ansible via pipx and ensure pipx's bin directory is in PATH
log "Installing ansible via pipx..."
pipx install --include-deps ansible

log "Ensuring pipx path is set..."
pipx ensurepath --force

# Generate SSH key if it doesn't exist, and log the public key
if [ ! -f ~/.ssh/id_ed25519 ]; then
  log "Generating new SSH key..."
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
  NEW_PUB=$(cat ~/.ssh/id_ed25519.pub)
  log "New SSH public key: $NEW_PUB"
else
  log "SSH key already exists."
  NEW_PUB=$(cat ~/.ssh/id_ed25519.pub)
fi

# Run setup.sh from the cloned repository
log "Running setup.sh in aarch64-linux-lab directory..."
cd lab

echo "Using $NEW_PUB"
bash change_key.sh ./gateway "$NEW_PUB"
bash change_key.sh ./jail "$NEW_PUB"

sudo bash setup.sh

log "Running network setup script (net.sh)..."
sudo bash net.sh

# Start a tmux session, split the pane, and send commands to each pane.
log "Starting tmux session 'my_session' with jail_iso.sh and gateway_iso.sh..."
tmux new-session -d -s my_session \; \
  split-window -h \; \
  send-keys -t my_session:0.0 "sudo bash jail_iso.sh" C-m \; \
  send-keys -t my_session:0.1 "sudo bash gateway_iso.sh" C-m \;

#tmux attach-session -t my_session

log "Setup complete."
bash poll.sh
ansible-playbook playbook.yml -i inventory.ini
echo "all set! run tmux a -t my_session to view status of vm setup. once you see the login screen its ready s  a"
