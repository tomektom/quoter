#!/bin/bash

# Default help
#eng: Simple inspirational quotes. Usage:
#eng:   quoter                                                         – display random quote
#eng:   quoter help                                                    - display help
#eng:   quoter day                                                     - display quote of day
#eng:   quoter num [ <int> ]                                           - display quote from this line
#eng:   quoter config                                                  - configuration
#eng:   quoter int                                                     - interactive mode
#eng:   quoter walk [ <int> <step> ]                                   - walk mode
#eng:   quoter add                                                     - add quote
#eng:   quoter loop [ random | num | int ]                             - quoter in loop
#eng:   quoter gui [ random | day | num [ <int> ] | config | add ]     - gui (with kdialog)
#eng:   quoter gui walk [ <int> <step> ]                               - walk mode gui
#eng:   quoter loop gui [ num | random ]                               - gui in loop
#eng: You can use custom file witch quotes with pattern `author(divider)quote`, example:
#eng: René Descartes;Cogito ergo sum

# Polski help
#pl: Proste inspirujące cytaty. Instrukcja:
#pl:    quoter                                                       - wyświetl losowy cytat
#pl:    quoter help                                                  - wyświetl pomoc
#pl:    quoter day                                                   - wyświetl cytat dnia
#pl:    quoter num [ <int> ]                                         - wyświetl cytat z podanej linii
#pl:    quoter config                                                - konfiguracja
#pl:    quoter int                                                   - tryb interaktywny
#pl:    quoter walk [ <int> <step> ]                                 - tryb spacerowy
#pl:    quoter add                                                   - dodaj cytat
#pl:    quoter loop [ random | num | int ]                           - quoter w pętli
#pl:    quoter gui [ random | day | num [ <int> ] | config | add]    - gui (z wykorzystaniem kdialog)
#pl:    quoter gui walk [ <int> <step> ]                             - tryb spacerowy gui
#pl:    quoter loop gui [ num | random ]                             - gui w pętli
#pl: Możesz wykorzystać własny plik z cytatami według wzoru 'autor(rozdzielacz)cytat', przykład:
#pl: René Descartes;Cogito ergo sum


###################################################################
# languages
###################################################################

