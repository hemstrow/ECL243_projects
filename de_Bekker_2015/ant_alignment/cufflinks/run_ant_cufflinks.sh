#!/bin/bash -l
#SBATCH --array=1-15
#SBATCH --mem=20G
#SBATCH -t 2-12:00:00

module load bio

list=/home/hemstrow/ECL243/project/de_Bekker_2015/ant_alignment/fastqlist.txt
gff=/home/hemstrow/ECL243/project/de_Bekker_2015/genome/NW_011876401.1.gff
genome=/home/hemstrow/ECL243/project/de_Bekker_2015/genome/NW_011876401.1

string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}"
str=$($string)

var=$(echo $str | awk -F"\t" '{print $1, $2}')
set -- $var
c1=$1
c2=$2

echo "$c1"
echo "$c2"

tophat -i 5 -I 1000 -p 4 -G ${gff} -o ${c1}_top ${genome} /home/hemstrow/ECL243/project/de_Bekker_2015/fungi_alignment/trimmomatic/clean_paired_${c1} /home/hemstrow/ECL243/project/de_Bekker_2015/fungi_alignment/trimmomatic/clean_paired_${c2}
cufflinks -p 4 -o ${c1}_cuff ${c1}_top/accepted_hits.bam

