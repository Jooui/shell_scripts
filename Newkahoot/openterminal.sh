#!/bin/bash
cont=1200
pwdd=`pwd`
for x in `seq 10`
do
gnome-terminal.real --maximize --working-directory=`pwd` --command="bash fifo1.sh $cont"
let cont=cont+1
done
