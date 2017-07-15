#!/bin/sh

# Usage for a 720p, 10fps gif:
# gifenc input.mov output.gif 720 10

palette="/tmp/palette.png"
filters="fps=$4,scale=$3:-1:flags=lanczos"

ffmpeg -v warning -i $1 -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $2
