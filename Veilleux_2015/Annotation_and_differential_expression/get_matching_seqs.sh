#!/bin/bash -l
#SBATCH -t 12:00:00

list=significantcontigs
source=genome/A_polyacanthus_transABySS_contig.fa

wc=$(wc -l ${list} | awk '{print $1}')

x=1
while [ $x -le $wc ] 
do
	string="sed -n ${x}p ${list}" 
	str=$($string)

	echo "$str"

	sed -n -e "/$str$/,/>/ p" $source >> matches.fa
	sed -i '$ d' matches.fa

	x=$(( $x + 1 ))

done


