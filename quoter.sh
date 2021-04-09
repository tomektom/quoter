#!/bin/bash

# Default help
#eng: Simple inspirational quotes. Usage:
#eng:   quoter                                                  – display random quote
#eng:   quoter help                                             - display help
#eng:   quoter day                                              - display quote of day
#eng:   quoter num [ <int> ]                                    - display quote from this line
#eng:   quoter config                                           - configuration
#eng:   quoter int                                              - interactive mode
#eng:   quoter loop [ random | num | int ]                      - quoter in loop
#eng:   quoter gui [ random | day | num [ <int> ] | config ]    - gui (with kdialog)
#eng: You can use custom file witch quotes with pattern `author(divider)quote)`, example:
#eng: René Descartes;Cogito ergo sum

# Polski help
#pl: Proste inspirujące cytaty. Instrukcja:
#pl:    quoter                                                  - wyświetl losowy cytat
#pl:    quoter help                                             - wyświetl pomoc
#pl:    quoter day                                              - wyświetl cytat dnia
#pl:    quoter num [ <int> ]                                    - wyświetl cytat z podanej linii
#pl:    quoter config                                           - konfiguracja
#pl:    quoter int                                              - tryb interaktywny
#pl:    quoter loop random | num | int ]                        - quoter w pętli
#pl:    quoter gui [ random | day | num [ <int> ] | config ]    - gui (z wykorzystaniem kdialog) 
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
    configChanged="Zmieniono konfigurację"
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
#    echo "firstrun"
    __help
    touch "$config"
    __display first
    read x
    case "$x" in
        "1") __default ;;
        "2") __configcli
    esac
}

__firstrungui() {
#    echo "firstrungui"
    __displaygui first
    __iscancelled
    case "$choice" in
        "default") __default 1 ;;
        "custom") __configui ;;
        *) exit 1
    esac
}

__default() {
#    echo "default"
    rm -f "$config"
    touch "$config"
    echo "fileQuotes=$dir/quotes.csv" >> "$config"
    echo "divider=@" >> "$config"
    case $1 in
        "1") __displaygui configchanged ;;
        *) __display configchanged
    esac
    exit 0
}

__configcheck() {
#    echo "configcheck"
    if [[ ! -e "$config" ]]
    then
        if [[ $firstpar = "gui" ]] || [[ $secpar = "gui" ]]
        then
            __firstrungui
        else
            __firstrun
        fi
    else
        source "$config"
        if [[ -r $pathToFile ]]
        then
            if [[ $firstpar = "gui" ]] || [[ $secpar = "gui" ]]
            then
                __errorgui
            else
                __error
            fi
        fi
    fi
    lines=$(wc -l < "$fileQuotes")
}

__configchanger() {
#    echo "configchanger"
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
        "first") echo -e "\n$firstRun" ;;
        "chosepath") echo "$chosePath" ;;
        "chosedivider") echo "$choseDivider" ;;
        "configchanged") echo "$configChanged" ; exit 0 ;;
        "iwantnum") echo "$iWantNumber $lines:" ;;
        *) echo -e "\n$quote\n\n\t\e[1m$author\e[0m\n"
    esac
}

__displaygui() {
    case "$1" in
        "interactive") answer=$(kdialog --title "$quoterTitle" --menu "$choseOption" "1" "$randomChoice" "2" "$dayChoice" "3" "$numberChoice" "4" "$configChoice") ; button=$? ;;
        "first") choice=$(kdialog --menu "$firstRunGUI" "default" "$choiceDefault" "custom" "$choiceConfiguration") ; button=$? ;;
        "chosepath") pathToFile=$(kdialog --title "$chosePathGUI" --getopenfilename "$HOME") ; button=$? ;;
        "chosedivider") customDivider=$(kdialog --title "$configurationTextTitle" --inputbox "$choseDivider" "") ; button=$? ;;
        "configchanged") kdialog --title "$quoterTitle" --msgbox "$configChanged" ; button=$? ; exit 0 ;;
        "iwantnum") yournumber=$(kdialog --title "$quoteChoser" --inputbox "$iWantNumber $lines:" "1") ; button=$? ;;
        *) kdialog --msgbox "<br><h3 align=justify>$quote</h3><br><h1 align=center>$author</h1><br>" --title "$displayTitle" ; button=$?
    esac
}

__error() {
    case "$1" in
        "num") echo -e "$numerr: $yournumber" ;;
        "null") echo -e "$null" ;;
        "wrongpath") echo "$wrongPathError" ;;
        *) echo -e "$unknown"
    esac
    exit 1
}

__errorgui() {
    case "$1" in
        "num") kdialog --title "$quoterTitle" --error "$numerr: $yournumber" ;;
        "null") kdialog --title "$quoterTitle" --error "$null" ;;
        "cancel") kdialog --title "$quoterTitle" --error "$cancelled" ;;
        *) kdialog --title "$quoterTitle" --error "$unknown"
    esac
    exit 1
}

__help() {
    grep "^$langHelp" "$0" | while read DOC; do printf '%s\n' "${DOC##$langHelp}"; done
}

###################################################################
# core functions
###################################################################

# quote picker
__getquote() {
#    echo "getquote"
    line=$(sed -n "$getline p" "$fileQuotes")
    author=$(echo "$line" | cut -f1 -d "$divider")
    quote=$(echo "$line" | cut -f2 -d "$divider")
}

