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
function menu {
	rm arx*
    clear
tamanyo=60
portada menutitulos
read -n1 option1
case $option1 in
    1)
    preguntas;;
    2)
    source jugarmaster.sh;;
    3)
    exit;;
    *)
    menu;;
esac
}

function menu_preguntas {
		clear
		tamanyo=77
		portada titulopregunta
		tamanyo=64
				echo ""
				posicion 8
				echo "╔═════════════════════════════╗       ╔══════════════════════════════╗"
				posicion 9
				echo "║   1 - Mostrar preguntas     ║       ║   2 - Crear nueva pregunta   ║"
				posicion 10
				echo "╚═════════════════════════════╝       ╚══════════════════════════════╝"
				posicion 11
				echo "                ╔═════════════════════════════════╗"
				posicion 12
				echo "                ║       3 - Volver al menu        ║"
				posicion 13
				echo "                ╚═════════════════════════════════╝"
				posicion 14
				echo "                 Tema:`tput setaf 5` $temaelegido2`tput sgr 0`"
				read -n1 option3
				posi=12
					case $option3 in
						1)
						clear
						portada titulopregunta
						tamanyo=35
						posicion 8
						echo "╔═════════════════════════════════╗"
						posicion 9
						echo "║        Mostrar preguntas        ║"
						posicion 10
						echo "╚═════════════════════════════════╝"
						tamanyo=42
						max1=`cat temas/$temaelegido1 | wc -l`
							for x in `seq $max1`
							do
								posicion $posi
								let posi=posi+1
								echo "`tput setaf 5`Pregunta:`tput sgr 0` `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f1`"
								posicion $posi
								let posi=posi+1
								echo "`tput setaf 5`Respuestas:`tput sgr 0`   `tput setaf 5`Respuesta correcta:`tput sgr 0` `cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f6`"
								posicion $posi
								let posi=posi+1
								echo " 1-`cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f2`"
								posicion $posi
								let posi=posi+1
								echo " 2-`cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f3`"
								posicion $posi
								let posi=posi+1
								echo " 3-`cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f4`"
								posicion $posi
								let posi=posi+1
								echo " 4-`cat temas/$temaelegido1 | head -$x | tail -1 | cut -d: -f5`"
								posicion $posi
								let posi=posi+1
								echo ""
								done
						read ckajnff
						menu_preguntas;;
						2)
						crear_preguntas2;;
						3)
						preguntas;;
						*)
						menu_preguntas;;
					esac
}

function preguntas {
	clear
	tamanyo=77
	portada titulopregunta
	tamanyo=64
		echo ""
		posicion 8
		echo "╔══════════════════════════╗       ╔══════════════════════════╗"
		posicion 9
		echo "║   1 - Elegir un tema     ║       ║   2 - Crear nuevo tema   ║"
		posicion 10
		echo "╚══════════════════════════╝       ╚══════════════════════════╝"
		posicion 11
		echo "              ╔═════════════════════════════════╗"
		posicion 12
		echo "              ║       3 - Volver al menu        ║"
		posicion 13
		echo "              ╚═════════════════════════════════╝"
		read -n1 option2
	case $option2 in
		1)
			clear
			tamanyo=32
			portada titulotemas
			posicion 8
			echo "╔═════════════════════════════════╗"
			posicion 9
			echo "║         Elige un tema           ║"
			posicion 10
			echo "╚═════════════════════════════════╝"
			max=`ls temas/ | wc -l`
			pos=11
			for x in `seq $max`
			do
				posicion $pos
				echo "$x- `ls -l temas/ | tail -n +2 | tr -s " " | head -$x | tail -1 | cut -d" " -f9 | cut -d"." -f1`"
				let pos=pos+1
			done
			let pos=pos+1
			posicion $pos
			read -p "Nº" temaelegido
			temaelegido1=`ls temas/ | tail -n +1 | tr -s " " | head -$temaelegido | tail -1 | cut -d" " -f9`
			temaelegido2=`ls temas/ | tail -n +1 | tr -s " " | head -$temaelegido | tail -1 | cut -d" " -f9 | cut -d"." -f1`
			sleep 0.5
				clear
				menu_preguntas;;
		2)
			clear
			tamanyo=32
			portada titulotemas
			posicion 8
			echo "╔═════════════════════════════════╗"
			posicion 9
			echo "║   Escribe el nombre del tema    ║"
			posicion 10
			echo "╚═════════════════════════════════╝"
			posicion 11
			echo "╔═════════════════════════════════╗"
			posicion 12
			echo "║ >                               ║"
			posicion 13
			echo "╚═════════════════════════════════╝"
	       		posicion 12 
			read -p "║ >" nombre_tema
			nombre_tema2=`echo "$nombre_tema" | tr -d " "`
			sleep 1
			touch temas/$nombre_tema2.txt
			preguntas;;
		3)
		menu;;
		*)
		preguntas;;
	esac
}

function crear_preguntas2 {
        clear
        tamanyo=59
        portada kahoottitulo
        tamanyo=28
        posicion 8
        echo "╔══════════════════════════╗"
        posicion 9
        echo "║   Escribe tu pregunta    ║"
        posicion 10
        echo "╚══════════════════════════╝"
        posicion 11
        read pregunta
        posicion 12
        echo "*En el caso de querer menos de 4 respuestas posibles, deja el campo en blanco.*"
        posicion 13
        echo "╔══════════════════════════╗"
        posicion 14
        echo "║       Respuesta 1        ║"
        posicion 15
        echo "╚══════════════════════════╝"
        posicion 16
        read respuesta1
        posicion 17
        echo "╔══════════════════════════╗"
        posicion 18
        echo "║       Respuesta 2        ║"
        posicion 19
        echo "╚══════════════════════════╝"
        posicion 20
        read respuesta2
        posicion 21
        echo "╔══════════════════════════╗"
        posicion 22
        echo "║       Respuesta 3        ║"
        posicion 23
        echo "╚══════════════════════════╝"
        posicion 24
        read respuesta3
        posicion 25
        echo "╔══════════════════════════╗"
        posicion 26
        echo "║       Respuesta 4        ║"
        posicion 27
        echo "╚══════════════════════════╝"
        posicion 28
        read respuesta4
        posicion 29
        echo "Cual es la respuesta correcta? (1-4)"
        posicion 30
        read respuesta_correcta
        posicion 31
        echo "$pregunta:$respuesta1:$respuesta2:$respuesta3:$respuesta4:$respuesta_correcta" >> temas/$temaelegido1
        clear
        posicion 32
        echo "La pregunta se ha creado correctamente"
        sleep 1.5
        menu_preguntas
}

menu
