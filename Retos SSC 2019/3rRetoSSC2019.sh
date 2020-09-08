#!/bin/bash
jugadores_T1=(12 15 18 21 24)
jugadores_T2=(37 40 43 46 49)
num_games=$(cat games.csv | wc -l)
num_champs=$(cat champions.csv | wc -l)
for x in $(seq $num_champs)   #Elegir campeon a buscar
do
    unset array
    id_champ=$(cat champions.csv | head -$x | tail -1 | cut -d"," -f1)
    name_champ=$(cat champions.csv | head -$x | tail -1 | cut -d"," -f2)
    array=()
    for y in $(seq $num_games)
    do
        linea_juego=$(cat games.csv | head -$y | tail -1)
        buscar_T1=$(echo $linea_juego | cut -d, -f12,15,18,21,24 | grep -wo "$x")
        winner=$(echo $linea_juego | cut -d, -f5)
        if [ "$buscar_T1" = "$x" ] && [ "$winner" = "1" ]
        then
            for player in {0..4..1}
            do
                team1_player=$(echo $linea_juego | cut -d"," -f$(echo ${jugadores_T1[$player]}))
                if [ "$team1_player" = "$x" ]
                then
                    continue
                else
                    array+=("$team1_player")
                fi
            done
        elif [ "$buscar_T2" = "x" ] && [ "$winner" = "2" ]
        then
            for player in {0..4..1}
            do
                team2_player=$(echo $linea_juego | cut -d"," -f$(echo ${jugadores_T2[$player]}))
                if [ "$team2_player" = "$x" ]
                then
                    continue
                else
                array+=("$team2_player")
                fi
            done
        fi
        echo "$y"
    done
    morePlayed="`echo ${array[*]} | tr " " "\n" | sort | uniq -c | sort | tr -s " " | sort -nk1 | tail -1 | cut -d" " -f2,3 | tr -d '\015'`"        
    idDuo="`echo $morePlayed | cut -d" " -f2 | tr -d '\015'`"
    nombreChamp="`cat champions.csv | head -$x | tail -1 | cut -d"," -f2 | tr -d '\015'`"
    nombreDuo="`cat champions.csv | grep "$idDuo," | cut -d"," -f2 | tr -d '\015'`"
    timesTogether="`echo $morePlayed | cut -d" " -f1 | tr -d '\015'`"
    echo "$nombreChamp,$nombreDuo,$timesTogether" >> result1.csv
done
cat result1.csv | sort -n -t ',' -k3 | tail -10 >> result.csv
