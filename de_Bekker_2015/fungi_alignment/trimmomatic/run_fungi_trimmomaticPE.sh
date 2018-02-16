#!/bin/bash -l
#SBATCH --array=1-15
#SBATCH --mem=20G
#SBATCH -t 2-12:00:00

module load bio

list=fastqlist.txt

string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}"
str=$($string)

var=$(echo $str | awk -F"\t" '{print $1, $2}')
set -- $var
c1=$1
c2=$2

echo "$c1"
echo "$c2"

TrimmomaticPE /home/smmoenga/RNASeq/ECL_Zombie/data/${c1} /home/smmoenga/RNASeq/ECL_Zombie/data/${c2} clean_paired_${c1} clean_unpaired_${c1} clean_paired_${c2} clean_unpaired_${c2} ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
