#!/bin/bash

    #------ACLARACIONES-----
    #Los campos de las bases de datos están separados por ";". Es posible que sea necesario saberlo para la correción y comprobación
    #de su funcionamiento. He tenido algunas dudas en "las aclaraciones" de la información del reto. Un punto indica que hay que listar todos los préstamos hechos, pero
    #no deja clara su intención, puede ser que se refiera a un historial de todos los préstamos hechos hasta el momento o de todos los préstamos actuales.
    #Como no tenia claro cuál de las dos hacer, he optado por hacer ambas, por eso hay una opción más en el menú de préstamos.
    

    #COMPRUEBA QUE LOS FICHEROS DE BASE DE DATOS ESTÉN CREADOS, SINOS LOS CREA
    if ! [ -f libros.bd ] 
    then
        touch libros.bd
    fi

    if ! [ -f usuarios.bd ]
    then
        touch usuarios.bd
    fi

    if ! [ -f prestamos.bd ]
    then
        touch prestamos.bd
    fi

    #Este fichero es exclusivamente para el historial de préstamos
    if ! [ -f historialPrestamos.bd ]
    then
        echo "id_Libro|Titulo|id_Usuario|Nombre|Fecha_Alquiler" > historialPrestamos.bd
    fi

function menu
{
    clear
    echo ""
    echo "  ██████╗ ██╗██████╗ ██╗     ██╗ ██████╗ ████████╗███████╗ ██████╗ █████╗ 
  ██╔══██╗██║██╔══██╗██║     ██║██╔═══██╗╚══██╔══╝██╔════╝██╔════╝██╔══██╗
  ██████╔╝██║██████╔╝██║     ██║██║   ██║   ██║   █████╗  ██║     ███████║
  ██╔══██╗██║██╔══██╗██║     ██║██║   ██║   ██║   ██╔══╝  ██║     ██╔══██║
  ██████╔╝██║██████╔╝███████╗██║╚██████╔╝   ██║   ███████╗╚██████╗██║  ██║
  ╚═════╝ ╚═╝╚═════╝ ╚══════╝╚═╝ ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝"
echo ""
echo "                    1 - Gestion de usuarios"
echo "                    2 - Gestion de libros"
echo "                    3 - Gestion de préstamos"
echo "                    4 - Salir"
read opcionMenu
case $opcionMenu in
    1)
    gestionUsuarios;;
    2)
    gestionLibros;;
    3)
    gestionPrestamos;;
    4)
    exit;;
    *)
    menu;;
esac
}

function gestionUsuarios
{
    clear
    echo ""
    echo "  ██╗   ██╗███████╗██╗   ██╗ █████╗ ██████╗ ██╗ ██████╗ ███████╗
  ██║   ██║██╔════╝██║   ██║██╔══██╗██╔══██╗██║██╔═══██╗██╔════╝
  ██║   ██║███████╗██║   ██║███████║██████╔╝██║██║   ██║███████╗
  ██║   ██║╚════██║██║   ██║██╔══██║██╔══██╗██║██║   ██║╚════██║
  ╚██████╔╝███████║╚██████╔╝██║  ██║██║  ██║██║╚██████╔╝███████║
   ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚══════╝"
    echo ""
    echo "               1 - Dar de alta usuario"
    echo "               2 - Dar de baja usuario"
    echo "               3 - Consultar usuario"
    echo "               4 - Volver" 
    read opcionUsuarios
    case $opcionUsuarios in
        1)
            #Añadir un usuario
            clear
            echo "== RELLENA LOS DATOS =="
            echo ""
            read -p"Nombre: " nombreUser
            read -p"Primer apellido: " apellidoUser
            read -p"Segundo apellido: " apellidoDosUser
            read -p"Curso: " cursoUser
            CalcularId=$(cat usuarios.bd | tail -1 | cut -d";" -f1)
            idUser=0
            let idUser=CalcularId+1
            echo "
