#!/bin/bash
#SBATCH -t 3-12:00:00
#SBATCH --mem 20G
#SBATCH -n 8

module load bio

dir=/home/hemstrow/ECL243/project/de_Bekker_2015/ant_alignment/cufflinks/SRR19868
tail=_1.fastq_top/accepted_hits.bam
genome=/home/hemstrow/ECL243/project/de_Bekker_2015/genome/NW_011876401.1.fa
cmerged=/home/hemstrow/ECL243/project/de_Bekker_2015/ant_alignment/merged_asm/merged.gtf

cuffdiff -o cuffdiff_out -b $genome -p 8 -library-norm-method classic-fpkm -no-update-check -L Live_manipulation,Dead_after_Mani,Ant_Control_10am,Ant_Control_2pm $cmerged ${dir}43${tail},${dir}44${tail},${dir}45${tail} ${dir}46${tail},${dir}47${tail},${dir}48${tail} ${dir}49${tail},${dir}50${tail},${dir}51${tail} ${dir}52${tail},${dir}53${tail},${dir}54${tail}
