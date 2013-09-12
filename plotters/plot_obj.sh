#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` {folder}"
  file="results/results_obj_300s.txt"
else
   file=$*
fi

if [ -e $file ]
then
    ff=$(basename "$file")
    ff="${ff%.*}"
    folder=$(dirname "$file")
    gnuplot <<EOF
#!/usr/bin/gnuplot
set datafile commentschars "#!%"
set terminal pdf monochrome solid  linewidth 1.5
set output  "$folder/pdf/$ff.pdf"

set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
#set grid xtics lt 0 lw 1 lc rgb "#bbbbbb"
set datafile missing 'NA'

set xtics font "Times-Roman, 12"
set ytics font "Times-Roman, 12"

BP = "#222222"; MIP = "#555555"; SA = "#aaaaaa";
set auto x
set yrange [0:10]
set style data histogram
set style histogram cluster gap 3
set style fill solid border -1
set boxwidth 1
set xtic scale 0
set xlabel "Instances"
set ylabel "Obj"
set autoscale y
#set yrange [*:*] reverse
#set title "Comparaison of results"
set key left top

#plot '$file' every ::15 using 2:xtic(1) ti col fc rgb MIP, ''  every ::15 u 3 ti col fc rgb BP , '' every ::15 u 4 ti col fc rgb SA

EOF

else
    echo "file $file not found";
fi
