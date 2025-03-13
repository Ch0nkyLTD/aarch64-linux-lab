#!/bin/bash
server1="10.10.10.10"
server2="10.10.10.11"
user="user"

server1_up=false
server2_up=false

# Loop until both servers are reachable
while ! $server1_up || ! $server2_up; do
  if ! $server1_up; then
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -o BatchMode=yes "$user@$server1" "exit" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "Connected to $server1"
      server1_up=true
    fi
  fi

  if ! $server2_up; then
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -o BatchMode=yes "$user@$server2" "exit" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "Connected to $server2"
      server2_up=true
    fi
  fi

  if ! $server1_up || ! $server2_up; then
    sleep 5
  fi
done

echo "done"
