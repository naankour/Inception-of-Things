#!/bin/bash

# permet au script bash de s arreter des qu une commande echoue
set -e

SERVER_IP="192.168.56.110"

# recup carte reseau que doit utiliser la amchine du server 
IFACE=$(ip -o -4 addr show | awk -v ip="${SERVER_IP}/" 'index($4, ip)==1 {print $2}')

# installer K3s en mode server 

curl -sfL https://get.k3s.io | K3S_TOKEN=mysecrettoken123 INSTALL_K3S_EXEC="server --node-ip ${SERVER_IP} --flannel-iface ${IFACE} --write-kubeconfig-mode 644" sh -s -
echo "Waiting for K3s..."
until kubectl get nodes 2>/dev/null | grep -qw "Ready" ; do
	sleep 5
done

echo "Server ready!"


