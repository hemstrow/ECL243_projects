#!/bin/bash -l

list=$1
ref=$2

wc=$(wc -l ${list} | awk '{print $1}')

x=1
while [ $x -le $wc ] 
do
	string="sed -n ${x}p ${list}" 
	str=$($string)

	echo "#!/bin/bash -l

	" > ${str}.sh
	sbatch -t 1-12:00 --mem=4G ${str}.sh
	x=$(( $x + 1 ))

done


