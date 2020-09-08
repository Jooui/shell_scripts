#!/bin/bash
#Autor: El presi
#Version: 1.02
#Nombre: Hundir La flota

if [ -f arx ]; then
	echo "No se creo el archivo ARX"
else
	mkfifo arx$1
	echo "$1"
	nc -l $1 < arx$1 | ./jugarclient.sh > arx$1	
fi

rm arx