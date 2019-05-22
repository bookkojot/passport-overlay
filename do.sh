TEXT="Какой-то текст";

convert -pointsize 70 label:"$TEXT" -bordercolor white -border 20x20 pic1.bmp
convert pic1.bmp -crop 50%x100% pic2.bmp
convert pic1.bmp -gravity west pic2-1.bmp -composite -gravity east pic2-0.bmp -composite pic3.bmp
montage -tile 1x -geometry +0+0 pic1.bmp pic3.bmp test5.png
montage -tile 5x -geometry +0+0 test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png test5.png tiles.png
convert tiles.png tiles.bmp
for q in {1..15}; do
echo Warping $q
convert tiles.bmp -wave $((1+($RANDOM%3)))x$((120+($RANDOM%200))) -rotate 22 -trim tiles2.bmp
mv tiles2.bmp tiles.bmp
done

convert tiles.bmp -unsharp 10x10 -resize 50% -gravity center -crop 1000x1000+0+0 +repage overlay.png

OVERLAY=overlay.png
mkdir marked
rm marked/*
for q in *jpg; do
echo "processing $q"
convert -alpha copy -size 1000x1000 plasma:fractal "$OVERLAY" -composite -swirl $(($RANDOM%20)) -implode .$(($RANDOM%5)) -wave $((10+$RANDOM%10))x$((300+$RANDOM%200)) -rotate 90 -wave $((10+($RANDOM%10)))x$((300+($RANDOM%200))) -rotate 270 -resize "1000x1000!" tmp.bmp
convert "$q" -resize 1000x1000 -gravity center -compose multiply tmp.bmp -composite tmp2.bmp
convert tmp2.bmp marked/"$q"

done

