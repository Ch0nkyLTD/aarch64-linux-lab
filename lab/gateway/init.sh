#!/bin/bash
# /init.sh for gateway container

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Set up NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

# Start INetSim (if needed)
#service inetsim start

# Keep container running
exec "$@"
