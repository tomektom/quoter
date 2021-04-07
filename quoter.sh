#!/bin/bash

# Default help
#eng: Simple inspirational quotes. Usage:
#eng:   quoter                                      – display random quote
#eng:   quoter help                                 - display help
#eng:   quoter day                                  - display quote of day
#eng:   quoter num [ <int> ]                        - display quote from this line
#eng:   quoter config                               - configuration
#eng:   quoter int                                  - interactive mode
#eng:   quoter gui [ day | num [ <int> ] | config ] - gui (with kdialog)
#eng: You can use custom file witch quotes with pattern `author(divider)quote)`, example:
#eng: René Descartes;Cogito ergo sum

# Polski help
#pl: Proste inspirujące cytaty. Instrukcja:
#pl:    quoter                                      - wyświetl losowy cytat
#pl:    quoter help                                 - wyświetl pomoc
#pl:    quoter day                                  - wyświetl cytat dnia
#pl:    quoter num [ <int> ]                        - wyświetl cytat z podanej linii
#pl:    quoter int                                  - tryb interaktywny
#pl:    quoter config                               - konfiguracja
#pl:    quoter gui [ day | num [ <int> ] | config ] - gui (z wykorzystaniem kdialog) 
#pl: Możesz wykorzystać własny plik z cytatami według wzoru 'autor(rozdzielacz)cytat', przykład:
#pl: René Descartes;Cogito ergo sum


###################################################################
# languages
###################################################################

__lang_pl() {
    quoterTitle="Quoter"
    langHelp="#pl:"
    displayTitle="Twój cytat"
    unknown="Spotkano nieznany błąd"
    numerr="Błędna liczba"
    null="Nie podano parametru"
    firstRun="Uruchomiono quoter pierwszy raz lub nie znaleziono konfiguracji. Wybierz opcję:\n 1) Zastosuj domyślne ustawienia\n 2) Skonfiguruj quoter"
    firstRunGUI="Uruchomiono quoter pierwszy raz lub nie znaleziono konfiguracji. Wybierz opcję:"
    configChanged="Zmienono konfigurację"
    chosePath="Podaj pełną ścieżkę do pliku z cytatami"
    choseDivider="Podaj rozdzielacz pól"
    question="Co chcesz zrobić? Dostępne opcje:\n 1) Losowy cytat\n 2) Cytat dnia\n 3) Wybrany cytat\n 4) Zakończ"
    chosePathGUI="Wybierz plik z cytatami"
    configurationTextTitle="Konfiguracja"
    choseOption="Wybierz opcję:"
    choiceDefault="Zastosuj domyślne ustawienia"
    choiceConfiguration="Wybierz własną konfigurację"
    iWantNumber="Wprowadź wartość z zakresu od 1 do"
    quoteChoser="Wybór cytatu"
    randomChoice="Losowy cytat"
    dayChoice="Cytat dnia"
    numberChoice="Wybrany cytat"
    configChoice="Skonfiguruj Quoter"
    cancelled="Anulowano operację"
    wrongPathError="Podano błędną ścieżkę"
    
}
__lang_eng() {
    quoterTitle="Quoter"
    langHelp="#eng:"
    displayTitle="Your quote"
    unknown="Unknown error"
    numerr="Wrong number"
    null="Missing parameter"
    firstRun="You run quoter first time or configuration not found. Choose option:\n 1) Set default settings\n 2) Configure quoter"
    firstRunGUI="You run quoter first time or configuration not found. Choose option:"
    configChanged="Configuration changed"
    chosePath="Enter full path to quotes file"
    choseDivider="Enter field divider"
    question="What you want do? Available options:\n 1) Random quote\n 2) Quote of the day\n 3) Selected quote\n 4) Exit"
    chosePathGUI="Choose file with quotes"
    configurationTextTitle="Configuration"
    choseOption="Choose option:"
    choiceDefault="Apply default settings"
    choiceConfiguration="Choose own configuration"
    iWantNumber="Enter number from 1 to"
    quoteChoser="Choose quote"
    randomChoice="Random quote"
    dayChoice="Quote of the day"
    numberChoice="Selected quote"
    configChoice="Configure Quoter"
    cancelled="Operation cancelled"
    wrongPathError="Entered wrong path"
}
__setlang() {
    case "$LANG" in
        pl*) __lang_pl ;;
        *) __lang_eng
    esac
}
###################################################################
# config manipulations
###################################################################