__lang_pl() {
  quoterTitle="Quoter"
  langHelp="#pl:"
  unknown="Spotkano nieznany błąd"
  numerr="Błędna liczba"
  null="Nie podano parametru"
  firstRun="Uruchomiono quoter pierwszy raz lub nie znaleziono konfiguracji. Wybierz opcję:\n 1) Zastosuj domyślne ustawienia\n 2) Skonfiguruj quoter"
  firstRunGUI="Uruchomiono quoter pierwszy raz lub nie znaleziono konfiguracji. Wybierz opcję:"
  configChanged="Zmieniono konfigurację"
  chosePath="Podaj pełną ścieżkę do pliku z cytatami"
  choseDivider="Podaj rozdzielacz pól"
  question="Co chcesz zrobić? Dostępne opcje:\n 1) Losowy cytat\n 2) Cytat dnia\n 3) Wybrany cytat\n 4) Dodaj cytat\n 5) Zakończ"
  questionNoLoop="Co chcesz zrobić? Dostępne opcje:\n 1) Losowy cytat\n 2) Cytat dnia\n 3) Wybrany cytat\n 4) Tryb spacerowy\n 5) Dodaj cytat\n 6) Zakończ"
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
  walkChoice="Tryb spacerowy"
  cancelled="Anulowano operację"
  wrongPathError="Podano błędną ścieżkę"
  aliasQuestion="Czy dodać alias do .bashrc i .zshrc?"
  desktopFileAsk="Czy chcesz utworzyć plik .desktop dla Quoter?"
  desktopFileAskList="Jaką komendę ma wywoływać plik quoter.desktop?\n 1) quoter gui\n 2) quoter gui random\n 3) quoter gui num\n 4) quoter gui day\n 5) quoter loop gui\n 6) quoter loop gui random\n 7) quoter loop gui num"
  whereGoDesktop="Gdzie umieścić plik?\n 1) na pulpicie\n 2) w menu aplikacji\n 3) w obu miejscach"
  desktopFileAskGUI="Jaką komendę ma wywoływać plik quoter.desktop?"
  whereGoDesktopGUI="Gdzie umieścić plik?"
  desktopFolder="Na pulpicie"
  menuApp="W menu aplikacji"
  bothGo="W obu miejscach"
  handlerQuestion="Czy dodać handler dla 'command not found'?"
  chooseStep="Wybierz co który cytat ma być wyświetlany:"
  gimmeAuthorAsk="Podaj autora cytatu:"
  gimmeQuoteAsk="Podaj cytat:"  
  thisIsEmpty="Nie dodano cytatu, musisz podać autora i cytat."
  nextAddAsk="Czy chcesz dodać kolejny cytat?"
}
__lang_eng() {
  quoterTitle="Quoter"
  langHelp="#eng:"
  unknown="Unknown error"
  numerr="Wrong number"
  null="Missing parameter"
  firstRun="You run quoter first time or configuration not found. Choose option:\n 1) Set default settings\n 2) Configure quoter"
  firstRunGUI="You run quoter first time or configuration not found. Choose option:"
  configChanged="Configuration changed"
  chosePath="Enter full path to quotes file"
  choseDivider="Enter field divider"
  question="What you want do? Available options:\n 1) Random quote\n 2) Quote of the day\n 3) Selected quote\n 4) Add quote\n 5) Exit"
  questionNoLoop="What you want do? Available options:\n 1) Random quote\n 2) Quote of the day\n 3) Selected quote\n 4) Walk mode\n 5) Add quote\n 6) Exit"
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
  walkChoice="Walk mode"
  cancelled="Operation cancelled"
  wrongPathError="Entered wrong path"
  aliasQuestion="Do you want alias in .bashrc and .zshrc?"
  desktopFileAsk="Do you want create .desktop file for Quoter?"
  desktopFileAskList="Which command should invoke quoter.desktop?\n 1) quoter gui\n 2) quoter gui random\n 3) quoter gui num\n 4) quoter gui day\n 5) quoter loop gui\n 6) quoter loop gui random\n 7) quoter loop gui num"
  whereGoDesktop="Where place this file?\n 1) on desktop\n 2) in app menu\n 3) in both places"
  desktopFileAskGUI="Which command should invoke quoter.desktop?"
  whereGoDesktopGUI="Where place this file?"
  desktopFolder="On desktop"
  menuApp="In app menu"
  bothGo="In both places"
  handlerQuestion="Do you want handler for 'command not found'?"
  chooseStep="Choose step for quotes:"
  gimmeAuthorAsk="Author:"
  gimmeQuoteAsk="Quote:"
  thisIsEmpty="No quote has been added, you need to give author and quote."
  nextAddAsk="Do you want add anothe quote?"
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
#  echo "firstrun"
  __help
  __display first
  read x
  case "$x" in
    "1") __default ;;
    "2") __configcli
  esac
}

__firstrungui() {
#  echo "firstrungui"
  __displaygui first
  __iscancelled
  case "$choice" in
    "default") __default 1 ;;
    "custom") __configui ;;
    *) exit 1
  esac
}

