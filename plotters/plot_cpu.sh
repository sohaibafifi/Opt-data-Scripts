#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` {folder}"
  file="results/results_cpu_TravelTime.txt"
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
set style line 1 pt 4 lw 2 ps 0.6 lt rgb "#000000"
set style line 2 pt 11 lw 2 ps 0.6 lt rgb "#555555"
set datafile commentschars "#!%"
set terminal pdf monochrome solid font 'Helvetica,14'  linewidth 1.5
set output  "$folder/pdf/$ff.pdf"
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"

set xtics font "Times-Roman, 12"
set ytics font "Times-Roman, 12"
set yrange [*:3610]
set ytics 600
set datafile missing 'NA'

#set terminal pngcairo
#set term post eps
set key left top
#set output "CpuTime.eps"
set style data linespoints
set xlabel "Instance"
set ylabel "CPU (seconds)"
#set title "Comparaison of cpu time "
set key right center

plot '$file' every ::15::32 using 2:xtic(1) t columnheader(2) ls 1, '' every ::15::32 u 3 t columnheader(3) ls 2
#plot "<(sed -n '1,16p' $file)" using 2:xtic(1) t columnheader(2) ls 1, '' u 3 t columnheader(3) ls 2
EOF

else
    echo "file $file not found";
fi