__firstrun() {
    touch "$config"
    __display first
    read x
    case "$x" in
        "1") __default ;;
        "2") __configcli
    esac
}

__firstrungui() {
    touch "$config"
    __displaygui first
    __iscancelledrm
    case "$choice" in
        "default") __default 1 ;;
        "custom") __configui ;;
        *) exit 1
    esac
}

__default() {
    echo "fileQuotes=$dir/quotes.csv" >> "$config"
    echo "divider=@" >> "$config"
    case $1 in
        "1") __displaygui configchanged ;;
        *) __display configchanged
    esac
    exit 0
}

__configcheck() {
    if [[ ! -e "$config" ]]
    then
        case "$firstpar" in
            "gui") __firstrungui ;;
            *) __firstrun
        esac
    else
        source "$config"
        # todo check if this config is ok
    fi
    lines=$(wc -l < "$fileQuotes")
}

__configchanger() {
    rm -f "$config"
    touch "$config"
    echo "fileQuotes=$pathToFile" >> "$config"
    echo "divider=$customDivider" >> "$config"
}

###################################################################
# display messages, errors and help
###################################################################

__display() {
    case "$1" in
        "interactive") echo -e "$question" ;;
        "first") echo -e "$firstRun" ;;
        "chosepath") echo "$chosePath" ;;
        "chosedivider") echo "$choseDivider" ;;
        "configchanged") echo "$configChanged" ; exit 0 ;;
        "iwantnum") echo "$iWantNumber $lines:" ;;
        *) echo -e "\n$quote\n\n\t\e[1m$author\e[0m\n" ; exit 0
    esac
}

__displaygui() {
    case "$1" in
        "interactive") answer=$(kdialog --title "$quoterTitle" --menu "$choseOption" "1" "$randomChoice" "2" "$dayChoice" "3" "$numberChoice" "4" "$configChoice") ;;
        "first") choice=$(kdialog --menu "$firstRunGUI" "default" "$choiceDefault" "custom" "$choiceConfiguration") ;;
        "chosepath") pathToFile=$(kdialog --title "$chosePathGUI" --getopenfilename "$HOME") ;;
        "chosedivider") customDivider=$(kdialog --title "$configurationTextTitle" --inputbox "$choseDivider" "") ;;
        "configchanged") kdialog --title "$quoterTitle" --msgbox "$configChanged" ; exit 0 ;;
        "iwantnum") secpar=$(kdialog --title "$quoteChoser" --inputbox "$iWantNumber $lines:" "1");;
        *) kdialog --msgbox "<br><h3 align=justify>$quote</h3><br><h1 align=center>$author</h1><br>" --title "$displayTitle" ; exit 0
    esac
}

__error() {
    case "$1" in
        "num") echo -e "$numerr: $secpar" ;;
        "null") echo -e "$null" ;;
        "wrongpath") echo "$wrongPathError" ;;
        *) echo -e "$unknown"
    esac
    exit 1
}

__errorgui() {
    case "$1" in
        "num") kdialog --title "$quoterTitle" --error "$numerr: $secpar" ;;
        "null") kdialog --title "$quoterTitle" --error "$null" ;;
        "cancel") kdialog --title "$quoterTitle" --error "$cancelled" ;;
        *) kdialog --title "$quoterTitle" --error "$unknown"
    esac
    exit 1
}

__help() {
    grep "^$langHelp" "$0" | while read DOC; do printf '%s\n' "${DOC##$langHelp}"; done
    exit 0
}