__default() {
#  echo "default"
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
#  echo "configcheck"
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
#  echo "configchanger"
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
    "gimmeauthor") echo "$gimmeAuthorAsk" ;;
    "gimmequote") echo "$gimmeQuoteAsk" ;;
    "empty") echo "$thisIsEmpty" ;;
    "nextaddask") echo "$nextAddAsk" ;;
    "iwantstep") echo "$chooseStep" ;;
    "handlerquestion") echo "$handlerQuestion" ;;
    "desktopfileask") echo -e "$desktopFileAsk" ;;
    "desktopfile") echo -e "$desktopFileAskList" ;;
    "wheregodesktopfile") echo -e "$whereGoDesktop" ;;
    "aliasquestion") echo -e "$aliasQuestion" ;;
    "interactive") echo -e "$question" ;;
    "interactivenoloop") echo -e "$questionNoLoop" ;;
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
    "gimmeauthor") gimmeAuthor=$(kdialog --title "$quoterTitle" --inputbox "$gimmeAuthorAsk") ; button=$? ;;
    "gimmequote") gimmeQuote=$(kdialog --title "$quoterTitle" --inputbox "$gimmeQuoteAsk") ; button=$? ;;
    "empty") kdialog --title "$quoterTitle" --sorry "$thisIsEmpty" ; button=$? ;;
    "nextaddask") kdialog --title "$quoterTitle" --yesno "$nextAddAsk" ; button=$? ;;
    "iwantstep") step=$(kdialog --title "$quoterTitle" --inputbox "$chooseStep" "1") ; button=$? ;;
    "handlerquestion") kdialog --title "$quoterTitle" --yesno "$handlerQuestion" ; button=$? ;;
    "wheregodesktopfile") answer2=$(kdialog --title "$quoterTitle" --menu "$whereGoDesktopGUI" 1 "$desktopFolder" 2 "$menuApp" 3 "$bothGo") ; button=$? ;;
    "desktopfile") answer1=$(kdialog --title "$quoterTitle" --menu "$desktopFileAskGUI" 1 "quoter gui" 2 "quoter gui random" 3 "quoter gui num" 4 "quoter gui day" 5 "quoter loop gui" 6 "quoter loop gui random" 7 "quoter loop gui num") ; button=$? ;;
    "aliasquestion") kdialog --yesno "$aliasQuestion" ; button=$? ;; 
    "interactive") answer=$(kdialog --title "$quoterTitle" --menu "$choseOption" "1" "$randomChoice" "2" "$dayChoice" "3" "$numberChoice" "4" "$configChoice") ; button=$? ;;
    "interactivenoloop") answer=$(kdialog --title "$quoterTitle" --menu "$choseOption" "1" "$randomChoice" "2" "$dayChoice" "3" "$numberChoice" "4" "$walkChoice" "5" "$configChoice") ; button=$? ;;        
    "first") choice=$(kdialog --menu "$firstRunGUI" "default" "$choiceDefault" "custom" "$choiceConfiguration") ; button=$? ;;
    "chosepath") pathToFile=$(kdialog --title "$chosePathGUI" --getopenfilename "$HOME") ; button=$? ;;
    "chosedivider") customDivider=$(kdialog --title "$configurationTextTitle" --inputbox "$choseDivider" "") ; button=$? ;;
    "configchanged") kdialog --title "$quoterTitle" --msgbox "$configChanged" ; button=$? ; exit 0 ;;
    "iwantnum") yournumber=$(kdialog --title "$quoteChoser" --inputbox "$iWantNumber $lines:" "1") ; button=$? ;;
    *) kdialog --msgbox "<br><h3 align=justify>$quote</h3><br><h1 align=center>$author</h1><br>" --title "$quoterTitle" ; button=$?
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
#  echo "getquote"
  line=$(sed -n "$getline p" "$fileQuotes")
  author=$(echo "$line" | cut -f1 -d "$divider")
  quote=$(echo "$line" | cut -f2 -d "$divider")
}

__number() {
#  echo "number"
  getline="$yournumber"
  __getquote
  if [[ $firstpar = "loop" ]]
  then
    unset yournumber
  fi
}

__day() {
#  echo "day"
  numberofday=$(date +%j)
  if [[ $(($(date +%Y)%4)) = 0 ]]
  then
    daysinyear=366
  else
    daysinyear=365
  fi
  if [[ "$lines" -gt "$daysinyear" ]]
  then
    x="$numberofday"
    i=1
    while [[ $x -lt $((lines-daysinyear)) ]]
    do
      x=$((x+daysinyear))
      i=$((i+1))
    done
    if [[ $i -ge 2 ]]
    then
      param=$((0 + "$RANDOM" % "$i"))
    else
      param=0
    fi
    getline=$((param*daysinyear+numberofday))
  else
    getline=$numberofday
  fi  
  __getquote
}

__random() {
#  echo "random"
  getline=$((1 + "$RANDOM" % "$lines"))
  __getquote
}

###################################################################
# cli functions
###################################################################

__configcli() {
#  echo "configcli"
  __display chosepath
  read pathToFile
  if [[ -r pathToFile ]]
  then
    __error wrongpath
  fi
  __display chosedivider
  read customDivider
  __configchanger
  youralias="alias quoter='bash $workdir/quoter.sh'"
  grep -q "$youralias" "$HOME/.zshrc" &> /dev/null
  var1=$?
  grep -q "$youralias" "$HOME/.bashrc" &> /dev/null
  var2=$?
  if [[ $var1 -ge 1 ]] || [[ $var2 -ge 1 ]]
  then
    __display aliasquestion
    read -p "[y/N]: " answer
    if [[ $answer = "y" ]]
    then
      __addalias
    fi
  fi
  grep -q "$workdir/quoter-handler" "$HOME/.zshrc" &> /dev/null
  var1=$?
  grep -q "$workdir/quoter-handler" "$HOME/.bashrc" &> /dev/null
  var2=$?
  if [[ $var1 -ge 1 ]] || [[ $var2 -ge 1 ]]
  then
    __display handlerquestion
    read -p "[y/N]: " answer
    if [[ $answer = "y" ]]
    then
      __addhandler
    fi
  fi
  __display desktopfileask
  read -p "[y/N]: " answer
  if [[ $answer = "y" ]]
  then
    __display desktopfile
    read answer1
    if [[ $answer1 -ge 1 ]] && [[ $answer1 -le 7 ]]
    then
      __display wheregodesktopfile
      read answer2
      __createdesktopfile
    fi
  fi
  __display configchanged
}

