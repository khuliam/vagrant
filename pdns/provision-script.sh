#!/bin/bash

hostname="pdns.dev.local.ca"

echo "Mise à jours du système..."
sudo apt-get update

echo "Installer net-tools..."
sudo apt-get install net-tools -y

echo "Définir le hostname..."
sudo hostnamectl set-hostname $hostname

echo "Récupérer l'adresse IP..."
ip_address=$(ifconfig eth1 | awk '/inet / {print $2}')
short_name=$(hostname -s)

echo "Mettre à jours le fichier hosts..."
echo "127.0.0.1     localhost" | sudo tee /tmp/hosts
echo "127.0.0.2     bullseye" | sudo tee -a /tmp/hosts
echo "$ip_address $hostname $short_name" | sudo tee -a /tmp/hosts

echo "Créer un fichier temporaire avec les nouvelles configurations DNS..."
echo "nameserver 192.168.8.103" | sudo tee /tmp/resolv.conf
echo "nameserver 192.168.8.1" | sudo tee -a /tmp/resolv.conf

echo "Remplacer le fichier /etc/resolv.conf par le fichier temporaire..."
sudo mv /tmp/resolv.conf /etc/resolv.conf
echo "Afficher l'adresse ip de l'interface..."
echo "Adresse IP de eth1 : $ip_address"

