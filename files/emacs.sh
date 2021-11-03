#!/bin/bash

emacsclient -n -e "(> (length (frame-list)) 1)" | grep -q t
if [ "$?" = "1" ]; then
    emacsclient -c -n -a "" "$@"
else
    emacsclient -n -a "" "$@"
fi
