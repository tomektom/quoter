#!/bin/bash

# Simple inspirational quotes. Usage:
# quoter  – display random quote
# quoter day  - display quote of day
# quoter number   - display quote from this line
# quoter config   - configuration
# quoter gui [ day | number | config ] - gui (with kdialog), same as above

config="$HOME/.config/quoter.conf"

if [[ ! -s "$config" ]] || [[ $1 = "config" ]] || [[ $2 = "config" ]]
then
    if [[ -e "$config" ]]
    then
        rm -f "$config"
        touch "$config"
    else
        touch "$config"
    fi
    if [[ $1 = "gui" ]] || [[ $2 = "config" ]]
    then
        kdialog --title "Wybierz plik z cytatami" --getopenfilename "$HOME" > "$config"
        kdialog --inputbox "Podaj rozdzielacz pól:" "@" --title "Konfiguracja" >> "$config"
    elif [[ $2 = "config" ]] || [[ -z $2 ]]
    then
        echo "Podaj ścieżkę do pliku z cytatami:"
        read text
        echo $text > $config
        echo "Podaj rozdzielacz pól: "
        read text
        echo $text >> $config
    fi
    exit 1
fi

file=$(sed -n 1p "$config")
lines=$(cat $file | wc -l)
divider=$(sed -n 2p "$config")

if [ "$1" = "gui" ]
then
    gui=true
    if [[ -z $2 ]]
    then
        choice=$(kdialog --radiolist "Wybierz opcję:" 1 "Losowy cytat" on 2 "Cytat dnia" off 3 "Konkretny cytat" off --title "Wybór cytatu")
        case $choice in
            "1") request="random" ;;
            "2") request="day" ;;
            "3") request=$(kdialog --inputbox "Wprowadź wartość z zakresu od 1 do $lines:" "1" --title "Wybór cytatu");;
            *) exit 2
        esac
    else
        request=$2
    fi
else
    gui=false
    request=$1
fi

if [[ $request -ge 1 ]] && [[ $request -le $lines ]]
then
    getline=$request
elif [[ "$request" = "day" ]]
then
    getline=$(date +%j)
else
    getline=$((1 + "$RANDOM" % "$lines"))
fi

line=$(sed -n "$getline p" "$file")

author=$(echo "$line" | cut -f1 -d "$divider")
quote=$(echo "$line" | cut -f2 -d "$divider")

if [ $gui = true ]
then
    kdialog --msgbox "<br><h3 align=justify>$quote</h3><br><h1 align=center>$author</h1><br>" --title "Twój cytat"
else
    echo -e "\n$quote\n\n\t\e[1m$author\e[0m\n"
fi

# todo: collect more inspirational quotes and random for days when number of quotes is above 366, x-366 or modulo operator
