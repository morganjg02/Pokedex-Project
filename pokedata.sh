#!/usr/bin/env bash

FILE=pokedexScraper/pokedexData.csv

read -p "Would you like to search for a specific Pokemon? (y/n): " search

if [ "$search" == "n" ];then
    awk -F ',' '{print "ID,NAME,TYPE,TOTAL"; print $1","$2","$3","$4}' $FILE | column -t -L -s ","
else
    read -p "Enter Pokemon name: " name
    # if statement to check if pokemon name is in dex (case & spelling sensitive)
    # -F ','                       : set field separator ','
    # -v pokemon="$name" -v col=2  : assign variables before execution. 
    #                                Column will always be 2 for name search.
    # '$col ~ pokemon'             : regex to ensure that input name is in column 2
    # {found=1; print}             : set a variable (found) to true and print the line
    # | grep -q .                  : printed lines are piped to grep, which (-q) quietly
    #                                checks to see if awk printed anything
    if awk -F ',' -v pokemon="$name" -v col=2 '$col ~ pokemon {found=1; print}' "$FILE" | grep -q .; then
        {
            echo "ID,NAME,TYPE,TOTAL"
            awk -F ',' -v pokemon="$name" -v col=2 '$col ~ pokemon {print $1","$2","$3","$4}' $FILE
        } | column -t -s ","
    else echo "Could not find '$name' in the Pokedex."
    fi
fi
         