#!/bin/bash
input=$1
excluded=$(wc -l ./output/0_excluded | column -t | cut -d' ' -f1)
tried=$(wc -l ./output/1_tried | column -t | cut -d' ' -f1)
error=$(wc -l ./output/2_error | column -t | cut -d' ' -f1)
exception=$(wc -l ./output/2_exception | column -t | cut -d' ' -f1)
good=$(wc -l ./output/2_good | column -t | cut -d' ' -f1)
errandgood=$((error+good))
s200=$(grep -P '^200' ./output/2_good | wc -l | column -t | cut -d' ' -f1)
s200xml=$(grep -P '^200.*\t.*\t.*xml.*$' ./output/2_good | wc -l | column -t | cut -d' ' -f1)
s200xmlu=$(grep -P '^200.*\t.*\t.*xml.*$' ./output/2_good | sort -u | wc -l | column -t | cut -d' ' -f1)

ex_and_tri=$((excluded + tried))
res=$((error + exception + good))

wc -l ./output/*

echo "lines read   " $ex_and_tri " ≠ " $input "($((input - ex_and_tri)))" "($(echo $ex_and_tri/$input*100 | bc -lq | xargs printf %.2f))"
echo "lines written" $res " ≠ " $input "($((input - res)))" "($(echo $res/$input*100 | bc -lq | xargs printf %.2f))"
echo "good:   ($(echo $good/$errandgood*100 | bc -lq | xargs printf %.2f))%"
echo "errors: ($(echo $error/$errandgood*100 | bc -lq | xargs printf %.2f))%"
echo
echo $s200 "HTTP200"
echo $s200xml "HTTP200 + XML"
echo $s200xmlu "HTTP200 + XML | unique"
echo
ss -s

./4_usage.sh
