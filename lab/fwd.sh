#!/bin/bash

# Interface and IP Configuration
IN_IFACE="enp2s0" # Incoming interface
OUT_IFACE="enp1s0" # Outgoing interface
SUBNET="10.10.10.0/24"

# Enable IP forwarding
enable_ip_forwarding() {
    echo 1 > /proc/sys/net/ipv4/ip_forward
}

# Disable IP forwarding
disable_ip_forwarding() {
    echo 0 > /proc/sys/net/ipv4/ip_forward
}

# Set up forwarding and NAT rules
forward_up() {
    echo "Setting up IP forwarding and NAT..."
    enable_ip_forwarding
    # Forward traffic from $IN_IFACE to $OUT_IFACE
    iptables -A FORWARD -i "$IN_IFACE" -o "$OUT_IFACE" -s "$SUBNET" -j ACCEPT
    iptables -A FORWARD -i "$OUT_IFACE" -o "$IN_IFACE" -m state --state ESTABLISHED,RELATED -j ACCEPT
    # NAT traffic leaving $OUT_IFACE
    iptables -t nat -A POSTROUTING -o "$OUT_IFACE" -s "$SUBNET" -j MASQUERADE
    echo "Forwarding and NAT rules set."
}

# Tear down forwarding and NAT rules
forward_down() {
    echo "Tearing down IP forwarding and NAT..."
    # Remove forwarding rules
    iptables -D FORWARD -i "$IN_IFACE" -o "$OUT_IFACE" -s "$SUBNET" -j ACCEPT
    iptables -D FORWARD -i "$OUT_IFACE" -o "$IN_IFACE" -m state --state ESTABLISHED,RELATED -j ACCEPT
    # Remove NAT rules
    iptables -t nat -D POSTROUTING -o "$OUT_IFACE" -s "$SUBNET" -j MASQUERADE
    disable_ip_forwarding
    echo "Forwarding and NAT rules removed."
}

# Help function
usage() {
    echo "Usage: $0 {up|down}"
    echo "  up   - Set up IP forwarding and NAT"
    echo "  down - Remove IP forwarding and NAT"
}

# Main script logic
case "$1" in
    up)
        forward_up
        ;;
    down)
        forward_down
        ;;
    *)
        usage
        ;;
esac

