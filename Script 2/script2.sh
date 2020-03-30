#!/bin/bash

# Présentation 
echo ""
echo "Exercice Firewall deuxième script"
echo "---------------------------------"

firewall()
{
    # Remplace le nom des cartes réseaux par des variables avec des noms plus explicite
    WAN = eth0
    DMZ = eth1
    LAN = eth2

    # On drop toutes les règles
    iptables -P OUTPUT DROP
    iptables -P FORWARD DROP
    iptables -P INPUT DROP

    # Autorisation des trames FORWARD sur le routeur en provenance du LAN, le LAN peut donc accéder au WAN et la DMZ
    iptables -A FORWARD -s 10.1.2.0/24 -i $LAN -d 92.3.4.0/24 -o $WAN -j ACCEPT
    iptables -A FORWARD -s 10.1.2.0/24 -i $LAN -d 172.16.0.0/24 -o $DMZ -j ACCEPT

    # Le WAN peut accéder au DMZ sur les ports demandés : 80, 443 et 25 
    iptables -A FORWARD -s 92.3.4.0/24 -i $WAN -d 172.16.0.0/24 -o $DMZ -p tcp --dport 80 -j ACCEPT
    iptables -A FORWARD -s 92.3.4.0/24 -i $WAN -d 172.16.0.0/24 -o $DMZ -p tcp --dport 443 -j ACCEPT
    iptables -A FORWARD -s 92.3.4.0/24 -i $WAN -d 172.16.0.0/24 -o $DMZ -p tcp --dport 25 -j ACCEPT

    # Pour la troisième question nous avons déjà DROP pour les trames FORWARD
    echo "Démarrage du Firewall"
}

# On vérifie qu'il n'exsite bien qu'un seul argument
if [ $# -eq 1 ]
then
    # Switch pour les différents arguments
    case $1 in 
        # Si l'argument est firewall
        firewall)
            firewall
        ;;
        # L'argument n'est pas firewall
        *)
            echo "Utiliser l'argument [ firewall ] pour faire fonctionner ce script"
        ;;
    # Fin du switch
    esac
#Si il y a plus de 1 argument, ou aucun argument
else
    echo "Utiliser l'argument [ firewall ] pour faire fonctionner ce script"
fi

# Fin du programme 
echo "[Maxim JOSEAU - EPSI B2 Groupe A]"
exit 1