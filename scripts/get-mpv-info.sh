#!/bin/bash

ARTIST=$(ps -u | less | grep 'mpv' | head -n1 | cut -d '-' -f 3- | cut -d ' ' -f 2- | cut -d '-' -f -1)
SONG=$(ps -u | less | grep 'mpv' | head -n1 | cut -d '-' -f 3- | cut -d ' ' -f 2- | cut -d '-' -f -2 | cut -d '-' -f 2- | tail -c +2)

echo -n "$ARTIST - $SONG"
