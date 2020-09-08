#!/bin/bash
#Crear documento de partida para archivar resultados
echo "baraja=a1a b1b c1c d1d a2a b2b c2c d2d a3a b3b c3c d3d a4a b4b c4c d4d a5a b5b c5c d5d a6a b6b c6c d6d a7a b7b c7c d7d a8a b8b c8c d8d a9a b9b c9c d9d a10a b10b c10c d10d a11.a b11.b c11.c d11.d a12.a b12.b c12.c d12.d" > juegoactual.txt
echo "usuario=" >> juegoactual.txt
echo "maquina=" >> juegoactual.txt
echo "usuarioP=0" >> juegoactual.txt
echo "maquinaP=0" >> juegoactual.txt
echo "CGUsuario=" >> juegoactual.txt
echo "CGMaquina=" >> juegoactual.txt

function inicio
{
    #Menu de inicio
    clear
    echo ""
echo " █████╗     ██████╗ ███████╗███████╗ ██████╗ █████╗ ██████╗ ██╗
██╔══██╗    ██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗██╔══██╗██║
███████║    ██████╔╝█████╗  ███████╗██║     ███████║██████╔╝██║
██╔══██║    ██╔═══╝ ██╔══╝  ╚════██║██║     ██╔══██║██╔══██╗╚═╝
██║  ██║    ██║     ███████╗███████║╚██████╗██║  ██║██║  ██║██╗
╚═╝  ╚═╝    ╚═╝     ╚══════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝"
    echo "
    "
    echo "                   1 - Iniciar partida"
    echo "                   2 - Salir"
    read opcioninicio
    case $opcioninicio in
        1)
        repartirCartas;;
        2)
        exit;;
    esac
}
function repartirCartas
{
    #repartir cartas usuario
    #Bucle que se repita 7 veces para repartir 7 cartas en este caso al usuario. Se elije una carta aleatoria entre todas las cartas restantes, es decir, las del "montón" al elegirla,
    #la quita del montón y se la asigna al usuario a la máquina respectivamente.
    for x in $(seq 7)
    do
        baraja=$(cat juegoactual.txt | grep baraja= | cut -d= -f2)
        cartasrestantes=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | wc -w)
        numCartaRandom=$(shuf -i 1-$cartasrestantes -n1)
        cartaRandom="$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | cut -d" " -f $numCartaRandom) "
        barajaSinCarta=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | sed -e "s/$cartaRandom//g")
        sed -i "s/baraja=$baraja/baraja=$barajaSinCarta/g" "juegoactual.txt"
        cartasUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2)
        sed -i "s/usuario=$cartasUsuario/usuario=$cartasUsuario$cartaRandom/g" "juegoactual.txt"
        quitarLetrasUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2 | tr -d [a-z])
        cartasUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2)
        sed -i "s/usuario=$cartasUsuario/usuario=$quitarLetrasUsuario/g" "juegoactual.txt"
    done

    #repartir cartas máquina
    for x in $(seq 7)
    do
        baraja=$(cat juegoactual.txt | grep baraja= | cut -d= -f2)
        cartasrestantes=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | wc -w)
        #Comando para elegir un número aleatorio entre el 1 y el número de cartas que queden en el montón
        numCartaRandom=$(shuf -i 1-$cartasrestantes -n1)
        cartaRandom="$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | cut -d" " -f $numCartaRandom) "
        barajaSinCarta=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | sed -e "s/$cartaRandom//g")
        sed -i "s/baraja=$baraja/baraja=$barajaSinCarta/g" "juegoactual.txt"
        cartasMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2)
        sed -i "s/maquina=$cartasMaquina/maquina=$cartasMaquina$cartaRandom/g" "juegoactual.txt"
        quitarLetrasMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2 | tr -d [a-z])
        cartasMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2)
        sed -i "s/maquina=$cartasMaquina/maquina=$quitarLetrasMaquina/g" "juegoactual.txt"
    done
    turnoUsuario
}