__randomcli() {
#  echo "randomcli"
  __random
  __display
  __isloop
}

__numbercli() {
#  echo "numbercli"
  if [[ $firstpar = "loop" ]]
  then
    __iwantnumcli
  elif [[ ! $secpar ]]
  then
    __iwantnumcli
  else
    yournumber="$secpar"
  fi
  __numbercheckcli
  __number
  __display
  __isloop
}

__iwantnumcli() {
  __display iwantnum
  read yournumber
}

__numbercheckcli() {
  if [[ ! "$yournumber" =~ ^[0-9]+$ ]]
  then
    __error num
  elif [[ "$yournumber" -lt 1 ]] || [[ "$yournumber" -gt $lines ]]
  then
    __error num
  fi
}

__daycli() {
#  echo "daycli"
  if [[ $(date +%j) -gt $lines ]]
  then
    __error
  fi
  __day
  __display
}

__interactivecli() {
#  echo "interactivecli"
  if [[ $firstpar = "loop" ]]
  then
    __display interactive
    read answer
    case $answer in
      "1") __random ;;
      "2") __day ;;
      "3") __iwantnumcli
        __numbercheckcli # todo noexit
        __number ;;
      "4") __addquotecli ;;
      "5") exit 0
    esac
    if [[ $answer != "4" ]]
    then
      __display
    fi
  else
    __display interactivenoloop
    read answer
    case $answer in
      "1") __random ;;
      "2") __day ;;
      "3") __iwantnumcli
          __numbercheckcli # todo noexit
          __number ;;
      "4") __walkcli ;;
      "5") __addquotecli ;;
      "6") exit 0
    esac
    if [[ $answer != "5" ]]
    then
      __display
    fi
    exit 0
  fi
}

__walkcli() { # todo sprawdzanie poprawności
  if [[ ! $secpar ]]
  then
    __iwantnumcli
    __display iwantstep
    read step
  elif [[ ! $thirdpar ]]
  then
    yournumber=$secpar
      step=1
  else
    yournumber=$secpar
    step=$thirdpar
  fi
  __numbercheckcli
  until [[ $yournumber -gt $lines ]]
  do
    __number
    __display
    yournumber=$(($yournumber+$step))
    __youwantexitcli
  done
  exit 0
}

###################################################################
# gui functions
###################################################################

__gui() {
#  echo "gui"
  case "$secpar" in
    "config") __configui ;;
    "day") __daygui ;;
    "num") __numbergui ;;
    "random") __randomgui ;;
    "walk") __walkgui ;;
    "add") __addquotegui ;;
    *) __interactivegui
  esac
}

__configui() {
#  echo "configui"
  __displaygui chosepath
  __iscancelled cancel
  __displaygui chosedivider
  __iscancelled cancel
  __configchanger

  youralias="alias quoter='bash $workdir/quoter.sh'"
  grep -q "$youralias" "$HOME/.zshrc" &> /dev/null
  var1=$?
  grep -q "$youralias" "$HOME/.bashrc" &> /dev/null
  var2=$?
  if [[ $var1 -ge 1 ]] || [[ $var2 -ge 1 ]]
  then
    __displaygui aliasquestion
    if [[ $button = 0 ]]
    then
      __addalias
    fi
  fi
  grep -q "$workdir/quoter-handler" "$HOME/.zshrc" &> /dev/null
  var1=$?
  grep -q "$workdir/quoter-handler" "$HOME/.bashrc" &> /dev/null
  var2=$?
  if [[ $var1 -ge 1 ]] || [[ $var2 -ge 1 ]]
  then
    __displaygui handlerquestion
    if [[ $button = 0 ]]
    then
      __addhandler
    fi
  fi

  __displaygui desktopfile
  if [[ $button = 0 ]]
  then
    __displaygui wheregodesktopfile
    __createdesktopfile
  fi
  __displaygui configchanged
}

