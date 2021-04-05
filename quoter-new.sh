#!/bin/bash

__configcheck() {
    echo "Not implemented"
}

__help() {
    echo "Not implemented"
}

__random() {
    echo "Not implemented"
}

__number() {
    echo "Not implemented"
}

__day() {
    echo "Not implemented"
}

__config() {
    echo "Not implemented"
}

__gui() {
    echo "Not implemented"
    case "$2" in
        "config") __configui ;;
        "day") __daygui ;;
        "number") __numbergui ;;
        *) __randomgui
        esac
        
}

__configui() {
    echo "Not implemented"
}

__randomgui() {
    echo "Not implemented"
}

__numbergui() {
    echo "Not implemented"
}

__daygui() {
    echo "Not implemented"
}

__configcheck
case "$1" in
    "gui") __gui ;;
    "config") __config ;;
    "day") __day ;;
    "number") __number ;;
    "help") __help ;;
    *) __random
esac
