#!/bin/bash

# Présentation 
echo ""
echo "Exercice Firewall"
echo "------------------"

# Fonction 'stop'
stop()
{
    # La politique de base du firewall est de base en ACCEPT, mais il nous faut ici l'inverse, pour ça il faut donc utiliser DROP : 
    sudo iptables -P OUTPUT ACCEPT
    sudo iptables -P INPUT ACCEPT
    sudo iptables -P FORWARD ACCEPT

    # Vider les règles du Firewall
    sudo iptables --flush OUTPUT
    sudo iptables --flush INPUT
    sudo iptables --flush FORWARD 

    echo "Stop effectué"
}

# Fonction 'start'
start()
{
    # Autorisation entrées et sorties HTTP & HTTPS
	sudo iptables -P OUTPUT ACCEPT
	sudo iptables -P INPUT DROP
	sudo iptables -P FORWARD DROP
	sudo iptables -A INPUT -p tcp -i ens33 --dport 80 -j ACCEPT
	sudo iptables -A INPUT -p tcp -i ens33 --dport 443 -j ACCEPT
	sudo iptables -A INPUT -p tcp -i ens33 --dport 53 -j ACCEPT

    # Autorisation de la connexion en SSH de la machine client
    sudo iptables -A INPUT -p TCP -i ens33 --src 192.168.1.79 --dport 22 -j ACCEPT

    echo "start effectué"
}

# Fonction restart, donc on effectue la fonction 'start' à la suite de la fonction 'stop'
restart()
{
    stop
    start
    echo "restart effectué"
}

# On vérifie qu'il n'exsite bien qu'un seul argument
if [ $# -eq 1 ]
then
    # Switch pour les différents arguments
    case $1 in 
        # Si l'argument est stop
        stop)
            stop
        ;;
        # Si l'argument est start
        start)
            start
        ;;
        # Si l'argument est restart
        restart)
            restart
        ;;
        # Si l'argument n'est pas l'un des 3 du dessus
        *)
            echo "Utilisez l'un des arguments suivants [ start | stop | restart ]"
        ;;
    # Fin du switch
    esac

# Si il y a plus de 1 argument ou aucun argument
else
    echo "Utilisez l'un des arguments suivants [ start | stop | restart ]"
fi

# Fin du programme 
echo "[Maxim JOSEAU - EPSI B2 Groupe A]"
exit 1