__numbercheckgui() {
  if [[ ! "$yournumber" =~ ^[0-9]+$ ]]
  then
    __errorgui num
  elif [[ "$yournumber" -lt 1 ]] || [[ "$yournumber" -gt $lines ]]
  then
    __errorgui num
  fi
}

__interactivegui() {
#  echo "interactivegui"
  if [[ $firstpar = "loop" ]]
  then
    __displaygui interactive
    case $answer in
      "1") __random ;;
      "2") __day ;;
      "3") __displaygui iwantnum
          __isclosed
          __numbercheckgui
          __number ;;
      "4") __configui ;;
      *) exit 0
    esac
    if [[ $answer != "5" ]]
    then
      __displaygui
      __isclosed
    fi
  else
    __displaygui interactivenoloop
    case $answer in
      "1") __random ;;
      "2") __day ;;
      "3") __displaygui iwantnum
          __isclosed
          __numbercheckgui
          __number ;;
      "4") __walkgui ;;
      "5") __configui ;;
      *) exit 0
    esac
    if [[ $answer != "6" ]]
    then
      __displaygui
      __isclosed
    fi
  fi
    
}

__randomgui() {
#  echo "randomgui"
  __random
  __displaygui
  __isclosed
}

__numbergui() {
#  echo "numbergui"
  if [[ $thirdpar ]] && [[ ! $firstpar = "loop" ]]
  then
    yournumber=$thirdpar
  else
    __displaygui iwantnum
    __iscancelled
  fi
  if [[ ! "$yournumber" =~ ^[0-9]+$ ]]
  then
    __errorgui num
  elif [[ "$yournumber" -lt 1 ]] || [[ "$yournumber" -gt $lines ]]
  then
    __errorgui num
  fi
  __number
  __displaygui
  __isclosed
}

__daygui() {
#  echo "daygui"
  if [[ $(date +%j) -gt $lines ]]
  then
    __errorgui
  fi
  __day
  __displaygui
  __isclosed
}

__walkgui() { # todo sprawdzanie poprawności
  if [[ ! $thirdpar ]]
  then
    __displaygui iwantnum
    __displaygui iwantstep
  elif [[ ! $fourthpar ]]
  then
    yournumber=$thirdpar
    step=1
  else
    yournumber=$thirdpar
    step=$fourthpar
  fi
  __numbercheckcli
  until [[ $yournumber -gt $lines ]]
  do
    __number
    __displaygui
    yournumber=$(($yournumber+$step))
    __isclosed
  done
  exit 0
}

###################################################################
# button checkers
###################################################################

__iscancelled() {
#  echo "iscancelled"
  if [[ $button = 1 ]]
  then
    if [[ $1 = "cancel" ]]
    then
      __errorgui cancel
    elif [[ $firstpar = "loop" ]]
    then
      break
    else
      exit 0
    fi
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
#  echo "loop"
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
#  echo "loopgui"
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
#  echo "isloop"
  if [[ ! $firstpar = "loop" ]]
  then
    exit 0
  else
    __youwantexitcli
  fi
}

__youwantexitcli() {
  read x
  if [[ $x = "q" ]] || [[ $x = "quit" ]] || [[ $x = "exit" ]]
  then
    exit 0
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
        windowpid=$(xdotool getactivewindow getwindowpid)
        windowpidname=$(ps -p "$windowpid" -o comm=)
        if [[ $windowpidname = $playerapp ]]
        then
          exit 0
        fi
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
  if [[ -e $HOME/.zshrc ]]
  then
    echo "$youralias" >> "$HOME"/.zshrc
  fi
  if [[ -e $HOME/.bashrc ]]
  then
    echo "$youralias" >> "$HOME"/.bashrc
  fi
}

# add quoter-handler to .zshrc and .bashrc
__addhandler() {
  if [[ -e $HOME/.zshrc ]]
  then
    echo "if [ -f $workdir/quoter-handler ]; then" >> "$HOME"/.zshrc
    echo "    . $workdir/quoter-handler" >> "$HOME"/.zshrc
    echo "fi" >> "$HOME"/.zshrc
  fi
  if [[ -e $HOME/.bashrc ]]
  then
    echo "if [ -f $workdir/quoter-handler ]; then" >> "$HOME"/.bashrc
    echo "    . $workdir/quoter-handler" >> "$HOME"/.bashrc
    echo "fi" >> "$HOME"/.bashrc
  fi
}

