# Define here your options!

TEXT="Текст для ватермарки поверх изображения"
POINTSIZE=58
BORDERS=20
INTERMEDIATESIZE="3500x3500"
FINALSIZE="1200x1200"
TRANSPARENT=92%
COLORTRANSPARENT=95%
CONVERTFLAGS="-quality 80"

# Warning! All data in this directory will erased!!!
OUTDIR="marked"

# Don't touch... If you want

OVERLAY1=overlay-`md5sum <<< "options: $TEXT-$POINTSIZE-$BORDERS-$INTERMEDIATESIZE" | cut -d\  -f1`.bmp
OVERLAY2=overlay-`md5sum <<< "options: $OVERLAY1-$FINALSIZE-$TRANSPARENT" | cut -d\  -f1`.bmp

echo "Just warped overlay: $OVERLAY1"
echo "Base overlay: $OVERLAY2"

[ ! -f ${OVERLAY1} ] && (
echo "Creating base wall..."
convert -pointsize $POINTSIZE label:"$TEXT" -bordercolor white -border ${BORDERS}x${BORDERS} pic1.bmp
convert pic1.bmp -crop 50%x100% pic2.bmp
convert pic1.bmp -gravity west pic2-1.bmp -composite -gravity east pic2-0.bmp -composite pic3.bmp
montage -tile 1x -geometry +0+0 pic1.bmp pic3.bmp test5.bmp
convert -colorspace gray -size "$INTERMEDIATESIZE" tile:test5.bmp tiles.bmp
echo "Warping tiles..."
for q in {1..15}; do
echo "Warping $q of 15"
convert -colorspace gray tiles.bmp -wave $((1+($RANDOM%3)))x$((120+($RANDOM%200))) -rotate 22 -trim tiles2.bmp
mv tiles2.bmp tiles.bmp
done

mv tiles.bmp $OVERLAY1
)

[ ! -f ${OVERLAY2} ] && (

echo "Making fractal displace..."
convert -size ${INTERMEDIATESIZE} plasma:fractal -resize 110% -blur 100x20 noise-displace.bmp
echo "Making base overlay..."
convert "$OVERLAY1" -gravity center noise-displace.bmp -compose Displace -define compose:args=50x50 -composite -unsharp 10x10 -resize 50% +repage -unsharp 2x2 +level "$TRANSPARENT",100% "$OVERLAY2"
)

echo "Removing all data in \"$OUTDIR\""
rm -rf "$OUTDIR" 2> /dev/null
mkdir -p "$OUTDIR" 2> /dev/null

find . -maxdepth 1 | grep -Ei "jpe?g|png|gif"| while read q; do
echo "Processing file $q --> ${OUTDIR}/$q"
convert -gravity center -alpha copy -size "${FINALSIZE}" plasma:fractal \( "$OVERLAY2" -swirl $(($RANDOM%20)) -implode .$(($RANDOM%5)) -wave $((10+$RANDOM%10))x$((300+$RANDOM%200)) -rotate 90 -wave $((10+($RANDOM%10)))x$((300+($RANDOM%200))) -rotate 270 \)  -composite tmp.bmp
convert "$q" -resize "${FINALSIZE}>" -gravity center -compose multiply tmp.bmp -composite \( -size ${FINALSIZE} plasma:fractal -blur 100x10 +level ${COLORTRANSPARENT},100% \) -composite tmp2.bmp
convert tmp2.bmp $CONVERTFLAGS "${OUTDIR}/${q}"
rm tmp2.bmp
done

