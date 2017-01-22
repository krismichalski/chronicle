#!/bin/bash

WALLPAPERS=()
RANDOM_INDEX=$(rand -M 20)
POST_COUNT=0
RATING="questionableless"
IDS=()

# Create a bash array for all the arguments passed to this script

i=0
argv=()
for arg in "$@"; do
    argv[$i]="$arg"
    i=$((i + 1))
done

i=0
while test $i -lt $# ; do

    arg="${argv[$i]}"

    case "$arg" in

        -so|--safe-only) i=$((i + 1)); RATING="safe";;

        -qo|--questionable-only) i=$((i + 1)); RATING="questionable";;

        -eo|--explicit-only) i=$((i + 1)); RATING="explicit";;

        -qe|--questionable-explicit) i=$((i + 1)); RATING="questionableplus";;

        -qs|--questionable-safe ) i=$((i + 1)); RATING="questionableless";;


        *) if ! test -d "$arg" ; then
            error "Unknown argument '$arg'"
        fi;;

    esac

    i=$((i + 1))

done

read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
    local RET=$?
    TAG_NAME=${ENTITY%% *}
    ATTRIBUTES=${ENTITY#* }
    return $RET
}

parse_dom () {
    if [[ $TAG_NAME = "post" ]] ; then
        eval local "${ATTRIBUTES%?}"
        WALLPAPERS+=($jpeg_url)
        IDS+=($id)
    elif [[ $TAG_NAME = "posts" ]]; then
      eval local $ATTRIBUTES
      POST_COUNT=($count)
    fi
}

echo "Loading wallpapers index..."

while read_dom; do
    parse_dom
done < <(wget -O- -q http://konachan.com/post.xml?tags=%20width:1280..%20height:768..%20rating:$RATING\&limit=1)

AMOUNT_OF_PAGES=$(expr $POST_COUNT / 20)
RANDOM_PAGE=$(rand -M $AMOUNT_OF_PAGES)

echo "Choosing random wallpapers page..."

while read_dom; do
    parse_dom
done < <(wget -O- -q http://konachan.com/post.xml?page=$RANDOM_PAGE\&limit=20\&tags=%20width:1280..%20height:768..%20rating:$RATING)

echo "Removing cache..."

rm ~/Pictures/Wallpapers/BashRandom/*.*

echo "Downloading random wallpaper..."

wget -P ~/Pictures/Wallpapers/BashRandom/ ${WALLPAPERS[$RANDOM_INDEX]}

WALLPAPER=$(find ~/Pictures/Wallpapers/BashRandom/ -maxdepth 1 -type f -name "Konachan.com - ${IDS[$RANDOM_INDEX]} *")

echo "Settings wallpaper..."

gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"