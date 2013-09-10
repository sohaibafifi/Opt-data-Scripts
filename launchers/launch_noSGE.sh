#!/bin/bash
#
# File:   launch_noSGE.bash
# Author: Sohaib AFIFI
#
# Created on June 25, 2013, 09:57:34 AM
#
exec="./build/command"
output="output"
sleeptime=0.1s
#parallel executions limit
limit=2
#number of executions per instance
execnb=5
saTimeout=1200
obj=0

for (( x=1; x<=$execnb; x++ ))
do
  for alpha in 0.995
  do
    for t0 in  1
    do
      options="-f $obj --saT0 $t0 --saIterMax 5 --saAlpha $alpha --saTimeout $saTimeout --saRhMax 2 --sad 5 --verbose"
      mkdir -p "$output/$obj/$t0-$alpha"

      for nc in 20 50 80
      do
	for f in Instances/case$nc/*[2-4].dat
	do
	  running=`ps ux | grep -i $(basename "$exe c") | grep -v grep | wc -l`
	  while [ $running -ge $limit ]
	  do
	    sleep $sleeptime
	    running=`ps ux | grep -i $(basename "$exec") | grep -v grep | wc -l`
	  done
	  echo "[$x]Processing $f in $output/$obj/$t0-$alpha"
	  ff=$(basename "$f")
	  ff="${ff%.*}"
	  # get a goot random seed using dev/urandom
	  seed=$(od -vAn -N4 -tu4 < /dev/urandom)
	  nohup $exec -i $f -o $output/$obj/$t0-$alpha/$ff.exec$x $options --seed $seed &
	  sleep $sleeptime
	done
      done
    done
  done
done


# ensure all the executions are finished
limit=0
running=`ps ux | grep -i $(basename "$exec") | grep -v grep | wc -l`
while [ $running -gt $limit ]
do
  sleep $sleeptime
  running=`ps ux | grep -i $(basename "$exec") | grep -v grep | wc -l`
done
# send a tarred output folder
./scripts/collectors/getBestSolutions.pl $output/$obj |  sort -t'_' -k3n -k2n > $output/$obj/BestSolutions.txt
now=$(date +"%m_%d_%Y")
tar cfz "`echo $output`_$now.tar.gz"  $output
cat "`echo $output`_$now.tar.gz" | uuencode "`echo $output`_$now.tar.gz" |  mailx  me@sohaibafifi.com -s "results output from [$PWD]" -c afifisoh@utc.fr
