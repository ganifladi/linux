#!/bin/bash

PICSIZE=1920x1080

for PICTURE in *.jpg; do
    if [[ "$PICTURE" == x-*.jpg ]]; then
        echo success;
        # echo $PICTURE has already been resized;
    else
        # echo fail;
        convert $PICTURE -resize $PICSIZE x-$PICTURE;
    fi
done

for VIDEO in *.mp4; do
    if [[ "$VIDEO" == x-*.mp4 ]]; then
        echo success;
        # echo $VIDEO has already been resized;
    else
        # echo fail;
        ffmpeg -i $VIDEO -acodec copy -vcodec libx264 -crf 40 "x-${VIDEO}"
    fi
done
