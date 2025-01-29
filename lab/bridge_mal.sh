#!/usr/bin/env bash

# nat-masquerade.sh
# A simple script to enable/disable NAT masquerading from enp2s0 to enp1s0.

# Usage:
#   ./nat-masquerade.sh start  -> Enable masquerading
#   ./nat-masquerade.sh stop   -> Disable masquerading

IF_IN="enp2s0"   # Incoming interface (where traffic is coming FROM)
IF_OUT="enp1s0"  # Outgoing interface (where traffic is going TO)

case "$1" in
  start)
    echo "Enabling IP forwarding and setting up NAT..."

    # 1. Enable IP forwarding
    # Temporary setting (will revert on reboot). For a permanent setting,
    # edit /etc/sysctl.conf or a file in /etc/sysctl.d/
    sysctl -w net.ipv4.ip_forward=1

    # 2. Flush existing iptables rules (nat and filter tables)
    iptables -F
    iptables -t nat -F

    # 3. Set up POSTROUTING masquerade rule
    iptables -t nat -A POSTROUTING -o "$IF_OUT" -j MASQUERADE

    # 4. Allow forwarding from IF_IN to IF_OUT
    iptables -A FORWARD -i "$IF_IN" -o "$IF_OUT" -j ACCEPT

    # 5. Allow return traffic (Established/Related)
    iptables -A FORWARD -i "$IF_OUT" -o "$IF_IN" -m state --state RELATED,ESTABLISHED -j ACCEPT

    echo "NAT masquerading enabled from $IF_IN to $IF_OUT."
    ;;

  stop)
    echo "Disabling NAT and IP forwarding..."

    # 1. Flush the iptables rules (nat and filter)
    iptables -F
    iptables -t nat -F

    # 2. Disable IP forwarding (again, temporary; doesn't persist across reboots)
    sysctl -w net.ipv4.ip_forward=0

    echo "NAT masquerading disabled."
    ;;

  *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac

