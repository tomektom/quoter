#!/bin/bash

#: Simple inspirational quotes. Usage:
#:      quoter                                  – display random quote
#:      quoter day                              - display quote of day
#:      quoter number                           - display quote from this line
#:      quoter config                           - configuration
#:      quoter gui [ day | number | config ]    - gui (with kdialog), same as above
#: You can use custom file witch quotes with pattern `author(divider)quote)` for example:
#: René Descartes;Cogito ergo sum

# languages
__lang_pl() {
    echo "langpl"
    displaytitle="Twój cytat"
    unknown="Spotkano nieznany błąd"
    numerr="Błędna liczba"
    null="Nie podano parametru"
    quest="Co chcesz zrobić?"
}
__lang_eng() {
    echo "langeng"
    displaytitle="Your quote"
    unknown="Unknown error"
    numerr="Wrong number"
    null="Not given parameter"
    quest="What you want do?"
}
__setlang() {
    case "$LANG" in
        pl*) __lang_pl ;;
        *) __lang_eng
    esac
}

# config checking and initial parameters
__configcheck() {
    echo "configcheck"
    config="$HOME/.config/quoter.conf"
    if [[ ! -e "$config" ]]
    then
        echo "brak configu"
    else
        echo "config istnieje"
    fi
    file="/home/tomek/Git/quoter/quotes.csv"
    divider="@"
    lines=$(wc -l < $file)
}

__configchange() {
    echo "configchange"
}

# quote picker
__getquote() {
    echo "getquote"
    line=$(sed -n "$getline p" "$file")
    author=$(echo "$line" | cut -f1 -d "$divider")
    quote=$(echo "$line" | cut -f2 -d "$divider")
}

# functions for display messages
__display() {
    echo "display"
    case "$0" in
        "quest") echo "$quest" ;;
        *) echo -e "\n$quote\n\n\t\e[1m$author\e[0m\n"
    esac
}

__displaygui() {
    echo "displaygui"
    kdialog --msgbox "<br><h3 align=justify>$quote</h3><br><h1 align=center>$author</h1><br>" --title "$displaytitle"
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
}


# unfinished
__interactive() {
    echo "interactive"
    __display quest
    read quest
    case $quest in
        "help") __help ;;
        "random") __random
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
