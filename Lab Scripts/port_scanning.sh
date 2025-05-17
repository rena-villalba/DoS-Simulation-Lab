#!/bin/bash

TARGET="$1"

if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 <target-ip>"
  exit 1
fi

echo "[*] Starting port scan simulation on $TARGET ..."
sleep 2

echo "[*] Running SYN scan ..."
nmap -sS "$TARGET" -Pn
sleep 5

echo "[*] Running FIN scan ..."
nmap -sF "$TARGET" -Pn
sleep 5

echo "[*] Running NULL scan ..."
nmap -sN "$TARGET" -Pn
sleep 5

echo "[*] Running XMAS scan ..."
nmap -sX "$TARGET" -Pn
sleep 5

echo "[*] Running UDP scan (1-100)..."
nmap -sU -p 1-100 "$TARGET" -Pn
sleep 5

echo "[*] All scans completed."