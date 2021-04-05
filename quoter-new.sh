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
}
__lang_eng() {
    echo "langeng"
    displaytitle="Your quote"
    unknown="Unknown error"
    numerr="Wrong number"
}

# config checking and initial parameters
__configcheck() {
    echo "configcheck"
    file="/home/tomek/Git/quoter/quotes.csv"
    divider="@"
    lines=$(cat $file | wc -l)
}

__getquote() {
    echo "getquote"
    line=$(sed -n "$getline p" "$file")
    author=$(echo "$line" | cut -f1 -d "$divider")
    quote=$(echo "$line" | cut -f2 -d "$divider")
}

__display() {
    echo "display"
    echo -e "\n$quote\n\n\t\e[1m$author\e[0m\n"
}

__displaygui() {
    echo "displaygui"
    kdialog --msgbox "<br><h3 align=justify>$quote</h3><br><h1 align=center>$author</h1><br>" --title "$displaytitle"
}

__error() {
    case "$1" in
        "num") echo -e "$numerr: $secpar" ;;
        *) echo -e "$unknown"
    esac
    exit 1
}

__errorgui() {
    case "$1" in
        "num") kdialog --error "$numerr: $secpar" ;;
        *) kdialog --error "$unknown"
    esac
    exit 1
}

__help() {
    grep "^#:" $0 | while read DOC; do printf '%s\n' "${DOC###:}"; done
    exit
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
    if [[ $(echo "$secpar" | grep ",") = "$secpar" ]] || [[ $(echo "$secpar" | grep ".") = "$secpar" ]]
    then
        case "$1" in
            "1") __errorgui num ;;
            *) __error num
        esac
    elif [[ "$secpar" -ge 1 ]] && [[ "$secpar" -le $lines ]]
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

__gui() {
    echo "gui"
    case "$secpar" in
        "config") __configui ;;
        "day") __daygui ;;
        "number") __numbergui ;;
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

secpar=$2
thirdpar=$3

case "$LANG" in
    pl*) __lang_pl ;;
    *) __lang_eng
esac

__configcheck

case "$1" in
    "gui") __gui ;;
    "config") __config ;;
    "day") __day ;;
    "number") __number ;;
    "help") __help ;;
    *) __random
esac
