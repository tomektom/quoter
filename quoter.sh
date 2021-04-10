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
#eng:   quoter loop gui [ num | random ]                        - gui in loop
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
#pl:    quoter loop [ random | num | int ]                      - quoter w pętli
#pl:    quoter gui [ random | day | num [ <int> ] | config ]    - gui (z wykorzystaniem kdialog)
#pl:    quoter loop gui [ num | random ]                        - gui w pętli
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
    aliasQuestion="Czy dodać alias do .bashrc i .zshrc?"    
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
    aliasQuestion="Do you want alias in .bashrc and .zshrc?"
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
    echo "fileQuotes=$workdir/quotes.csv" >> "$config"
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
        "aliasquestion") echo "$aliasQuestion" ;;
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
        "aliasquestion") kdialog --yesno "$aliasQuestion" ; button=$? ;; 
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
    __display aliasquestion
    if [[ $answer = y ]]
    then
        __addalias
    fi
    # todo desktop file
    __display configchanged
}

__randomcli() {
#    echo "randomcli"
    __random
    __display
    __isloop
}

__numbercli() {
#    echo "numbercli"
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
    __displaygui aliasquestion
    if [[ $button = 0 ]]
    then
        __addalias
    fi
    # todo desktop file
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
    if [[ $thirdpar ]] && [[ ! $firstpar = "loop" ]]
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
# special functions
###################################################################

# checking if video is played in active firefox tab, useful when added to ktimer or similar  app
__isvideoplayed() {
    if ! command -v pacmd &> /dev/null && ! command -v xdotool &> /dev/null # checking if commands exists
    then
        exit 0
    fi
    isplayingcount=$(pacmd list-sink-inputs | grep -i -c "state: running")
    ispaused=$(pacmd list-sink-inputs | grep -i "state: corked")
    if [[ $isplayingcount ]]
    then
        if [[ $isplayingcount -ge 2 ]] || [[ $ispaused ]]
        then
            exit 0
        else
            playerapp=$(pacmd list-sink-inputs | grep -i "application.process.binary" | cut -f2 -d '"')
            if [[ "$playerapp" = "vlc" ]] || [[ $playerapp = "vivaldi-bin" ]]
            then
                exit 0
            elif [[ "$playerapp" = "firefox" ]]
            then
                firefoxpid=$(pacmd list-sink-inputs | grep -i "application.process.id" | cut -f2 -d '"')
                
                if ! command -v qdbus &> /dev/null
                then
                    playingtitle=$(gdbus introspect --session --dest org.mpris.MediaPlayer2.firefox.instance"$firefoxpid" --object-path /org/mpris/MediaPlayer2 | grep title | cut -f3 -d "<" | cut -f1 -d ">")
                    playingtitle=${playingtitle%?} # remove last character
                else
                    playingtitle=$(qdbus org.mpris.MediaPlayer2.firefox.instance"$firefoxpid" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | grep "title" | cut -f3 -d ":")
                fi
                playingtitle=${playingtitle#?} # remove first character
                playingtitle=$(echo "$playingtitle" | tr -s " ")
                currentwindow=$(xdotool getactivewindow getwindowname)
                comparethis=$(xdotool getactivewindow getwindowname | grep "$playingtitle")
                if [[ "$comparethis" = "$currentwindow" ]]
                then
                    exit 0
                fi
            fi
        fi
    fi
}

# add aliases to .zshrc and .bashrc
__addalias() {
    youralias="alias quoter='bash $workdir/quoter.sh'"
    if [[ -e $HOME/.zshrc ]]
    then
        x=$(grep "$youralias" "$HOME"/.zshrc)
        if [[ ! $x ]]
        then
            echo "$youralias" >> "$HOME"/.zshrc
        fi
    fi
    if [[ -e $HOME/.bashrc ]]
    then
        x=$(grep "$youralias" "$HOME"/.bashrc)
        if [[ ! $x ]]
        then
            echo "$youralias" >> "$HOME"/.bashrc
        fi
    fi
}

###################################################################
# end functions, main program
###################################################################

firstpar="$1"
secpar="$2"
thirdpar="$3"
workdir="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"  # full path to directory where is placed this script
config="$workdir/quoter.conf"

__isvideoplayed
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

# todo add desktop file, notatki:
# template="$workdir/template.desktop"
# robienie rzeczy
# cp "$workdir/quoter.desktop" "$HOME/.local/share/applications/"

# todo jak w bash-insulter, cytaty przy błędnym poleceniu, raczej jako osobny plik
