#!/bin/bash

# permet au script bash de s arreter des qu une commande echoue
set -e

SERVER_IP="192.168.56.110"
AGENT_IP="192.168.56.111"

# recup carte reseau que doit utiliser la amchine du server 
IFACE=$(ip -o -4 addr show | awk -v ip="${AGENT_IP}/" 'index($4, ip)==1 {print $2}')

# Attendre que le serveur reponde
while ! curl -sk https://${SERVER_IP}:6443 > /dev/null 2>&1; do
  echo "Waiting for server..."
  sleep 5
done

# installer K3s en mode agent
curl -sfL https://get.k3s.io | K3S_URL=https://${SERVER_IP}:6443 K3S_TOKEN=mysecrettoken123 INSTALL_K3S_EXEC="agent --node-ip ${AGENT_IP} --flannel-iface ${IFACE}" sh -

echo "Agent ready!"