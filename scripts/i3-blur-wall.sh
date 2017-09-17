#!/bin/bash

CURRWORKSPACE=$(wmctrl -d | grep '*' | cut -d ' ' -f1)
#echo "Current workspace: $CURRWORKSPACE"

WINDOWS=$(wmctrl -l | cut -d ' ' -f3 | grep $CURRWORKSPACE | wc -l)
#echo "Open windows on workspace$CURRWORKSPACE: $WINDOWS"

CURRWALLPAPER=$(tail -n1 ~/.fehbg | cut -d "'" -f2)
#echo "Wallpaper path: $CURRWALLPAPER"

ORIGINAL=/tmp/original-bg
echo $CURRWALLPAPER > $ORIGINAL

COPYBG=/tmp/copied-bg
cp $(cat $ORIGINAL) $COPYBG

BLURBG=/tmp/blured-bg


function blurify {
    convert $1 -blur 24,12 $2
}

function transinit {

    local i="0"

    if ! [ -d /tmp/transition-bg ]; then
        mkdir /tmp/transition-bg
    fi

    while [ $i -lt "10" ]; do
        A=$(echo "($i + 1) * 2.4" | bc -l)
        B=$(echo "($i + 1) * 1.2" | bc -l)
        convert $COPYBG -blur $A,$B /tmp/transition-bg/trans-$i
        echo $i
        i=$[$i+1]
    done
}

function transition {

    local j="0"

    while [ $j -lt "10" ]; do
        feh --bg-fill /tmp/transition-bg/trans-$j
        echo $j
        j=$[$j+1]
        sleep 0.01
    done
}

function transition_rev {

    local j="9"

    while [ $j -ge "0" ]; do
        feh --bg-fill /tmp/transition-bg/trans-$j
        echo $j
        j=$[$j-1]
        sleep 0.01
    done

    feh --bg-fill $(cat $ORIGINAL)
}

#$(blurify $COPYBG $BLURBG)
transinit

while true; do

    CURRWORKSPACE=$(wmctrl -d | grep '*' | cut -d ' ' -f1)
    WINDOWS=$(wmctrl -l | cut -d ' ' -f3 | grep $CURRWORKSPACE | wc -l)
    CURRWALLPAPER=$(tail -n1 ~/.fehbg | cut -d "'" -f2)

    if [[ $WINDOWS > 0 ]] || [[ $(pidof rofi) > 0 ]]; then
#        if [ "$CURRWALLPAPER" != "$BLURBG" ]; then
        if [ "$CURRWALLPAPER" != "/tmp/transition-bg/trans-9" ]; then
            if [ "$CURRWALLPAPER" != "$(cat $ORIGINAL)" ]; then
                echo $CURRWALLPAPER > $ORIGINAL
                cp $(cat $ORIGINAL) $COPYBG
                echo $(cat $ORIGINAL)
                #$(blurify $COPYBG $BLURBG)
                transinit
            fi
            #feh --bg-fill $BLURBG
            transition
        fi
    else
        if [ "$CURRWALLPAPER" != "$(cat $ORIGINAL)" ]; then
            #feh --bg-fill $(cat $ORIGINAL)
            transition_rev
        fi
    fi

    sleep 0.5
done
