#!/bin/bash

CURRWORKSPACE=$(wmctrl -d | grep '*' | cut -d ' ' -f1)
#echo "Current workspace: $CURRWORKSPACE"

WINDOWS=$(wmctrl -l | cut -d ' ' -f3 | grep $CURRWORKSPACE | wc -l)
#echo "Open windows on workspace$CURRWORKSPACE: $WINDOWS"

CURRWALLPAPER=$(tail -n1 ~/.fehbg | cut -d "'" -f2)
#echo "Wallpaper path: $WALLPAPER"

ORIGINAL=/tmp/original-bg
echo $CURRWALLPAPER > $ORIGINAL

COPYBG=/tmp/copied-bg
cp $(cat $ORIGINAL) $COPYBG

BLURBG=/tmp/blured-bg


function blurify {
    convert $1 -blur 24,12 $2
}

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


$(blurify $COPYBG $BLURBG)

while true; do

    CURRWORKSPACE=$(wmctrl -d | grep '*' | cut -d ' ' -f1)
    WINDOWS=$(wmctrl -l | cut -d ' ' -f3 | grep $CURRWORKSPACE | wc -l)
    CURRWALLPAPER=$(tail -n1 ~/.fehbg | cut -d "'" -f2)

    if [[ $WINDOWS > 0 ]] || [[ $(pidof rofi) > 0 ]]; then
        if [ "$CURRWALLPAPER" != "$BLURBG" ]; then
            if [ "$CURRWALLPAPER" != "$(cat $ORIGINAL)" ]; then
                echo $CURRWALLPAPER > $ORIGINAL
                cp $(cat $ORIGINAL) $COPYBG
                $(blurify $COPYBG $BLURBG)
            fi
            feh --bg-fill $BLURBG
        fi
    else
        if [ "$CURRWALLPAPER" != "$(cat $ORIGINAL)" ]; then
            feh --bg-fill $(cat $ORIGINAL)
        fi
    fi

    sleep 0.5
done
