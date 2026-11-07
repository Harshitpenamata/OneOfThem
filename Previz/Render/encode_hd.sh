#!/bin/bash
# Muxes each MRQ JPEG sequence with its full mix into an HD H.264 movie, then joins them into the reel.
# encode_hd.sh <version e.g. v001> <reel version e.g. v010>
V=${1:-v001}; RV=${2:-v010}
P=/a/MovieProjects/OneOfThem; OUT=$P/Previz/Renders/HD; mkdir -p $OUT; : > $OUT/concat.txt
for pair in 01:SQ01_TheWarning 02:SQ02_TheRoad 03:SQ03_Pass1_Refusal 04:SQ04_Pass2_Bargaining 05:SQ05_Pass3_WrongName 06:SQ06_Pass4_Faithful 07:SQ07_TheReturn; do
  n=${pair%%:*}; s=${pair#*:}; dir=$P/Saved/MovieRenders/OOT_$s
  first=$(ls $dir | head -1 | sed -E 's/.*\.([0-9]+)\.jpeg/\1/')
  ffmpeg -y -loglevel error -framerate 24 -start_number $((10#$first)) -i "$dir/OOT_$s.%05d.jpeg" -i $P/Previz/Sound/SQ${n}_full_mix.wav \
    -map 0:v -map 1:a -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k -shortest -movflags +faststart "$OUT/OOT_${s}_HD_$V.mp4"
  echo "file 'OOT_${s}_HD_$V.mp4'" >> $OUT/concat.txt
  echo "$s $(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT/OOT_${s}_HD_$V.mp4")"
done
ffmpeg -y -loglevel error -f concat -safe 0 -i $OUT/concat.txt -c copy -movflags +faststart "$OUT/OOT_Reel_SQ01-SQ07_HD_$RV.mp4"
echo "reel $(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT/OOT_Reel_SQ01-SQ07_HD_$RV.mp4")"
