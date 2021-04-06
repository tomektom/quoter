#!/bin/bash

#: Simple inspirational quotes. Usage:
#:      quoter                                  – display random quote
#:      quoter day                              - display quote of day
#:      quoter num <int>                        - display quote from this line
#:      quoter config                           - configuration
#:      quoter gui [ day | num <int> | config ] - gui (with kdialog), same as above
#: You can use custom file witch quotes with pattern `author(divider)quote)` for example:
#: René Descartes;Cogito ergo sum

# languages
__lang_pl() {
    echo "langpl"
    displayTitle="Twój cytat"
    unknown="Spotkano nieznany błąd"
    numerr="Błędna liczba"
    null="Nie podano parametru"
    firstRun="Uruchomiono quoter pierwszy raz lub nie znaleziono konfiguracji. Wybierz opcję:\n 1) Zastosuj domyślne ustawienia\n 2) Skonfiguruj quoter"
    configChanged="Zmienono konfigurację"
    chosePath="Podaj pełną ścieżkę do pliku z cytatami"
    choseDivider="Podaj rozdzielacz pól"
    question="Co chcesz zrobić? dostępne opcje:\n 1) Losowy cytat\n 2) Cytat dnia\n 3) Wybrany cytat"
}
__lang_eng() {
    echo "langeng"
    displayTitle="Your quote"
    unknown="Unknown error"
    numerr="Wrong number"
    null="Missing parameter"
    firstRun="You run quoter first time or configuration not found. Choose option:\n 1) Set default settings\n 2) Configure quoter"
    configChanged="Configuration changed"
    chosePath="Enter full path to quotes file"
    choseDivider="Enter field divider"
    question=""
}
__setlang() {
    echo "setlang"
    case "$LANG" in
        pl*) __lang_pl ;;
        *) __lang_eng
    esac
}

# config checking and initial parameters
__firstrun() {
    echo "firstrun"
    touch "$config"
    __display first
    read x
    case "$x" in
        "1") __default ;;
        "2") __configchange
    esac
}

__default() {
    echo "default"
    echo "file=$dir/quotes.csv" >> "$config"
    echo "divider=@" >> "$config"
    echo "$configChanged"
    exit 1
}

__configcheck() {
    echo "configcheck"
    config="$dir/quoter.conf"
    if [[ ! -e "$config" ]]
    then
        __firstrun
    else
        source $config
        # todo check if this config is ok
    fi
    lines=$(wc -l < $file)
}

__configchange() {
    echo "configchange"
    rm -f "$config"
    touch "$config"
    __display chosepath
    read pathToFile
    echo "file=$pathToFile" >> "$config"
    __display chosedivider
    read customDivider
    echo "divider=$customDivider" >> "$config"
    exit 1
}

# quote picker
__getquote() {
    echo "getquote"
    line=$(sed -n "$getline p" "$file")
    author=$(echo "$line" | cut -f1 -d "$divider")
    quote=$(echo "$line" | cut -f2 -d "$divider")
}

# display messages and errors
__display() {
    echo "display"
    case "$1" in
        "interactive") echo "$question" ;;
        "first") echo -e "$firstRun" ;;
        "chosepath") echo "$chosePath" ;;
        "chosedivider") echo "$choseDivider" ;;
        *) echo -e "\n$quote\n\n\t\e[1m$author\e[0m\n"
    esac
}

__displaygui() {
    echo "displaygui"
    kdialog --msgbox "<br><h3 align=justify>$quote</h3><br><h1 align=center>$author</h1><br>" --title "$displayTitle"
}

__error() {
    case "$1" in
        "num") echo -e "$numerr: $secpar" ;;
        "null") echo -e "$null" ;;
        *) echo -e "$unknown"
    esac
    exit 1
}

__errorgui() {
    case "$1" in
        "num") kdialog --error "$numerr: $secpar" ;;
        "null") kdialog --error "$null" ;;
        *) kdialog --error "$unknown"
    esac
    exit 1
}

# cli functions
__help() {
    grep "^#:" "$0" | while read DOC; do printf '%s\n' "${DOC###:}"; done
    exit 1
}

__random() {
    echo "random"
    getline=$((1 + "$RANDOM" % "$lines"))
    __getquote
    case "$1" in
        "1") __displaygui ;;
        *) __display
    esac
}

__number() {
    echo "number"
    if [[ ! "$secpar" =~ ^[0-9]+$ ]]
    then
        case "$1" in
            "1") __errorgui num ;;
            *) __error num
        esac
    fi
    if [[ "$secpar" -ge 1 ]] && [[ "$secpar" -le $lines ]]
    then
        getline="$secpar"
    else
        case "$1" in
            "1") __errorgui num ;;
            *) __error num
        esac
    fi
    __getquote
    case "$1" in
        "1") __displaygui ;;
        *) __display
    esac
}

__day() {
    echo "day"
    getline=$(date +%j)
    __getquote
    case "$1" in
        "1") __displaygui ;;
        *) __display
    esac
}

__config() {
    echo "config"
    __configchange
}


# todo interactive chosing in cli
__interactive() {
    echo "interactive"
    __display interactive
    read answer
    case $answer in
        "help") __help ;;
        "random") __random ;;
        "day") __day ;;
        "number") __number
    esac
    __getquote
    __display
}

# gui functions
__gui() {
    echo "gui"
    case "$secpar" in
        "config") __configui ;;
        "day") __daygui ;;
        "num") __numbergui ;;
        *) __randomgui
    esac
}

__configui() {
    echo "configui"
}

__randomgui() {
    echo "randomgui"
    __random 1
}

__numbergui() {
    echo "numbergui"
    secpar=$thirdpar
    __number 1
}

__daygui() {
    echo "daygui"
    __day 1
}

############################################################
# end of functions, main program

secpar="$2"
thirdpar="$3"
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

__setlang
__configcheck

case "$1" in
    "gui") __gui ;;
    "config") __config ;;
    "day") __day ;;
    "num") __number ;;
    "help") __help ;;
    "int") __interactive ;;
    *) __random
esac