__number() {
#    echo "number"
    if [[ $firstpar = "gui" ]] || [[ $secpar = "gui" ]]
    then
        __iwantnumgui
    else
        __iwantnumcli
    fi
    if [[ ! "$yournumber" =~ ^[0-9]+$ ]]
    then
        if [[ $firstpar = "gui" ]] || [[ $secpar = "gui" ]]
        then
            __errorgui num
        else
            __error num
        fi
    fi
    if [[ "$yournumber" -ge 1 ]] && [[ "$yournumber" -le $lines ]]
    then
        getline="$yournumber"
    else
        if [[ $firstpar = "gui" ]] || [[ $secpar = "gui" ]]
        then
            __errorgui num
        else
            __error num
        fi
    fi
    __getquote
    if [[ $firstpar = "loop" ]]
    then
        unset yournumber
    fi
}

__day() {
#    echo "day"
    getline=$(date +%j)
    __getquote
}

__random() {
#    echo "random"
    getline=$((1 + "$RANDOM" % "$lines"))
    __getquote
}

###################################################################
# cli functions
###################################################################

__configcli() {
#    echo "configcli"
    __display chosepath
    read pathToFile
    if [[ ! -r pathToFile ]]
    then
        __error wrongpath
    fi
    __display chosedivider
    read customDivider
    __configchanger
    __display configchanged
}

__randomcli() {
#    echo "randomcli"
    __random
    __display
    __isloop
}

__numbercli() {
    echo "numbercli"
    __number
    __display
    __isloop
}

__iwantnumcli() {
#    echo "iwantnumcli"
    if [[ ! $yournumber ]]
    then
        __display iwantnum
        read yournumber
    fi
}

__daycli() {
#    echo "daycli"
    __day
    __display
}

__interactivecli() {
#    echo "interactivecli"
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

__gui() {
#    echo "gui"
    case "$secpar" in
        "config") __configui ;;
        "day") __daygui ;;
        "num") __numbergui ;;
        "random") __randomgui ;;
        *) __interactivegui
    esac
}

__configui() {
#    echo "configui"
    __displaygui chosepath
    __iscancelled cancel
    __displaygui chosedivider
    __iscancelled cancel
    __configchanger
    __displaygui configchanged
}

__interactivegui() {
#    echo "interactivegui"
    __displaygui interactive
    case $answer in
        "1") __random ;;
        "2") __day ;;
        "3") __number ;;
        "4") __configui ;;
        *) exit 0
    esac
    __displaygui
    __isclosed
}

__randomgui() {
#    echo "randomgui"
    __random
    __displaygui
    __isclosed
}

__numbergui() {
#    echo "numbergui"
    __number
    __displaygui
    __isclosed
}

__iwantnumgui() {
#    echo "iwantnumgui"
    if [[ $thirdpar ]] && [[ ! $firstpar = "loop" ]] # experimental, not tested
#    if [[ $thirdpar ]]
    then
        yournumber=$thirdpar
    else
        __displaygui iwantnum
        __iscancelled
    fi
}

__daygui() {
#    echo "daygui"
    __day
    __displaygui
    __isclosed
}

###################################################################
# button checkers
###################################################################

__iscancelled() {
#    echo "iscancelled"
    if [[ $button = 1 ]]
    then
        case $1 in
            "cancel") __errorgui cancel ;;
            *) exit 0
        esac
    fi
}

__isclosed() {
#    echo "isclosed"
    if [[ $button = 1 ]] || [[ $button = 2 ]]
    then
        exit 0
    fi
}


###################################################################
# loop functions
###################################################################

__loop() {
#    echo "loop"
    while [ 0 = 0 ]
    do
    case $secpar in
        "random") __randomcli ;;
        "num") __numbercli ;;
        "int") __interactivecli ;;
        "gui") __loopgui ;;
        *) exit 1
    esac
    done
}

__loopgui() {
#    echo "loopgui"
    while [ 0 = 0 ]
    do
    case $thirdpar in
        "random") __randomgui ;;
        "num") __numbergui ;;
        *) __interactivegui
    esac
    done
}

__isloop() {
#    echo "isloop"
    if [[ ! $firstpar = "loop" ]]
    then
        exit 0
    else
        read x
        if [[ $x = "q" ]] || [[ $x = "quit" ]] || [[ $x = "exit" ]]
        then
            exit 0
        fi
    fi
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
    "help") __help ; exit 0 ;;
    "int") __interactivecli ;;
    "loop") __loop ;;
    *) __randomcli
esac


# todo add alias .bashrc/.zshrc
# todo inne gui jeśli nie ma kdialog: zenity, yad

# todo add desktop file, notatki:
# template="$dir/template.desktop"
# robienie rzeczy
# cp "$dir/quoter.desktop" "$HOME/.local/share/applications/"

# todo dla loop gui sprawdzanie czy player jest odtwarzany – może osobna komenda, wygoda przy aplikacjach typu ktimer
# notatki:
# pacmd list-sink-inputs
# jak wykryje to patrz parametr "state" – running odtwarzane, corked zapauzowane
# filtrowanie po "application.process.binary" – żeby sprawdzić czy wideo czy muzyka?

# sprawdzenie czy player jest na full screen w przeglądarce
# qdbus org.kde.plasma.browser_integration /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Fullscreen
# czy się odtwarza 
# qdbus org.kde.plasma.browser_integration /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus
# jeśli tak to wziąć tytuł aktywnego okna
# xdotool getactivewindow getwindowname
# i przefiltrować

# state=$(pacmd list-sink-inputs| grep -i "state: running")
# if [[ $state ]]
# then
#    sprawdzenie application.process.binary
#    jeśli proces należy do vlc (lub innego video playera) to zamknąć, a jeśli do przeglądarki to dalej sprawdzić tytuł okna
#    xdotool getactivewindow getwindowname
#    stąd wziąć nazwę karty w której coś jest odtwarzane
#    qdbus org.mpris.MediaPlayer2.firefox.instance159357 /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata
#    i porównać
#    exit
# fi