###################################################################
# core functions
###################################################################

# quote picker
__getquote() {
    line=$(sed -n "$getline p" "$fileQuotes")
    author=$(echo "$line" | cut -f1 -d "$divider")
    quote=$(echo "$line" | cut -f2 -d "$divider")
}

# todo naprawić
__number() {
    case $firstpar in
        "gui") __iwantnumgui ;;
        *) __iwantnumcli
    esac
    if [[ ! "$secpar" =~ ^[0-9]+$ ]]
    then
        case "$firstpar" in
            "gui") __errorgui num ;;
            *) __error num
        esac
    fi
    if [[ "$secpar" -ge 1 ]] && [[ "$secpar" -le $lines ]]
    then
        getline="$secpar"
    else
        case "$firstpar" in
            "gui") __errorgui num ;;
            *) __error num
        esac
    fi
    __getquote
}

__day() {
    getline=$(date +%j)
    __getquote
}

__random() {
    getline=$((1 + "$RANDOM" % "$lines"))
    __getquote
}

###################################################################
# cli functions
###################################################################

__configcli() {
    __display chosepath
    read pathToFile
    if [[ ! -r pathToFile ]]
    then
        if [[ -z $(cat $config) ]]
        then
            rm -f "$config"
        fi
        __error wrongpath
    fi
    __display chosedivider
    read customDivider
    __configchanger
    __display configchanged
}

__randomcli() {
    __random
    __display
}

__numbercli() {
#    if [[ ! $secpar ]]
#    then
#        __display iwantnum
#        read secpar
#    fi
    __number
    __display
}

__iwantnumcli() {
    if [[ ! $secpar ]]
    then
        __display iwantnum
        read secpar
    fi
}

__daycli() {
    __day
    __display
}

__interactivecli() {
    __display interactive
    read answer
    case $answer in
        "1") __random ;;
        "2") __day ;;
        "3") __number ;;
        "4") exit 0
    esac
    __display
}

###################################################################
# gui functions
###################################################################

__iscancelled() {
    if [[ $? = 1 ]]
    then
        __errorgui cancel
    fi
}

__iscancelledrm() {
    if [[ $? = 1 ]]
    then
        rm -f "$config"
        __errorgui cancel
    fi
}

__gui() {
    case "$secpar" in
        "config") __configui ;;
        "day") __daygui ;;
        "num") __numbergui ;;
        "random") __randomgui ;;
        *) __interactivegui
    esac
}

__configui() {
    __displaygui chosepath
    __iscancelledrm
    __displaygui chosedivider
    __iscancelledrm
    __configchanger
    __displaygui configchanged
}

__interactivegui() {
    __displaygui interactive
    case $answer in
        "1") __random ;;
        "2") __day ;;
        "3") __number ;;
        "4") __configui ;;
        *) exit 0
    esac
    __displaygui
}

__randomgui() {
    __random
    __displaygui
}

__numbergui() {
#    if [[ $thirdpar ]]
#    then
#        secpar=$thirdpar
#    else
#        __displaygui iwantnum
#        __iscancelled
#    fi
    __number
    __displaygui
}

__iwantnumgui() {
    if [[ $thirdpar ]]
    then
        secpar=$thirdpar
    else
        __displaygui iwantnum
        __iscancelled
    fi
}

__daygui() {
    __day
    __displaygui
}

###################################################################
# end functions, main program
###################################################################

firstpar="$1"
secpar="$2"
thirdpar="$3"
dir="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"  # full path to directory where is placed this script
config="$dir/quoter.conf"

__setlang
__configcheck

case "$firstpar" in
    "gui") __gui ;;
    "config") __configcli ;;
    "day") __daycli ;;
    "num") __numbercli ;;
    "help") __help ;;
    "int") __interactivecli ;;
    *) __randomcli
esac

# todo add alias .bashrc/.zshrc
# todo add desktop file
# todo inne gui jeśli nie ma kdialog: zenity, yad