# creating desktop file
__createdesktopfile() {
  template="$workdir/template.desktop"
  desktopfile="$workdir/quoter.desktop"
  cp -f "$template" "$desktopfile"
  case $answer1 in
    "1") echo "Exec=$workdir/quoter.sh gui" >> $desktopfile ;;
    "2") echo "Exec=$workdir/quoter.sh gui random" >> $desktopfile ;;
    "3") echo "Exec=$workdir/quoter.sh gui num" >> $desktopfile ;;
    "4") echo "Exec=$workdir/quoter.sh gui day" >> $desktopfile ;;
    "5") echo "Exec=$workdir/quoter.sh loop gui" >> $desktopfile ;;
    "6") echo "Exec=$workdir/quoter.sh loop gui random" >> $desktopfile ;;
    "7") echo "Exec=$workdir/quoter.sh loop gui num" >> $desktopfile
  esac
  test -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs # get user xdg directories
  case $answer2 in
    "1") cp -f -s "$desktopfile" "${XDG_DESKTOP_DIR:-$HOME/Desktop}" ;;
    "2") cp -f -s "$desktopfile" "$HOME/.local/share/applications/" ;;
    "3") cp -f -s "$desktopfile" "${XDG_DESKTOP_DIR:-$HOME/Desktop}" ; cp -f -s "$desktopfile" "$HOME/.local/share/applications/"
  esac           
}

###################################################################
# functions for adding and removing quotes
###################################################################

__addquote() {
    echo "$gimmeAuthor$divider$gimmeQuote" >> $fileQuotes
}

__addquotecli() {
  __display gimmeauthor
  read gimmeAuthor
  __display gimmequote
  read gimmeQuote
  if [[ -n "$gimmeAuthor" ]] && [[ -n "$gimmeQuote" ]]
  then
    __addquote
  else
    __display empty
  fi
  __display nextaddask
  read -p "[Y/n]: " x
  if [[ $x = "n" ]] || [[ $x = "N" ]]
  then
    if [[ $firstpar != "loop" ]]
    then
      exit 0
    fi
  else
    __addquotecli
  fi
}

__addquotegui() {
  while [[ 0 = 0 ]]
  do
    __displaygui gimmeauthor
    __iscancelled
    __displaygui gimmequote
    __iscancelled
    if [[ -n "$gimmeAuthor" ]] && [[ -n "$gimmeQuote" ]]
    then
      __addquote
    else
      __displaygui empty
    fi
    __displaygui nextaddask
    __iscancelled
  done
}

###################################################################
# end functions, main program
###################################################################

firstpar="$1"
secpar="$2"
thirdpar="$3"
fourthpar="$4"
workdir="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"  # full path to directory where is placed this script
config="$workdir/quoter.conf"

#__isvideoplayed
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
  "walk") __walkcli ;;
  "add") __addquotecli ;;
  *) __randomcli
esac

exit 0

# Todo dodawanie własnych cytatów z poziomu programu i usuwanie ich
# todo dodać add do interactive i loop

__removequote() {
  echo "todo"
  sed '$removenumber d' $fileQuotes # todo znaleźć sposób, d musi być razem
}

"removenumberask") echo "$removeNumberAsk" ;;
"areyousure") echo "$areYouSure" ;;
"nextremoveask") echo "$nextRemoveAsk" ;;

removeNumberAsk=""
areYouSure=""
nextRemoveAsk=""

removeNumberAsk=""
areYouSure=""
nextRemoveAsk=""

__removequotecli() {
  __display removenumberask
  read removenumber
  yournumber="$removenumber"
  __number
  __display
  __display areyousure
  read -p "[y/N]: " x
  if [[ $x = "y" ]] || [[ $x = "Y" ]]
  then
    __removequote
  fi
  __display nextremoveask
  read -p "[y/N]: " x
  if [[ $x = "y" ]] || [[ $x = "Y" ]]
  then
    __removequotecli
  fi
}

__removequotegui() {
  echo "todo"
  __displaygui removenumberask
  yournumber="$removenumber"
  __number
  __displaygui
  __display areyousure
  # magia
  __displaygui nextremoveask
  # magia
}
