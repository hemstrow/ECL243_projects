#!/bin/bash -l
#SBATCH -t 3-12:00:00
#SBATCH --mem 20G
#SBATCH -n 8

list=transcript_list.txt
gff=/home/hemstrow/ECL243/project/de_Bekker_2015/genome/NW_011876401.1.gff
genome=/home/hemstrow/ECL243/project/de_Bekker_2015/genome/NW_011876401.1.fa

cuffmerge -g $gff -s $genome -p 8 $list
