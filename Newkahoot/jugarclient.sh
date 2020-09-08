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

function menu_jugclient {
	clear
	tamanyo=35
	posicion 8
	echo "╔═════════════════════════════════╗"
	posicion 9
	echo "║       Escribe tu nombre         ║"
	posicion 10
	echo "╚═════════════════════════════════╝"
	posicion 11
	read -p ">" nombrejug
	clear
	tamanyo=32
	portada titulotemas
	posicion 8
	echo "╔═════════════════════════════════╗"
	posicion 9
	echo "║         Elige el tema           ║"
	posicion 10
	echo "╚═════════════════════════════════╝"
	max3=`ls temas/ | wc -l`
	posic=11
		for x in `seq $max3`
		do
			posicion $posic
			echo "$x- `ls -l temas/ | tail -n +2 | tr -s " " | head -$x | tail -1 | cut -d" " -f9 | cut -d"." -f1`"
			let posic=posic+1
		done
	let posic=posic+1
	posicion $posic
	read -p "Nº" temaelegido
	temaelegido1=`ls temas/ | tail -n +1 | tr -s " " | head -$temaelegido | tail -1 | cut -d" " -f9`
	temaelegido2=`ls temas/ | tail -n +1 | tr -s " " | head -$temaelegido | tail -1 | cut -d" " -f9 | cut -d"." -f1`
	sleep 0.5
	clear
	jugclient
}

function jugclient {

	clear
	lastsala="`cat salas/historial.txt | tail -1`.txt"
	echo "$nombrejug" >> salas/$lastsala
	x=1
	jugclient2
}

function jugclient2 {

	while true
	do
		echo "Esperando a los jugadores..."
		if [ "`cat salas/$lastsala | tail -1`" = "jugar" ]
			then
			clear
			jugclient3
		fi
		if [ "`cat salas/$lastsala | tail -1`" = "finish" ]
		then
		resultados
		break
		fi
		clear
	done
}

function jugclient3 {
	j=1
	tamanyo=32
	posicion 8
	echo "╔══════════════════════════════╗"
	posicion 9
	echo "║           Pregunta  $j        ║"
	posicion 10
	echo "╚══════════════════════════════╝"
	posicion 11
	echo ""
	read adaiafi
	posicion 12
	maxium=`cat temas/$temaelegido1 | wc -l`
	poso=13
	for a in `seq $maxium`
	do
		posicion $poso
		echo "`cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f1`"
		let poso=poso+1
		posicion $poso
		echo " 1- `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f2`"
		let poso=poso+1
		posicion $poso
		echo " 2- `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f3`"
		let poso=poso+1
		posicion $poso
		echo " 3- `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f4`"
		let poso=poso+1
		posicion $poso
		echo " 4- `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f5`"
		let poso=poso+1
		posicion $poso
		read amajdadja
		read -p " > " opcionpreg
		let j=j+1
		if [ $opcionpreg = `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f6` ]
			then
			echo "$nombrejug:$opcionpreg:correcto" >> salas/$lastsala
			let x=x+1
			jugclient2
			else
			echo "$nombrejug:$opcionpreg:falso" >> salas/$lastsala
			let x=x+1
			jugclient2
		fi

		

	done


	if [ $opcionpreg = `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f6` ]
	then
	echo "$nombrejug:$opcionpreg:correcto" >> salas/$lastsala
	let x=x+1
	jugclient2
	else
	echo "$nombrejug:$opcionpreg:falso" >> salas/$lastsala
	let x=x+1
	jugclient2
	fi
}



function resultados {
	clear
	tamanyo=51
	portada tituloresultados
	posicion 8
	echo "Cargando los resultados..."
	correctas=`cat salas/$lastsala | grep $nombrejug | grep correcto | wc -l`
	falso=`cat salas/$lastsala | grep $nombrejug | grep falso | wc -l`
	echo "$nombrejug:$correctas:$falso" >>salas/resultados_$lastsala
	sleep 3
	numpuestojug=`cat salas/resultados_$lastsala | grep -n $nombrejug | cut -d: -f1`
	clear
	tamanyo=51
	portada tituloresultados
	tamanyo=39
	posicion 8
	echo "╔═════════════════════════════════════╗"
	posicion 9
	echo "║    Has quedado en el puesto Nº `tput setaf 5`$numpuestojug`tput sgr 0`    ║"
	posicion 10
	echo "╚═════════════════════════════════════╝"
	exit
}
menu_jugclient



















