#!/bin/bash
#Install neofetch (desktop environment)
fetch=`which neofetch | cut -d/ -f4`
if [ "$fetch" != "neofetch" ]
then
    echo "Necesitas instalar el siguiente paquete: neofetch"
    sudo apt-get install neofetch
fi
#Install netcat (for online)
netcat=`which netcat | cut-d/ -f3`
if [ "$netcat" != "netcat" ]
then
    echo "Necesitas instalar el siguiente paquete: netcat"
    sudo apt-get install netcat
fi

#align the text
function posicion()
{
    anchura=$(tput cols)
    altura=$(tput lines)
    tput cup $1 $(((anchura / 2) - (tamanyo / 2)))
}
cont=1200
clear
	tamanyo=59
    posicion 2
	echo " ██╗  ██╗ █████╗ ██╗  ██╗ ██████╗  ██████╗ ████████╗    ██╗"
    posicion 3
    echo " ██║ ██╔╝██╔══██╗██║  ██║██╔═══██╗██╔═══██╗╚══██╔══╝    ██║"
    posicion 4
    echo " █████╔╝ ███████║███████║██║   ██║██║   ██║   ██║       ██║"
    posicion 5
    echo " ██╔═██╗ ██╔══██║██╔══██║██║   ██║██║   ██║   ██║       ╚═╝"
    posicion 6
    echo " ██║  ██╗██║  ██║██║  ██║╚██████╔╝╚██████╔╝   ██║       ██╗"
    posicion 7
    echo " ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝       ╚═╝"
    tamanyo=39
	posicion 9
	echo "╔═══════════════════════════════════╗"
	posicion 10
	echo "║     Escribe el número de sala     ║"
	posicion 11
	echo "╚═══════════════════════════════════╝"
	posicion 12
	echo "╔═══════════════════════════════════╗"
	posicion 13
	echo "║ >                                 ║"
	posicion 14
	echo "╚═══════════════════════════════════╝"
	posicion 13 
	read -p "║ > " numero_sala
#comprobar terminal
for j in `seq 20`
do
    gnome-terminal --maximize --command="nc $numero_sala $cont"
    let cont=cont+1
    break
done
