#!/usr/bin/env bash

# Interface and gateway definitions
IFACE="enp2s0"
GW="10.10.10.10"
NET_ISO="10.10.10.0/24"

usage() {
  echo "Usage: $0 [isolate|undo]"
  echo "  isolate : Remove current default route(s) and set default via $GW on $IFACE."
  echo "  undo    : Remove default route via $GW, then set ONLY a route to $NET_ISO via $GW."
  exit 1
}

# Make sure we have a valid argument
[[ $# -ne 1 ]] && usage

case "$1" in
  isolate)
    echo "[+] Isolating traffic through $GW on $IFACE ..."
    # 1. Remove existing default routes
    echo "[+] Removing existing default routes..."
    sudo ip route del default || echo "[!] No default route to remove or command failed."

    # 2. Add new default route
    echo "[+] Adding default route via $GW on $IFACE ..."
    sudo ip route add default via "$GW" dev "$IFACE"
    sudo resolvectl flush-caches
    ;;

  undo)
    echo "[+] Undoing isolation: removing default route through $GW and setting route ONLY for $NET_ISO ..."
    # 1. Remove the default route via $GW
    echo "[+] Removing default route via $GW ..."
    sudo ip route del default via "$GW" dev "$IFACE" 2>/dev/null || echo "[!] Default route via $GW not found or remove failed."

    # 2. Add route ONLY for $NET_ISO
    echo "[+] Adding route for $NET_ISO via $GW ..."
    sudo ip route add "$NET_ISO" via "$GW" dev "$IFACE"
    sudo resolvectl flush-caches
    ;;

  *)
    usage
    ;;
esac

echo "[+] Done."