Quieres añadir a $(tput setaf 5)$nombreUser $apellidoUser $apellidoDosUser$(tput sgr 0) del curso $(tput setaf 5)$cursoUser$(tput sgr 0)? S/n"
            read sino
            case $sino in
            S|s)
                echo "$idUser;$nombreUser;$apellidoUser;$apellidoDosUser;$cursoUser;0" >> usuarios.bd
                echo "Usuario guardado con éxito"
                sleep 1.5
                gestionUsuarios;;
            N|n)
                echo "Operación cancelada.."
                sleep 1.5
                gestionUsuarios;;
            *)
                echo "Operación cancelada.."
                sleep 1.5
                gestionUsuarios;;
            esac                
        ;;
        2)
            clear
            echo "== INDICA EL ID DE USUARIO =="
            echo ""
            echo "  -ID-   -Nombre"
            maxUsers=$(cat usuarios.bd | wc -l)
            for x in $(seq $maxUsers)
            do
                idUser=$(cat usuarios.bd | cut -d";" -f1 | head -$x | tail -1)
                nombre=$(cat usuarios.bd | cut -d";" -f2,3 | head -$x | tail -1 | tr ";" " ")
                echo "   $(tput bold)$idUser$(tput sgr 0).$nombre" | tr "." "\t"
            done
            echo ""
            read -p"Nº ID: >" idBorrar
            #Comprobar que se haya escrito un número
            validarNumero='^-?[0-9]+([.][0-9]+)?$'
            if ! [[ $idBorrar =~ $validarNumero ]] ; then
                echo "Por favor escribe un caracter numérico"
                sleep 1.5
                gestionUsuarios
            fi
            #Comprobar que exista ese ID
            lineaUser=$(cat usuarios.bd | cut -d";" -f1 | grep -nw "$idBorrar" | cut -d: -f1)
            if [ "$lineaUser" = "" ];then
                echo "No hay ningún usuario con este ID asociado. "
                sleep 2
                gestionUsuarios
            fi
            #Comprueba que el usuario no tenga ningún libro alquilado. En caso de tenerlo, no podrá borrarse 
            buscarIdEnPrestamos=$(cat prestamos.bd | cut -d";" -f3 | grep "$idBorrar")
            if [ "$idBorrar" = "$buscarIdEnPrestamos" ];then
                echo "El usuario tiene préstamos pendientes por tanto no es posible darlo de baja en este momento"
                sleep 2.5
                gestionUsuarios
            fi

            datosUser=$(cat usuarios.bd | head -$lineaUser | tail -1)
            nombreBorrado=$(echo $datosUser |  cut -d";" -f2-4 | tr ";" " ")
            echo "Quieres borrar el usuario $(tput setaf 5)$nombreBorrado$(tput sgr 0)? S/n"
            read opcionBorrar
            case $opcionBorrar in
                S|s)
                    echo ""
                    sed -i "$lineaUser d" "usuarios.bd"
                    echo "El usuario $nombreBorrado ha sido dado de baja."
                    sleep 1.5
                    gestionUsuarios;;
                N|n)
                    echo "Operación cancelada.."
                    sleep 1.5
                    gestionUsuarios;;
                *)
                    echo "Operación cancelada.."
                    sleep 1.5
                    gestionUsuarios;;
            esac               
        ;;
        3)
            clear
            echo "== ESCRIBE EL ID O EL NOMBRE DEL USUARIO =="
            echo ""
            echo "  -ID- -Nombre"
            maxUsers=$(cat usuarios.bd | wc -l)
            for x in $(seq $maxUsers)
            do
                idUser=$(cat usuarios.bd | cut -d";" -f1 | head -$x | tail -1)
                nombre=$(cat usuarios.bd | cut -d";" -f2 | head -$x | tail -1 | tr ";" " ")
                echo "   $(tput bold)$idUser$(tput sgr 0).$nombre" | tr "." "\t"
            done
            echo ""
            read -p"> " buscarUser
            elegir=1
            #Si se ha escrito un numero se buscará por ID sinós por nombre
            validarNumero='^-?[0-9]+([.][0-9]+)?$'
            if ! [[ $buscarUser =~ $validarNumero ]] ; then
            elegir=2
            fi
                clear
                
                lineaUserwc=$(cat usuarios.bd | cut -d";" -f$elegir | grep -nw "$buscarUser" | cut -d: -f1 | wc -l)
                #Comprobar si hay más usuarios con el mismo nombre, (Únicamente al buscar por nombre). En caso de haber, por ejemplo, 
                #tres con el mismo nombre, se mostraran esos tres.
                if [ $lineaUserwc > 1 ];then
                    clear
                    echo "== DATOS USUARIOS =="
                    for x in $(seq $lineaUserwc)
                    do
                        lineaUser=$(cat usuarios.bd | cut -d";" -f$elegir | grep -nw "$buscarUser" | cut -d: -f1 | head -$x | tail -1)
                        datosUser=$(cat usuarios.bd | head -$lineaUser | tail -1)
                        idBuscado=$(echo $datosUser | cut -d";" -f1)
                        nombreBuscado=$(echo $datosUser | cut -d";" -f2)
                        apellidos=$(echo $datosUser | cut -d";" -f3,4 | tr ";" " ")
                        curso=$(echo $datosUser | cut -d";" -f5)
                        prestados=$(echo $datosUser | cut -d";" -f6)
                        echo ""
                        echo "$(tput bold)ID: $(tput sgr 0)$idBuscado"
                        echo "$(tput bold)Nombre: $(tput sgr 0)$nombreBuscado"
                        echo "$(tput bold)Apellidos: $(tput sgr 0)$apellidos"
                        echo "$(tput bold)Curso: $(tput sgr 0)$curso"
                        echo "$(tput bold)Libros alquilados: $(tput sgr 0)$prestados"
                    done
                    read -p"Pulsa enter para volver...." nada
                    gestionUsuarios
                else
                        lineaUser=$(cat usuarios.bd | cut -d";" -f$elegir | grep -nw "$buscarUser" | cut -d: -f1)
                        datosUser=$(cat usuarios.bd | head -$lineaUser | tail -1)
                        idBuscado=$(echo $datosUser | cut -d";" -f1)
                        nombreBuscado=$(echo $datosUser | cut -d";" -f2)
                        apellidos=$(echo $datosUser | cut -d";" -f3,4 | tr ";" " ")
                        curso=$(echo $datosUser | cut -d";" -f5)
                        prestados=$(echo $datosUser | cut -d";" -f6)
                        echo "== DATOS USUARIO =="
                        echo ""
                        echo "$(tput bold)ID: $(tput sgr 0)$idBuscado"
                        echo "$(tput bold)Nombre: $(tput sgr 0)$nombreBuscado"
                        echo "$(tput bold)Apellidos: $(tput sgr 0)$apellidos"
                        echo "$(tput bold)Curso: $(tput sgr 0)$curso"
                        echo "$(tput bold)Libros alquilados: $(tput sgr 0)$prestados"
                        read -p"Pulsa enter para volver...." nada
                        gestionUsuarios
                fi;;
        4)
        menu;;
        *)
        gestionUsuarios;;
    esac
}
function gestionLibros
{
    clear
    echo ""
    echo "    ██╗     ██╗██████╗ ██████╗  ██████╗ ███████╗
    ██║     ██║██╔══██╗██╔══██╗██╔═══██╗██╔════╝
    ██║     ██║██████╔╝██████╔╝██║   ██║███████╗
    ██║     ██║██╔══██╗██╔══██╗██║   ██║╚════██║
    ███████╗██║██████╔╝██║  ██║╚██████╔╝███████║
    ╚══════╝╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
    echo ""
    echo "              1 - Dar de alta libro"
    echo "              2 - Dar de baja libro"
    echo "              3 - Consultar libro"
    echo "              4 - Volver"
    read opcionLibros

    case $opcionLibros in
    1)
        #Añadir un libro
        clear
        echo "== RELLENA LOS DATOS =="
        echo ""
        read -p"Título: " tituloLibro
        read -p"Autor: " autorLibro
        read -p"Género: " generoLibro
        read -p"Año: " fechaLibro
        read -p"Estantería: " estanteriaLibro
        echo ""
        echo "Quieres añadir el libro $(tput setaf 5)$tituloLibro$(tput sgr 0)? S/n"
        read sino
        CalcularId=$(cat libros.bd | tail -1 | cut -d";" -f1)
        idLibro=0
        let idLibro=CalcularId+1
        case $sino in
            S|s)
                echo "$idLibro;$tituloLibro;$autorLibro;$generoLibro;$fechaLibro;$estanteriaLibro;estado0" >> libros.bd
                echo "Libro guardado con éxito"
                sleep 1.5
                gestionLibros;;
            N|n)
                echo "Operación cancelada.."
                sleep 1.5
                gestionLibros;;
            *)
                echo "Operación cancelada.."
                sleep 1.5
                gestionLibros;;
            esac
    ;;
    2)
        #Se listan todos los libros con su titulo y respectivo ID para poder elegir que libro dar de baja
        clear
            echo "== INDICA EL ID DEL LIBRO =="
            echo ""
            echo "  -ID-   -Título"
            maxLibros=$(cat libros.bd | wc -l)
            for x in $(seq $maxLibros)
            do
                idLibro=$(cat libros.bd | cut -d";" -f1 | head -$x | tail -1)
                nombre=$(cat libros.bd | cut -d";" -f2 | head -$x | tail -1)
                echo "   $(tput bold)$idLibro$(tput sgr 0).$nombre" | tr "." "\t"
            done
            echo ""
            read -p"Nº ID: >" idBorrar
            #Comprobar que se haya escrito un número
            validarNumero='^-?[0-9]+([.][0-9]+)?$'
            if ! [[ $idBorrar =~ $validarNumero ]] ; then
                echo "Por favor escribe un caracter numérico"
                sleep 1.5
                gestionLibros
            fi
            #Comprueba que el ID indicado exista en la base de datos
            lineaLibro=$(cat libros.bd | cut -d";" -f1 | grep -nw "$idBorrar" | cut -d: -f1)
            if [ "$lineaLibro" = "" ];then
                echo "No hay ningún libro con este ID asociado. "
                sleep 2
                gestionLibros
            fi
            #Comprueba que el libro no esté alquilado, en caso de que esté, no se podrá dar de baja.
            buscarIdEnPrestamos=$(cat prestamos.bd | cut -d";" -f2 | grep "$idBorrar")
            if [ "$idBorrar" = "$buscarIdEnPrestamos" ];then
                echo "El libro tiene préstamos pendientes por tanto no es posible darlo de baja en este momento"
                sleep 2.5
                gestionLibros
            fi
            datosLibro=$(cat libros.bd | head -$lineaLibro | tail -1)
            tituloBorrado=$(echo $datosLibro | cut -d";" -f2)
            echo "Quieres borrar el libro $(tput setaf 5)$tituloBorrado$(tput sgr 0)? S/n"
            read opcionBorrar
            case $opcionBorrar in
                S|s)
                    echo ""
                    sed -i "$lineaLibro d" "libros.bd"
                    echo "El libro $tituloBorrado ha sido dado de baja."
                    sleep 1.5
                    gestionLibros;;
                N|n)
                    echo "Operación cancelada.."
                    sleep 1.5
                    gestionLibros;;
                *)
                    echo "Operación cancelada.."
                    sleep 1.5
                    gestionLibros;;
            esac
    ;;
    3)
        #En esta opción se listan todos los libros, mostrando su ID y Titulo para poder elegir alguno y mostrar toda la información
        clear
            echo "== ESCRIBE EL ID O EL TITULO DEL LIBRO =="
            echo ""
            echo "  -ID-   -Título"
            maxLibros=$(cat libros.bd | wc -l)
            for x in $(seq $maxLibros)
            do
                idLibro=$(cat libros.bd | cut -d";" -f1 | head -$x | tail -1)
                nombre=$(cat libros.bd | cut -d";" -f2 | head -$x | tail -1)
                echo "   $(tput bold)$idLibro$(tput sgr 0).$nombre" | tr "." "\t"
            done
            echo ""
            read -p"> " buscarLibro
            elegir=1
            #Si se ha escrito un numero se buscará por ID sinós por nombre
            validarNumero='^-?[0-9]+([.][0-9]+)?$'
            if ! [[ $buscarLibro =~ $validarNumero ]] ; then
            elegir=2
            fi
                clear
                
                lineaLibrowc=$(cat libros.bd | cut -d";" -f$elegir | grep -nw "$buscarLibro" | cut -d: -f1 | wc -l)
                #Comprobar si hay más libros con el mismo nombre, (Únicamente al buscar por nombre). En caso de haber, por ejemplo, 
                #tres con el mismo nombre, se mostraran esos tres.
                if [ $lineaLibrowc > 1 ];then
                    clear
                    echo "== DATOS LIBROS =="
                    for x in $(seq $lineaLibrowc)
                    do
                        lineaLibro=$(cat libros.bd | cut -d";" -f$elegir | grep -nw "$buscarLibro" | cut -d: -f1 | head -$x | tail -1)
                        datosLibro=$(cat libros.bd | head -$lineaLibro | tail -1)
                        idBuscado=$(echo $datosLibro | cut -d";" -f1)
                        tituloBuscado=$(echo $datosLibro | cut -d";" -f2)
                        autor=$(echo $datosLibro | cut -d";" -f3)
                        genero=$(echo $datosLibro | cut -d";" -f4)
                        fecha=$(echo $datosLibro | cut -d";" -f5)
                        estanteria=$(echo $datosLibro | cut -d";" -f6)
                        estadoPrestado=$(echo $datosLibro | cut -d";" -f7)
                            if [ "$estadoPrestado" = "estado1" ];then
                                estado="$(tput setaf 1)Alquilado$(tput sgr 0)"
                            else
                                estado="$(tput setaf 2)Libre$(tput sgr 0)"
                            fi
                        echo ""
                        echo "$(tput bold)ID: $(tput sgr 0)$idBuscado"
                        echo "$(tput bold)Titulo: $(tput sgr 0)$tituloBuscado"
                        echo "$(tput bold)Autor: $(tput sgr 0)$autor"
                        echo "$(tput bold)Género: $(tput sgr 0)$genero"
                        echo "$(tput bold)Año: $(tput sgr 0)$fecha"
                        echo "$(tput bold)Estantería: $(tput sgr 0)$estanteria"
                        echo "$(tput bold)Estado: $(tput sgr 0)$estado"
                    done
                    echo ""
                    read -p"Pulsa enter para volver...." nada
                    gestionLibros
                else
                        lineaLibro=$(cat libros.bd | cut -d";" -f$elegir | grep -nw "$buscarLibro" | cut -d: -f1)
                        datosLibro=$(cat libros.bd | head -$lineaLibro | tail -1)
                        idBuscado=$(echo $datosLibro | cut -d";" -f1)
                        tituloBuscado=$(echo $datosLibro | cut -d";" -f2)
                        autor=$(echo $datosLibro | cut -d";" -f3)
                        genero=$(echo $datosLibro | cut -d";" -f4)
                        fecha=$(echo $datosLibro | cut -d";" -f5)
                        estanteria=$(echo $datosLibro | cut -d";" -f6)
                        estadoPrestado=$(echo $datosLibro | cut -d";" -f7)
                            if [ "$estadoPrestado" = "estado1" ];then
                                estado="$(tput setaf 1)Alquilado$(tput sgr 0)"
                            else
                                estado="$(tput setaf 2)Libre$(tput sgr 0)"
                            fi
                        echo "== DATOS LIBRO =="
                        echo ""
                        echo "$(tput bold)ID: $(tput sgr 0)$idBuscado"
                        echo "$(tput bold)Titulo: $(tput sgr 0)$tituloBuscado"
                        echo "$(tput bold)Autor: $(tput sgr 0)$autor"
                        echo "$(tput bold)Género: $(tput sgr 0)$genero"
                        echo "$(tput bold)Año: $(tput sgr 0)$fecha"
                        echo "$(tput bold)Estantería: $(tput sgr 0)$estanteria"
                        echo "$(tput bold)Estado: $(tput sgr 0)$estado"
                        echo ""
                        read -p"Pulsa enter para volver...." nada
                        gestionLibros
                fi;;
    4)
    menu;;
    *)
    gestionLibros;;
    esac
}

