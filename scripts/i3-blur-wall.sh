#!/bin/bash

BLURBG=/tmp/screen.png

CURRWORKSPACE=$(wmctrl -d | grep '*' | cut -d ' ' -f1)
#echo "Current workspace: $CURRWORKSPACE"

WINDOWS=$(wmctrl -l | cut -d ' ' -f3 | grep $CURRWORKSPACE | wc -l)
#echo "Open windows on workspace$CURRWORKSPACE: $WINDOWS"

WALLPAPER=$(tail -n3 ~/.config/nitrogen/bg-saved.cfg | head -n1 | cut -c6-)
#echo "Current wallpaper path: $WALLPAPER"

function transition {

    # Found on "https://unix.stackexchange.com/questions/382887/wallpaper-slideshow-with-transition-effects"
    # Can anybody think about another solution to fade between blurry/clear wallpaper?!

    local OLD=$1
    local NEW=$2
    local TRANS=/tmp/tansition.png

    convert $OLD -fill black -colorize 50% $TRANS
    feh --bg-fill $TRANS
    convert $NEW -fill black -colorize 50$ $TRANS
    feh --bg-fill $TRANS
    feh --bg-fill $NEW
}

while true; do

    CURRWORKSPACE=$(wmctrl -d | grep '*' | cut -d ' ' -f1)
    WINDOWS=$(wmctrl -l | cut -d ' ' -f3 | grep $CURRWORKSPACE | wc -l)
    WALLPAPER=$(tail -n3 ~/.config/nitrogen/bg-saved.cfg | head -n1 | cut -c6-)

    if (( $WINDOWS > 0 )) || (( $(pidof rofi) > 0 )); then
        if ! [ -f $BLURBG ]; then
            #ffmpeg -i $WALLPAPER -i ~/.local/bin/alphapixel.png -filter_complex "boxblur=7:2,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -vframes 1 $BLURBG -loglevel quiet
            convert $WALLPAPER -blur 24,12 $BLURBG
        fi
        #$(transition $WALLPAPER $BLURBG)
        feh --bg-fill $BLURBG
    else
        if [ -f $BLURBG]; then
            rm $BLURBG
        fi
        #$(transition $BLURBG $WALLPAPER)
        feh --bg-fill $WALLPAPER
    fi

    sleep 0.5
done