function turnoUsuario
{
    #Cada vez que es el turno del usuario se comprueba que queden cartas restantes en cada jugador y la baraja, en caso de que no queden la partida finaliza mostrando el ganador. 
    clear
    finalizarPartida
    mostrarCartasUsu=$(cat juegoactual.txt | grep usuario= | cut -d= -f2 | tr -d "." | tr " " "\n" | sort -n | tr "\n" " ")
    cartasBarajaRestantes=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | wc -w)
    puntosJugador=$(cat juegoactual.txt | grep usuarioP= | cut -d= -f2)
    puntosIA=$(cat juegoactual.txt | grep maquinaP= | cut -d= -f2)
    echo "Tus Cartas: $(tput setaf 2)$mostrarCartasUsu $(tput sgr 0)"
    echo "Cartas restantes: $cartasBarajaRestantes"
    echo "Puntos Jugador: $(tput setaf 2)$puntosJugador $(tput sgr 0)"
    echo "Puntos IA: $(tput setaf 1)$puntosIA $(tput sgr 0)"
    echo ""
    read -p"Elige una carta: nº -> " cartaSeleccionada
    #comprueba que se haya escrito un número y no, por ejemplo, una letra por error.
    validarNumero='^-?[0-9]+([.][0-9]+)?$'
    if ! [[ $cartaSeleccionada =~ $validarNumero ]] ; then
        echo "Por favor escribe un caracter numérico entre 1 y 12"
        sleep 1.5
        turnoUsuario
    fi
    #En caso de que la carta seleccionada sea un 11, se pondrá un punto al final porque al filtrar buscando un 1 o 2, también se flitran el 11 y 12, para solucionarlo, puse un punto
    #al final, de esta forma son totalmente iguales cara al usuario, pero internamente no.
    if [ "$cartaSeleccionada" = "11" ];then
        cartaSeleccionada="$cartaSeleccionada."
        elif [ "$cartaSeleccionada" = "12" ];then
            cartaSeleccionada="$cartaSeleccionada."
    fi
    #Si en este caso, la máquina tiene la carta que pide el usuario, se la entregará y se quitará de la lista de cartas de la máquina.
    buscarCartaSeleccionada=$(cat juegoactual.txt | grep maquina= | cut -d= -f2 | grep -o "$cartaSeleccionada " | head -1)
    if [ "$cartaSeleccionada " = "$buscarCartaSeleccionada" ]
    then
        numCartasTiene=$(cat juegoactual.txt | grep maquina= | cut -d= -f2 | grep -o "$cartaSeleccionada " | wc -l)
        for x in $(seq $numCartasTiene)
        do
            cartasActuales=$(cat juegoactual.txt | grep usuario= | cut -d= -f2)
            sed -i "s/usuario=$cartasActuales/usuario=$cartasActuales$cartaSeleccionada /g" "juegoactual.txt"
            cartasMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2)
            cartasMaquinaSinCarta=$(cat juegoactual.txt | grep maquina= | cut -d= -f2 | sed -e "s/$cartaSeleccionada //g")
            sed -i "s/maquina=$cartasMaquina/maquina=$cartasMaquinaSinCarta /g" "juegoactual.txt"
        done
        host="usuario"
        hostP="usuarioP"
        CGHost="CGUsuario"
        #Llama a la función "comprobarPuntoCompartidoBucle" para comprobar si se ha conseguido formar un grupo de 4 cartas iguales.
        comprobarPuntoCompartidoBucle
        #comprueba que no se hayan colado varios espacios en blanco que puedan perjudicar el funcionamiento del juego.
        cat juegoactual.txt | tr -s " " > juegoactual1.txt
        rm juegoactual.txt
        mv juegoactual1.txt juegoactual.txt
        #Vuelve a tener el turno el usuario ya que la máquina si tenia la carta/cartas que pedía.
        turnoUsuario
        
    else
        echo "A pescar!!"
        #En caso de no tener la carta que pide el usuario, se elige una carta aleatoria del montón. El proceso de selección elige una carta, la quita del montón, y la añade a las
        #cartas que tiene el usuario
        barajaRestante=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | wc -w)
        #Si solo queda una carta en el montón, se realizan estas operaciones
        if [ "$barajaRestante" = "1" ]
        then
            baraja=$(cat juegoactual.txt | grep baraja= | cut -d= -f2)
            barajaSinCarta=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | sed -e "s/$baraja//g")
            cartaRandom="$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | cut -d" " -f1) "
            sed -i "s/baraja=$baraja/baraja=$barajaSinCarta/g" "juegoactual.txt"
            cartasUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2)
            sed -i "s/usuario=$cartasUsuario/usuario=$cartasUsuario$cartaRandom/g" "juegoactual.txt"
            quitarLetrasUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2 | tr -d [a-z])
            cartasUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2)
            sed -i "s/usuario=$cartasUsuario/usuario=$quitarLetrasUsuario/g" "juegoactual.txt"
            host="usuario"
            hostP="usuarioP"
            CGHost="CGUsuario"
            comprobarPuntoCompartidoBucle
            sleep 1.5
            cat juegoactual.txt | tr -s " " > juegoactual1.txt
            rm juegoactual.txt
            mv juegoactual1.txt juegoactual.txt
            turnoMaquina
            #Si ya no queda ninguna carta y el jugador ha elegido una carta que no tiene la máquina, se pasará el turno.
            elif [ "$barajaRestante" = "0" ]
            then
                echo "Ya no quedan más cartas restantes. Pasando turno al otro jugador..."
                sleep 1.5
                cat juegoactual.txt | tr -s " " > juegoactual1.txt
                rm juegoactual.txt
                mv juegoactual1.txt juegoactual.txt
                turnoMaquina
                #Si todavia quedan muchas cartas en el montón se realizaran las operaciones normales, es decir, elegir carta, restarla del montón y asignarla al jugador.
                elif [ "$barajaRestante" != "0" ] && [ "$barajaRestante" != "1" ]
                then
                    baraja=$(cat juegoactual.txt | grep baraja= | cut -d= -f2)
                    cartasrestantes=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | wc -w)
                    numCartaRandom=$(shuf -i 1-$cartasrestantes -n1)
                    cartaRandom="$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | cut -d" " -f $numCartaRandom) "
                    barajaSinCarta=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | sed -e "s/$cartaRandom//g")
                    sed -i "s/baraja=$baraja/baraja=$barajaSinCarta/g" "juegoactual.txt"
                    cartasUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2)
                    sed -i "s/usuario=$cartasUsuario/usuario=$cartasUsuario$cartaRandom/g" "juegoactual.txt"
                    quitarLetrasUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2 | tr -d [a-z])
                    cartasUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2)
                    sed -i "s/usuario=$cartasUsuario/usuario=$quitarLetrasUsuario/g" "juegoactual.txt"
                    #Estas variables sirven para indicarle a la función "comprobarPuntoCompartidoBucle" de que jugador estamos hablando, es decir, si tiene que comprobar las cartas
                    #del usuario o de la máquina.
                    host="usuario"
                    hostP="usuarioP"
                    CGHost="CGUsuario"
                    comprobarPuntoCompartidoBucle
                    sleep 1.5
                    cat juegoactual.txt | tr -s " " > juegoactual1.txt
                    rm juegoactual.txt
                    mv juegoactual1.txt juegoactual.txt
                    turnoMaquina
        fi
    fi
}

