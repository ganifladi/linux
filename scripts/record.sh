#!/bin/bash

ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+0,0 $1.mp4