function gestionPrestamos
{
    clear
    echo ""
    echo "   █████╗ ██╗      ██████╗ ██╗   ██╗██╗██╗     ███████╗██████╗ 
  ██╔══██╗██║     ██╔═══██╗██║   ██║██║██║     ██╔════╝██╔══██╗
  ███████║██║     ██║   ██║██║   ██║██║██║     █████╗  ██████╔╝
  ██╔══██║██║     ██║▄▄ ██║██║   ██║██║██║     ██╔══╝  ██╔══██╗
  ██║  ██║███████╗╚██████╔╝╚██████╔╝██║███████╗███████╗██║  ██║
  ╚═╝  ╚═╝╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝"
    echo ""
    echo "                 1 - Alquilar un libro"
    echo "                 2 - Devolver un libro"
    echo "                 3 - Listar historial libros alquilados"
    echo "                 4 - Listar libros alquilados actualmente"
    echo "                 5 - Consultar un alquiler"
    echo "                 6 - Atrás"
    read opcionPrestamos
    case $opcionPrestamos in
        1)
            #Esta es la opción para alquilar un libro, por tanto se hacen dos bubles, uno para mostrar los libros que no estén actualmente alquilados y otro para los usuarios
            #que no tengan ya 3 libros alquilados
            clear
            #Solo muestra los libros que no estén ya alquilados. estado1 = Alquilado
            maxLibros=$(cat libros.bd | grep -v ";estado1" | wc -l)
            echo "  == LIBROS DISPONIBLES =="
            echo ""
            for x in $(seq $maxLibros)
            do
                echo "  $(tput bold)$x$(tput sgr 0) - $(cat libros.bd | grep -v ";estado1" | cut -d";" -f2 | head -$x | tail -1)"
            done
            echo ""
            read -p"Elige un libro: Nº >" numLibro
            #Comprueba que sea un caracter numérico
            validarNumero='^-?[0-9]+([.][0-9]+)?$'
            if ! [[ $numLibro =~ $validarNumero ]] ; then
                echo "Por favor escribe un caracter numérico"
                sleep 1.5
                gestionPrestamos
            fi
            libroElegido=$(cat libros.bd | grep -v ";estado1" | head -$numLibro | tail -1)
            #Comprueba que el ID indicado exista en la base de datos
            if [ "$libroElegido" = "" ];then
                echo "No hay ningún libro con este ID asociado. "
                sleep 2
                gestionPrestamos
            fi
            clear
            maxUsers=$(cat usuarios.bd | grep -v ";3" | wc -l)
            echo "  == USUARIOS DISPONIBLES =="
            for y in $(seq $maxUsers)
            do
                echo "  $y - $(cat usuarios.bd | grep -v ";3" | cut -d";" -f2,3 | tr ";" " " | head -$y | tail -1)"
            done
            echo ""
            read -p"Elige un usuario: Nº >" numUser
            #VALIDAR QUE SE HAYA ESCRITO UN CARÁCTER NUMÉRICO
            validarNumero='^-?[0-9]+([.][0-9]+)?$'
            if ! [[ $numUser =~ $validarNumero ]] ; then
                echo "Por favor escribe un caracter numérico"
                sleep 1.5
                gestionPrestamos
            fi
            usuarioElegido=$(cat usuarios.bd | grep -v ";3" | head -$numUser | tail -1)
            clear
            tituloLibro=$(echo $libroElegido | cut -d";" -f2)
            nombreUser=$(echo $usuarioElegido | cut -d";" -f2,3 | tr ";" " ")
            echo "Quieres asignar el libro $(tput setaf 5)$tituloLibro$(tput sgr 0) al usuario $(tput setaf 5)$nombreUser$(tput sgr 0)? S/n"
            read sino
            case $sino in
                S|s)
                    #ESTADO LIBRO
                    libroElegidoSinEstado=$(echo $libroElegido | cut -d";" -f1-6)
                    sed -i "s/$libroElegido/$libroElegidoSinEstado;estado1/g" "libros.bd"
                    #PRESTAMOS USER
                    userElegidoSinPrestamos=$(echo $usuarioElegido | cut -d";" -f1-5)
                    prestamos=$(echo $usuarioElegido | cut -d";" -f6)
                    let prestamos=prestamos+1
                    sed -i "s/$usuarioElegido/$userElegidoSinPrestamos;$prestamos/g" "usuarios.bd"
                    #AÑADIR PRESTAMO A BASE DE DATOS DE PRESTAMOS
                    CalcularId=$(cat prestamos.bd | tail -1 | cut -d";" -f1)
                    idPrestamo=0
                    let idPrestamo=CalcularId+1
                    idUserElegido=$(echo $usuarioElegido | cut -d";" -f1)
                    idLibroElegido=$(echo $libroElegido | cut -d";" -f1)
                    echo "$idPrestamo;$idLibroElegido;$idUserElegido" >> prestamos.bd
                    #AÑADIR PRÉSTAMO AL HISTORIAL DE PRÉSTAMOS, ADEMÁS SE AÑADE LA FECHA ACTUAL
                    echo "$idLibroElegido|$tituloLibro|$idUserElegido|$nombreUser|$(date +"%d-%m-%y")" >> historialPrestamos.bd
                    clear
                    echo "Libro asignado"
                    sleep 2
                    gestionPrestamos;;
                N|n)
                    echo "Operación cancelada..."
                    sleep 2
                    gestionPrestamos;;
                *)
                    echo "Operación cancelada..."
                    sleep 2
                    gestionPrestamos;;
            esac;;
        2)
            #Con este bucle obtenemos todos los datos necesarios para mostrar los libros actualmente alquilados y sus respectivos clientes.
            clear
            maxLibros=$(cat libros.bd | grep ";estado1" | wc -l)
            echo "== ELIGE UN LIBRO =="
            echo ""
            for x in $(seq $maxLibros)
            do
                conseguirIdLibro=$(cat libros.bd | grep ";estado1" | cut -d";" -f1 | head -$x | tail -1)
                conseguirLineaPrestamo=$(cat prestamos.bd | grep -n ";$conseguirIdLibro;" | cut -d: -f1)
                conseguirIdUser=$(cat prestamos.bd | head -$conseguirLineaPrestamo | tail -1 | cut -d";" -f3)
                conseguirLineaUser=$(cat usuarios.bd | cut -d";" -f1 | grep -nw "$conseguirIdUser" | cut -d: -f1)
                conseguirNombreUser=$(cat usuarios.bd | head -$conseguirLineaUser | tail -1 | cut -d";" -f2,3 | tr ";" " ")
                echo " $x - $(tput bold)$(cat libros.bd | grep ";estado1" | cut -d";" -f2 | head -$x | tail -1)$(tput sgr 0)_Alquilado por:$(tput setaf 5) $conseguirNombreUser$(tput sgr 0)_ID:$(tput setaf 5)$conseguirIdUser$(tput sgr 0)" | tr "_" "\t"         
            done
            echo ""
            read -p"Elige el libro. Nº >" numLibro
            #VALIDAR QUE SE HAYA ESCRITO UN CARACTER NUMÉRICO
            validarNumero='^-?[0-9]+([.][0-9]+)?$'
            if ! [[ $numLibro =~ $validarNumero ]] ; then
                echo "Por favor escribe un caracter numérico"
                sleep 1.5
                gestionPrestamos
            fi
            #Comprobar que exista el libro
            lineaLibroElegido=$(cat libros.bd | grep ";estado1" | head -$numLibro | tail -1)
            if [ "$lineaLibroElegido" = "" ];then
                echo "No hay ningún libro con este ID asociado. "
                sleep 2
                gestionPrestamos
            fi
            nombreLibro=$(echo $lineaLibroElegido | cut -d";" -f2)
            echo "Seguro que quieres devolver el libro $(tput setaf 5)$nombreLibro$(tput sgr 0)? S/n"
            read sino
            case $sino in
                S|s)
                    #CAMBIAR ESTADO LIBRO A "LIBRE"
                    lineaLibroElegidoSinEstado=$(echo $lineaLibroElegido | cut -d";" -f1-6)
                    sed -i "s/$lineaLibroElegido/$lineaLibroElegidoSinEstado;estado0/g" "libros.bd"
                    #RESTAR LIBRO ALQUILADO AL USUARIO
                    idLibroElegido=$(echo $lineaLibroElegido | cut -d";" -f1)
                    lineaPrestamos=$(cat prestamos.bd | grep -n ";$idLibroElegido;" | cut -d: -f1)
                    conseguirIdUser=$(cat prestamos.bd | head -$lineaPrestamos | tail -1 | cut -d";" -f3)
                    numLineaUser=$(cat usuarios.bd | cut -d";" -f1 | grep -nw "$conseguirIdUser" | cut -d: -f1)
                    lineaUser=$(cat usuarios.bd | head -$numLineaUser | tail -1)
                    lineaUserSinPrestamos=$(echo $lineaUser | cut -d";" -f1-5)
                    numDePrestamosUser=$(echo $lineaUser | cut -d";" -f6)
                    let numDePrestamosUser=numDePrestamosUser-1
                    sed -i "s/$lineaUser/$lineaUserSinPrestamos;$numDePrestamosUser/g" "usuarios.bd"
                    #ELIMINAR LINEA DE ENLACE EN LA BASE DE DATOS DE PRESTAMOS
                    sed -i "$lineaPrestamos d" "prestamos.bd"  
                    echo "El libro: $nombreLibro está libre.."
                    sleep 2
                    gestionPrestamos
                ;;
                N|n)
                    echo "Operación cancelada..."
                    sleep 2
                    gestionPrestamos;;
                *)
                    echo "Operación cancelada..."
                    sleep 2
                    gestionPrestamos;;
            esac;;
        3)
        clear
        echo ""
        echo "  ██╗  ██╗██╗███████╗████████╗ ██████╗ ██████╗ ██╗ █████╗ ██╗     
  ██║  ██║██║██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██║██╔══██╗██║     
  ███████║██║███████╗   ██║   ██║   ██║██████╔╝██║███████║██║     
  ██╔══██║██║╚════██║   ██║   ██║   ██║██╔══██╗██║██╔══██║██║     
  ██║  ██║██║███████║   ██║   ╚██████╔╝██║  ██║██║██║  ██║███████╗
  ╚═╝  ╚═╝╚═╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝"
  echo ""
        #Muestra los datos del historial ordenados por columnas
        column -t -s"|" historialPrestamos.bd
        echo ""
        read -p"Pulsa enter para volver..." back
        gestionPrestamos
        ;;
        4)
            #Muestra solamente los préstamos actuales con sus respectivos clientes
            clear
            maxLibros=$(cat libros.bd | grep ";estado1" | wc -l)
            echo "  == LIBROS ALQUILADOS ACTUALMENTE =="
            echo ""
            for x in $(seq $maxLibros)
            do
                conseguirIdLibro=$(cat libros.bd | grep ";estado1" | cut -d";" -f1 | head -$x | tail -1)
                conseguirLineaPrestamo=$(cat prestamos.bd | grep -n ";$conseguirIdLibro;" | cut -d: -f1)
                conseguirIdUser=$(cat prestamos.bd | head -$conseguirLineaPrestamo | tail -1 | cut -d";" -f3)
                conseguirLineaUser=$(cat usuarios.bd | cut -d";" -f1 | grep -nw "$conseguirIdUser" | cut -d: -f1)
                conseguirNombreUser=$(cat usuarios.bd | head -$conseguirLineaUser | tail -1 | cut -d";" -f2,3 | tr ";" " ")
                echo " $x - $(tput bold)$(cat libros.bd | grep ";estado1" | cut -d";" -f2 | head -$x | tail -1)$(tput sgr 0)_Alquilado por:$(tput setaf 5) $conseguirNombreUser$(tput sgr 0)_ID:$(tput setaf 5)$conseguirIdUser$(tput sgr 0)" | tr "_" "\t"         
            done
            echo ""
            read -p"Pulsa enter para volver.." back
            gestionPrestamos
        ;;
        5)
            clear
            echo "  == ELIGE EL MÉTODO DE BÚSQUEDA =="
            echo ""
            echo "     1 - Buscar por cliente"
            echo "     2 - Buscar por libro"
            read opcionConsultaPrestamos
            case $opcionConsultaPrestamos in
                1)
                    clear
                    echo "        == CLIENTES CON PRÉSTAMOS =="
                    echo "== ESCRIBE EL ID O EL NOMBRE DEL USUARIO =="
                    echo ""
                    echo "  -ID- -Nombre"
                    maxUsers=$(cat usuarios.bd | grep -v ";0" | wc -l)
                    for x in $(seq $maxUsers)
                    do
                        idUser=$(cat usuarios.bd | grep -v ";0" | cut -d";" -f1 | head -$x | tail -1)
                        nombre=$(cat usuarios.bd | grep -v ";0" | cut -d";" -f2 | head -$x | tail -1 | tr ";" " ")
                        echo "   $(tput bold)$idUser$(tput sgr 0).$nombre" | tr "." "\t"
                    done
                    echo ""
                    read -p"> " buscarUser
                    elegir=1
                    #Si se ha escrito un numero se buscará por ID sinós por nombre
                    validarNumero='^-?[0-9]+([.][0-9]+)?$'
                    if ! [[ $buscarUser =~ $validarNumero ]] ; then
                    elegir=2
                    fi
                    lineaUser=$(cat usuarios.bd | cut -d";" -f$elegir | grep -nw "$buscarUser" | cut -d: -f1)
                    #Comprueba que el ID indicado exista en la base de datos
                    if [ "$lineaUser" = "" ];then
                        echo "No hay ningún usuario con este ID asociado. "
                        sleep 2
                        gestionPrestamos
                    fi
                    datosUser=$(cat usuarios.bd | head -$lineaUser | tail -1)
                    idBuscado=$(echo $datosUser | cut -d";" -f1)
                    librosAlquilados=$(echo $datosUser | cut -d";" -f6)
                    #Commprobar que el cliente selecciona tenga libros alquilados
                    if [ $librosAlquilados = 0 ];then
                    echo "Este cliente no ha alquilado ningún libro.."
                    sleep 2
                    gestionPrestamos
                    fi
                    
                        obtenerLineaIdLibroPrestado=$(cat prestamos.bd | cut -d";" -f3 | grep -nw "$idBuscado" | tr "[:blank:]" "\n")
                        clear
                        echo "  == DATOS PRÉSTAMOS =="
                        echo "  Nombre cliente: $(tput bold)$(echo "$datosUser" | cut -d";" -f2,3 | tr ";" " ")$(tput sgr 0) ID: $(tput bold)$idBuscado$(tput sgr 0)"
                        echo "  Curso: $(tput bold)$(echo "$datosUser" | cut -d";" -f5)$(tput sgr 0)"
                        echo "--LIBROS ALQUILADOS: $(tput bold)$librosAlquilados$(tput sgr 0) --"
                            for x in $(seq $librosAlquilados)
                            do
                                lineaPrestamo=$(echo "$obtenerLineaIdLibroPrestado" | tr " " "\n" | head -$x | tail -1 | cut -d: -f1)
                                
                                idLibro=$(cat prestamos.bd | head -$lineaPrestamo | tail -1 | cut -d";" -f2)
                                lineaLibro=$(cat libros.bd | cut -d";" -f1 | grep -nw "$idLibro" | cut -d: -f1)
                                datosLibro=$(cat libros.bd | head -$lineaLibro | tail -1)
                                idBuscado=$(echo $datosLibro | cut -d";" -f1)
                                tituloBuscado=$(echo $datosLibro | cut -d";" -f2)
                                autor=$(echo $datosLibro | cut -d";" -f3)
                                genero=$(echo $datosLibro | cut -d";" -f4)
                                fecha=$(echo $datosLibro | cut -d";" -f5)
                                estanteria=$(echo $datosLibro | cut -d";" -f6)
                                estadoPrestado=$(echo $datosLibro | cut -d";" -f7)
                                    if [ "$estadoPrestado" = "estado1" ];then
                                        estado="$(tput setaf 1)Alquilado$(tput sgr 0)"
                                    else
                                        estado="$(tput setaf 2)Libre$(tput sgr 0)"
                                    fi
                                echo ""
                                echo "$(tput bold)ID: $(tput sgr 0)$idBuscado"
                                echo "$(tput bold)Titulo: $(tput sgr 0)$tituloBuscado"
                                echo "$(tput bold)Autor: $(tput sgr 0)$autor"
                                echo "$(tput bold)Género: $(tput sgr 0)$genero"
                                echo "$(tput bold)Año: $(tput sgr 0)$fecha"
                                echo "$(tput bold)Estantería: $(tput sgr 0)$estanteria"
                                echo "$(tput bold)Estado: $(tput sgr 0)$estado"
                                echo ""
                            done
                        read -p"Pulsa enter para volver al menú.." back
                        gestionPrestamos
                ;;
                2)
                    clear
                    echo "== ESCRIBE EL ID O EL TITULO DEL LIBRO =="
                    echo ""
                    echo "  -ID-   -Título"
                    maxLibros=$(cat libros.bd | grep ";estado1" | wc -l)
                    for x in $(seq $maxLibros)
                    do
                        idLibro=$(cat libros.bd | grep ";estado1" | cut -d";" -f1 | head -$x | tail -1)
                        nombre=$(cat libros.bd | grep ";estado1" | cut -d";" -f2 | head -$x | tail -1)
                        echo "   $(tput bold)$idLibro$(tput sgr 0).$nombre" | tr "." "\t"
                    done
                    echo ""
                    read -p"> " buscarLibro
                    elegir=1
                    #Si se ha escrito un numero se buscará por ID sinós por nombre
                    validarNumero='^-?[0-9]+([.][0-9]+)?$'
                    if ! [[ $buscarLibro =~ $validarNumero ]] ; then
                    elegir=2
                    fi
                    lineaLibro=$(cat libros.bd | cut -d";" -f$elegir | grep -nw "$buscarLibro" | cut -d: -f1)
                    #Comprueba que el ID indicado exista en la base de datos
                    if [ "$lineaLibro" = "" ];then
                        echo "No hay ningún libro con este ID asociado. "
                        sleep 2
                        gestionPrestamos
                    fi
                    datosLibro=$(cat libros.bd | head -$lineaLibro | tail -1)
                    idBuscado=$(echo $datosLibro | cut -d";" -f1)
                    buscarLineaIdUserPrestamos=$(cat prestamos.bd | grep -n ";$idBuscado;" | cut -d: -f1)
                    idUser=$(cat prestamos.bd | head -$buscarLineaIdUserPrestamos | tail -1 | cut -d";" -f3)
                    lineaUser=$(cat usuarios.bd | cut -d";" -f1 | grep -n "$idUser" | cut -d: -f1)
                    datosUser=$(cat usuarios.bd | head -$lineaUser | tail -1)
                    clear
                    echo "  == DATOS PRÉSTAMO =="
                    echo "  Nombre cliente: $(tput bold)$(echo "$datosUser" | cut -d";" -f2,3 | tr ";" " ")$(tput sgr 0) ID: $(tput bold)$idUser$(tput sgr 0)"
                    echo "  Curso: $(tput bold)$(echo "$datosUser" | cut -d";" -f5)$(tput sgr 0)"
                    echo "-- LIBRO --"
                    echo ""
                    tituloBuscado=$(echo $datosLibro | cut -d";" -f2)
                    autor=$(echo $datosLibro | cut -d";" -f3)
                    genero=$(echo $datosLibro | cut -d";" -f4)
                    fecha=$(echo $datosLibro | cut -d";" -f5)
                    estanteria=$(echo $datosLibro | cut -d";" -f6)
                    estadoPrestado=$(echo $datosLibro | cut -d";" -f7)
                        #Comprobar si el libro está alquilado o está libre. Cambia el color a rojo o verde
                        if [ "$estadoPrestado" = "estado1" ];then
                            estado="$(tput setaf 1)Alquilado$(tput sgr 0)"
                        else
                            estado="$(tput setaf 2)Libre$(tput sgr 0)"
                        fi
                    echo ""
                    echo "$(tput bold)ID: $(tput sgr 0)$idBuscado"
                    echo "$(tput bold)Titulo: $(tput sgr 0)$tituloBuscado"
                    echo "$(tput bold)Autor: $(tput sgr 0)$autor"
                    echo "$(tput bold)Género: $(tput sgr 0)$genero"
                    echo "$(tput bold)Año: $(tput sgr 0)$fecha"
                    echo "$(tput bold)Estantería: $(tput sgr 0)$estanteria"
                    echo "$(tput bold)Estado: $(tput sgr 0)$estado"
                    echo ""
                    read -p"Pulsa enter para volver al menú.." back
                    gestionPrestamos
                ;;
                *)
                echo "Elige una de las dos opciones.."
                sleep 1.5
                gestionPrestamos;;
            esac;;
        6)
        menu;;
        *)
        gestionPrestamos;;
    esac
}

menu