function turnoMaquina
{
    #El turno de la máquina es muy similar al del usuario, pero automatizando las tareas. Al elegir una carta, la máquina elige una carta aleatoria entre las que dispone
    #y le pregunt al usuario si la tiene. En caso de tenerla volverá a realizar la acción. Si no la tiene, aparecerá el mensaje "la máquina ha pescado!" y cogerá una carta
    #aleatoria del montón de forma similar a como lo hace el usuario.
    clear
    echo "La máquina está jugando...."
    finalizarPartida
    misCartas=$(cat juegoactual.txt | grep maquina= | cut -d= -f2 | wc -w)
    numCartaRandom=$(shuf -i 1-$misCartas -n1)
    cartaRandom="$(cat juegoactual.txt | grep maquina= | cut -d= -f2 | cut -d" " -f $numCartaRandom) "

    buscarCartaSeleccionada=$(cat juegoactual.txt | grep usuario= | cut -d= -f2 | grep -o "$cartaRandom " | head -1)
    if [ "$cartaRandom " = "$buscarCartaSeleccionada" ]
    then
        numCartasTiene=$(cat juegoactual.txt | grep usuario= | cut -d= -f2 | grep -o "$cartaRandom " | wc -l)
        for x in $(seq $numCartasTiene)
        do
            cartasActuales=$(cat juegoactual.txt | grep maquina= | cut -d= -f2)
            sed -i "s/maquina=$cartasActuales/maquina=$cartasActuales$cartaSeleccionada /g" "juegoactual.txt"
            cartasUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2)
            cartasUsuarioSinCarta=$(cat juegoactual.txt | grep usuario= | cut -d= -f2 | sed -e "s/$cartaSeleccionada //g")
            sed -i "s/usuario=$cartasUsuario/usuario=$cartasUsuarioSinCarta /g" "juegoactual.txt"
        done
        host="maquina"
        hostP="maquinaP"
        CGHost="CGMaquina"
        comprobarPuntoCompartidoBucle
        cat juegoactual.txt | tr -s " " > juegoactual1.txt
        rm juegoactual.txt
        mv juegoactual1.txt juegoactual.txt
        turnoMaquina
    else
        echo "La máquina ha pescado!"
        barajaRestante=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | wc -w)
        if [ "$barajaRestante" = "1" ]
        then
            baraja=$(cat juegoactual.txt | grep baraja= | cut -d= -f2)
            barajaSinCarta=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | sed -e "s/$baraja//g")
            cartaRandom="$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | cut -d" " -f1) "
            sed -i "s/baraja=$baraja/baraja=$barajaSinCarta/g" "juegoactual.txt"
            cartasMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2)
            sed -i "s/maquina=$cartasMaquina/maquina=$cartasMaquina$cartaRandom/g" "juegoactual.txt"
            quitarLetrasMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2 | tr -d [a-z])
            cartasMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2)
            sed -i "s/maquina=$cartasMaquina/maquina=$quitarLetrasMaquina/g" "juegoactual.txt"
            host="maquina"
            hostP="maquinaP"
            CGHost="CGMaquina"
            comprobarPuntoCompartidoBucle
            sleep 1.5
            cat juegoactual.txt | tr -s " " > juegoactual1.txt
            rm juegoactual.txt
            mv juegoactual1.txt juegoactual.txt
            turnoUsuario
            
            elif [ "$barajaRestante" = "0" ]
            then
                echo "Ya no quedan más cartas restantes. Pasando turno al otro jugador..."
                sleep 1.5
                cat juegoactual.txt | tr -s " " > juegoactual1.txt
                rm juegoactual.txt
                mv juegoactual1.txt juegoactual.txt
                turnoUsuario
            elif [ "$barajaRestante" != "0" ] && [ "$barajaRestante" != "1" ]
            then
                baraja=$(cat juegoactual.txt | grep baraja= | cut -d= -f2)
                cartasrestantes=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | wc -w)
                numCartaRandom=$(shuf -i 1-$cartasrestantes -n1)
                cartaRandom="$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | cut -d" " -f $numCartaRandom) "
                barajaSinCarta=$(cat juegoactual.txt | grep baraja= | cut -d= -f2 | sed -e "s/$cartaRandom//g")
                sed -i "s/baraja=$baraja/baraja=$barajaSinCarta/g" "juegoactual.txt"
                cartasMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2)
                sed -i "s/maquina=$cartasMaquina/maquina=$cartasMaquina$cartaRandom/g" "juegoactual.txt"
                quitarLetrasMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2 | tr -d [a-z])
                cartasMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2)
                sed -i "s/maquina=$cartasMaquina/maquina=$quitarLetrasMaquina/g" "juegoactual.txt"
                host="maquina"
                hostP="maquinaP"
                CGHost="CGMaquina"
                comprobarPuntoCompartidoBucle
                sleep 1.5
                cat juegoactual.txt | tr -s " " > juegoactual1.txt
                rm juegoactual.txt
                mv juegoactual1.txt juegoactual.txt
                turnoUsuario
            fi
    fi
}
function finalizarPartida
{
    #Esta función se encarga de comprobar cada vez que se le llama, de que todavía queden cartas en el usuario y la máquina. Si la suma de las cartas del usuario y
    #la máquina es = 0, se ejectará esta función.
    #Una vez se ha comprobado que la suma es = 0, se comprueba quien es el ganador eligiendo el jugador que más puntos ha obtenido
    #En la pantalla final, ya seas el ganador o el perdedor, siempre aparecerá el número de puntos que ha conseguido cada jugador y las cartas que han obtenido.
    cartasRestantesUsuario=$(cat juegoactual.txt | grep usuario= | cut -d= -f2 | wc -w)
    cartasRestantesMaquina=$(cat juegoactual.txt | grep maquina= | cut -d= -f2 | wc -w)
    sumaCartas=0
    let sumaCartas=cartasRestantesMaquina+cartasRestantesUsuario
    if [ "$sumaCartas" = "0" ];then
    ganador=$(cat juegoactual.txt | tail -4 | head -2 | sort -nr | head -1 | cut -d= -f1)
    
        if [ "$ganador" = "usuarioP" ];then
        puntosUsuario=$(cat juegoactual.txt | tail -4 | head -2 | sort -nr | head -1 | cut -d= -f2)
        puntosMaquina=$(cat juegoactual.txt | tail -4 | head -2 | sort -nr | tail -1 | cut -d= -f2)
        cartasUsuarioObtenidas=$(cat juegoactual.txt | grep CGUsuario= | cut -d= -f2)
        cartasMaquinaObtenidas=$(cat juegoactual.txt | grep CGMaquina= | cut -d= -f2)
        echo "██╗  ██╗ █████╗ ███████╗     ██████╗  █████╗ ███╗   ██╗ █████╗ ██████╗  ██████╗ ██╗
██║  ██║██╔══██╗██╔════╝    ██╔════╝ ██╔══██╗████╗  ██║██╔══██╗██╔══██╗██╔═══██╗██║
███████║███████║███████╗    ██║  ███╗███████║██╔██╗ ██║███████║██║  ██║██║   ██║██║
██╔══██║██╔══██║╚════██║    ██║   ██║██╔══██║██║╚██╗██║██╔══██║██║  ██║██║   ██║╚═╝
██║  ██║██║  ██║███████║    ╚██████╔╝██║  ██║██║ ╚████║██║  ██║██████╔╝╚██████╔╝██╗
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝"
        echo ""
        echo "                        Usuario: $puntosUsuario"
        echo "                        Máquina: $puntosMaquina"
        echo ""
        echo "     El usuario ha conseguido estas cartas: "
        echo "      -> $cartasUsuarioObtenidas"
        echo ""
        echo "     La máquina ha conseguido estas cartas: "
        echo "      -> $cartasMaquinaObtenidas"
        read -p"Pulsa Enter para volver al menú.." final
        #se borra el fichero que se ha utilizado para poder realizar los calculos y operaciones.
        rm juegoactual.txt
        inicio
            elif [ "$ganador" = "maquinaP" ];then
            puntosUsuario=$(cat juegoactual.txt | tail -4 | head -2 | sort -nr | tail -1 | cut -d= -f2)
            puntosMaquina=$(cat juegoactual.txt | tail -4 | head -2 | sort -nr | head -1 | cut -d= -f2)
            cartasUsuarioObtenidas=$(cat juegoactual.txt | grep CGUsuario= | cut -d= -f2)
            cartasMaquinaObtenidas=$(cat juegoactual.txt | grep CGMaquina= | cut -d= -f2)
        echo "██╗  ██╗ █████╗ ███████╗    ██████╗ ███████╗██████╗ ██████╗ ██╗██████╗  ██████╗       
██║  ██║██╔══██╗██╔════╝    ██╔══██╗██╔════╝██╔══██╗██╔══██╗██║██╔══██╗██╔═══██╗      
███████║███████║███████╗    ██████╔╝█████╗  ██████╔╝██║  ██║██║██║  ██║██║   ██║      
██╔══██║██╔══██║╚════██║    ██╔═══╝ ██╔══╝  ██╔══██╗██║  ██║██║██║  ██║██║   ██║      
██║  ██║██║  ██║███████║    ██║     ███████╗██║  ██║██████╔╝██║██████╔╝╚██████╔╝██╗██╗
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═════╝  ╚═════╝ ╚═╝╚═╝"
            echo ""
            echo "                      Usuario: $puntosUsuario"
            echo "                      Máquina: $puntosMaquina"
            echo ""
            echo "     El usuario ha conseguido estas cartas: "
            echo "      -> $cartasUsuarioObtenidas"
            echo ""
            echo "     La máquina ha conseguido estas cartas: "
            echo "      -> $cartasMaquinaObtenidas"
            read -p"Pulsa Enter para volver al menú.." final
            rm juegoactual.txt
            inicio
        fi
    fi
}

