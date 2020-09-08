#!/bin/bash
function posicion()
{
    anchura=$(tput cols)
    altura=$(tput lines)
    tput cup $1 $(((anchura / 2) - (tamanyo / 2)))
}

function portada()
{
    lineas=`cat titulos/$1.txt | wc -l`
    for x in `seq $lineas`
    do
        posicion $x
        cat titulos/$1.txt | head -$x | tail -1
    done
}

function menu_jugmaster {
	source openterminal.sh
	clear
	tamanyo=32
	portada titulotemas
	posicion 8
	echo "╔═════════════════════════════════╗"
	posicion 9
	echo "║         Elige el tema           ║"
	posicion 10
	echo "╚═════════════════════════════════╝"
	max4=`ls temas/ | wc -l`
	posici=11
		for x in `seq $max4`
		do
			posicion $posici
			echo "$x- `ls -l temas/ | tail -n +2 | tr -s " " | head -$x | tail -1 | cut -d" " -f9 | cut -d"." -f1`"
			let posici=posici+1
		done
	let posici=posici+1
	posicion $posici
	read -p "Nº" temaelegido
	temaelegido1=`ls temas/ | tail -n +1 | tr -s " " | head -$temaelegido | tail -1 | cut -d" " -f9`
	temaelegido2=`ls temas/ | tail -n +1 | tr -s " " | head -$temaelegido | tail -1 | cut -d" " -f9 | cut -d"." -f1`
	sleep 0.5
	clear
	sala
}

function sala {

clear
	tamanyo=32
	portada titulotemas
	posicion 8
	echo "╔═══════════════════════════════════╗"
	posicion 9
	echo "║   Escribe el nombre de la sala    ║"
	posicion 10
	echo "╚═══════════════════════════════════╝"
	posicion 11
	echo "╔═══════════════════════════════════╗"
	posicion 12
	echo "║ >                                 ║"
	posicion 13
	echo "╚═══════════════════════════════════╝"
	posicion 12 
	read -p "║ > Sala " nombre_sala
	nombre_sala2=`echo "$nombre_sala" | tr -d " "`
	sleep 1
	touch salas/sala$nombre_sala2.txt
	echo "sala$nombre_sala2" >> salas/historial.txt
	touch salas/resultados_sala$nombre_sala2.txt
	nombre_sala3="sala$nombre_sala2.txt"
	jugar
}

function jugar {
clear
		sstart=4
		echo "jugadores" >> salas/$nombre_sala3
	while [ $sstart -ne 1 ]
	do
		tamanyo=59
		portada kahoottitulo
		jugadoreslistos=`cat salas/$nombre_sala3 | wc -l`
		let jugadoreslistos=jugadoreslistos-1
		posicion 9
		echo "╔═══════════════════════════════════╗"
		posicion 10
		echo "║    Esperando a los jugadores...   ║  Nº Sala: `hostname -I`"
		posicion 11
		echo "╚═══════════════════════════════════╝"
		posicion 12
		echo "Se han unido `tput setaf 5`$jugadoreslistos`tput sgr 0`"
		posicion 13
		echo "Pulse 1 para empezar... "
		posicion 14
		echo "Pulse 2 para refrescar..."
		read -n1 sstart
	done
		echo "jugar" >> salas/$nombre_sala3
		totalj=`cat salas/$nombre_sala3 | wc -l`
		totaljug=`let totalj=totalj-2`
		x=1
		restjug=`cat salas/$nombre_sala3 | wc -l`
		jugtotals=`cat salas/$nombre_sala3 | wc -l`
		let jugtotals=jugtotals-2
		
		jugar1
}

function jugar1 {
game=4
maxp=`cat temas/$temaelegido1 | wc -l`
while [ $game -ne 1 ]
do
	totalnow=`cat salas/$nombre_sala3 | wc -l`
	totalver=0
	let totalver=totalnow-restjug
	clear
	tamanyo=32
	posicion 8
	echo "╔══════════════════════════════╗"
	posicion 9
	echo "║          Pregunta  $x         ║ - Jugadores: `tput setaf 5`$totalver`tput sgr 0` / `tput setaf 5`$jugtotals`tput sgr 0`"
	posicion 10
	echo "╚══════════════════════════════╝"
	posicion 11
	echo ""
	posicion 12
	echo "`cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f1`"
	posicion 13
	echo " 1- `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f2`"
	posicion 14
	echo " 2- `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f3`"
	posicion 15
	echo " 3- `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f4`"
	posicion 16
	echo " 4- `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f5`"
	posicion 17
	echo ""
	posicion 18
	echo "Esperando a los jugadores...  Pulse 2 para refrescar"
	posicion 19
	echo "Pulse 1 para avanzar a la siguiente pregunta."
	read -n1 game
	if [ "`cat salas/$nombre_sala3 | grep ^jugar | wc -l`" = "`cat temas/$temaelegido1 | wc -l`" ] && [ $totalver = $jugtotals ]
		then
		echo "finish" >>salas/$nombre_sala3
		resultados
		break
	fi
	if [ $game -eq 1 ]
	then
		
		let x=x+1
		echo "jugar" >>salas/$nombre_sala3
		restjug=`cat salas/$nombre_sala3 | wc -l`
		jugar1
	fi
done
}

function resultados {
	clear
	tamanyo=51
	portada tituloresultados
	posicion 8
	echo "Cargando los resultados..."
	sleep 2
	echo "`cat salas/resultados_sala$nombre_sala2.txt | sort -t: -nrk2`" >salas/resultados_sala$nombre_sala2.txt
	clear
	maxim=`cat salas/resultados_sala$nombre_sala2.txt | wc -l`
	tamanyo=51
	portada tituloresultados
	posicion 8
	echo "Posición | Nombre | Correctas | Incorrectas"
	pos=9
	for x in `seq $maxim`
	do
		posicion $pos
		echo "   $x-      `cat salas/resultados_sala$nombre_sala2.txt | head -$x | tail -1 | cut -d: -f1`         `cat salas/resultados_sala$nombre_sala2.txt | head -$x | tail -1 | cut -d: -f2`         `cat salas/resultados_sala$nombre_sala2.txt | head -$x | tail -1 | cut -d: -f3`"
	let pos=pos+1	
	done
	posicion $pos
	echo "Pulsa enter para voler al menú principal."
	read backkk
	source newkahoot.sh
	
}





















menu_jugmaster