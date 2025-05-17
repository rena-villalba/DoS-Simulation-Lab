#!/bin/bash

#Flush existing rules
iptables -F
iptables -X

#Set default policies
iptables -P INPUT ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#Allow loopback traffic
iptables -A INPUT -i lo -j ACCEPT

#Allow any ICMP traffic for ping and ping flood detection
iptables -A INPUT -p icmp -j ACCEPT

#Allow TCP and UDP traffic for scanning detection
iptables -A INPUT -p tcp -j ACCEPT
iptables -A INPUT -p udp -j ACCEPT

#Allow established/related connetions
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT