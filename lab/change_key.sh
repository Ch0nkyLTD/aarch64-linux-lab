#!/bin/bash

# Usage: replace_ssh_key.sh <directory> <new_public_key_string>

if [ $# -ne 2 ]; then
  echo "Usage: $0 <directory> <new_public_key_string>"
  echo "Example: $0 /path/to/directory 'ssh-ed25519 AAAAB3NzaC1lZDI1NTE5AAAAIBlahBlahBlah user@newkey'"
  exit 1
fi

directory="$1"
new_key="$2"
# key used in the default conf
old_key="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhDN7Dt0kAEvk1aPJmBF2s77JEK906XjaBlEmbrgwgm user@spr-2025"

if [ ! -d "$directory" ]; then
  echo "Error: Directory '$directory' not found."
  exit 1
fi

find "$directory" -type f -exec sed -i "s|$(echo "$old_key" | sed 's/[\/&]/\\&/g')|$(echo "$new_key" | sed 's/[\/&]/\\&/g')|g" {} +

if [ $? -eq 0 ]; then
  echo "Successfully replaced key in files within $directory"
else
  echo "An error occured during the replacement process"
  exit 1
fi
