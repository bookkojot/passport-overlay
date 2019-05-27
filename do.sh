# Define here your options!

TEXT="Какой-то текст"
POINTSIZE=38
BORDERS=50
FINALSIZE="1200x1200"

# Warning! All data in this directory will erased!!!
OUTDIR="marked"

# Don't touch... If you want

OVERLAY=overlay.bmp

echo Creating base wall
convert -pointsize $POINTSIZE label:"$TEXT" -bordercolor white -border ${BORDERS}x${BORDERS} pic1.bmp
convert pic1.bmp -crop 50%x100% pic2.bmp
convert pic1.bmp -gravity west pic2-1.bmp -composite -gravity east pic2-0.bmp -composite pic3.bmp
montage -tile 1x -geometry +0+0 pic1.bmp pic3.bmp test5.bmp
montage -tile 5x -geometry +0+0 test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp test5.bmp tiles.bmp
echo "Warping tiles..."
for q in {1..15}; do
echo "Warping $q of 15"
convert tiles.bmp -wave $((1+($RANDOM%3)))x$((120+($RANDOM%200))) -rotate 22 -trim tiles2.bmp
mv tiles2.bmp tiles.bmp
done

echo "Making final overlay"
convert tiles.bmp -unsharp 10x10 -resize 50% -gravity center -crop "$FINALSIZE"+0+0 +repage -unsharp 2x2 +level 85%,100% "$OVERLAY"

echo "Removing all data in \"$OUTDIR\""
rm -rf "$OUTDIR" 2> /dev/null
mkdir -p "$OUTDIR" 2> /dev/null

find . -maxdepth 1 | grep -Ei "jpe?g|png|gif"| while read q; do
echo "Processing file $q --> ${OUTDIR}/$q"
convert -alpha copy -size "$FINALSIZE" plasma:fractal "$OVERLAY" -composite -swirl $(($RANDOM%20)) -implode .$(($RANDOM%5)) -wave $((10+$RANDOM%10))x$((300+$RANDOM%200)) -rotate 90 -wave $((10+($RANDOM%10)))x$((300+($RANDOM%200))) -rotate 270 -resize "${FINALSIZE}!" tmp.bmp
convert "$q" -resize "$FINALSIZE" -gravity center -compose multiply tmp.bmp -composite tmp2.bmp
convert tmp2.bmp "$OUTDIR"/"$q"
rm tmp2.bmp
done