function comprobarPuntoCompartidoBucle
{
#Comprobar cartas para sumar punto en caso de haber 4 iguales. Como el 11 y el 12 son especiales al añadirle un punto al final,
#hay que hacer un comprobación a parte sólo para estos dos.
#Se hace un bucle que se repite durante 12 veces, del 1 al 12, y comprueba todas las cartas para que no haya 4 iguales.
#En caso de haber 4 iguales, se restan y se suma un punto al respectivo jugador.
    for x in $(seq 12)
    do
        comprobarCarta=$(cat juegoactual.txt | grep $host= | cut -d= -f2 | grep -o "$x " | wc -l)
        if [ "$x" = "11" ] || [ "$x" = "12" ]
        then
            comprobarCarta=$(cat juegoactual.txt | grep $host= | cut -d= -f2 | grep -o "$x. " | wc -l)
            if [ "$comprobarCarta" = "4" ]
            then
                puntosActuales=$(cat juegoactual.txt | grep $hostP= | cut -d= -f2);puntosActualesSumado=0
                let puntosActualesSumado=puntosActuales+1
                sed -i "s/$hostP=$puntosActuales/$hostP=$puntosActualesSumado/g" "juegoactual.txt"
                cartasSumar=$(cat juegoactual.txt | grep $host= | cut -d= -f2 | grep -o "$x. " | tr "\n" " " | tr -s " ")
                cartasSumadas=$(cat juegoactual.txt | grep $CGHost= | cut -d= -f2)
                sed -i "s/$CGHost=$cartasSumadas/$CGHost=$cartasSumadas$cartasSumar/g" "juegoactual.txt"
                cartasUsuario=$(cat juegoactual.txt | grep $host= | cut -d= -f2)
                quitarCartas=$(cat juegoactual.txt | grep $host= | cut -d= -f2 | sed -e "s/$x. //g")
                sed -i "s/$host=$cartasUsuario/$host=$quitarCartas/g" "juegoactual.txt"
            fi
        else
            if [ "$comprobarCarta" = "4" ];then
                puntosActuales=$(cat juegoactual.txt | grep $hostP= | cut -d= -f2);puntosActualesSumado=0
                let puntosActualesSumado=puntosActuales+1
                sed -i "s/$hostP=$puntosActuales/$hostP=$puntosActualesSumado/g" "juegoactual.txt"
                cartasSumar=$(cat juegoactual.txt | grep $host= | cut -d= -f2 | grep -o "$x " | tr "\n" " " | tr -s " ")
                cartasSumadas=$(cat juegoactual.txt | grep $CGHost= | cut -d= -f2)
                sed -i "s/$CGHost=$cartasSumadas/$CGHost=$cartasSumadas$cartasSumar/g" "juegoactual.txt"
                cartasUsuario=$(cat juegoactual.txt | grep $host= | cut -d= -f2)
                quitarCartas=$(cat juegoactual.txt | grep $host= | cut -d= -f2 | sed -e "s/$x //g")
                sed -i "s/$host=$cartasUsuario/$host=$quitarCartas/g" "juegoactual.txt"              
            fi
        fi
    done    
}
inicio