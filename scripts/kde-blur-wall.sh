#!/bin/bash

## Get Wallpaper Path
#DIR=$(cat ~/.config/plasma-org.kde.plasma.desktop-appletsrc | grep "Image" | cut -c14- | tail -n -1)
DIR=$(grep 'Image' ~/.config/plasma-org.kde.plasma.desktop-appletsrc | cut -c 14- | head -n 2 | tail -n 1)
#echo $DIR

# Count slashes in path
SLASHES=$(grep -o "/" <<< "$DIR" | wc -l)

PATHTO=$(echo "$DIR" | cut -d '/' -f -"$SLASHES")

## reverse string; choose the first fiel; reverse again
FILE=$(echo "$DIR" | rev | cut -d '/' -f 1 | rev)
IMAGE=$(echo "$FILE" | rev | cut -d '.' -f 2 | rev)

echo "DIR:    $DIR"
echo "PATHTO: $PATHTO"
echo "FILE:   $FILE"
echo "IMAGE:  $IMAGE"

## check reference file
if [ -f "$PATHTO/.my-sddm-bg-reference/$IMAGE" ]
then
    ## file exists - break!
    echo 'The Login wallpaper <'"$IMAGE"'> already exists!'
    exit 0
fi

## if there is non create reference folder inside wallpaper directory
if [ ! -d "$PATHTO/.my-sddm-bg-reference" ]; then
  echo 'reference folder not found. let me handle that for you.'
  mkdir "$PATHTO/.my-sddm-bg-reference"
fi

## clean up reference folder
rm -rfv "$PATHTO"/.my-sddm-bg-reference/*

## save reference copy in reference dir
touch "$PATHTO"/.my-sddm-bg-reference/"$IMAGE"
echo "reference file created"

## save a work copy in tmp
cp "$DIR" /tmp
cd /tmp


## edit copy and save as new login.jpg with imagemagick ...
convert "$FILE" -level -50%,100%,0.6 \
        -filter Gaussian -resize 20% -define filter:sigma=2.5 -resize 500% \
        -fill white -gravity center \
        "$IMAGE".jpg


cp "$IMAGE".jpg "$PATHTO"/login.jpg


## kde sddm workaround
sudo cp -f "$IMAGE".jpg /usr/share/sddm/themes/breath/login.jpg
## add "source: '/usr/share/sddm/themes/breath/login.jpg'"
## to /usr/share/plasma/look-and-feel/org.kde.name.desktop/contents/splash/Splash.qml

## clean up work copy and edited image
rm -f "$FILE"
rm -f "$IMAGE".jpg


exit 0
