#!/bin/bash
#SBATCH -t 3-12:00:00
#SBATCH --mem 20G
#SBATCH -n 8

module load bio

dir=/home/hemstrow/ECL243/project/de_Bekker_2015/fungi_alignment/cufflinks/SRR19868
tail=_1.fastq_top/accepted_hits.bam
genome=/home/hemstrow/ECL243/project/de_Bekker_2015/genome/GCA_001272575.2_ASM127257v2_genomic.fa
cmerged=/home/hemstrow/ECL243/project/de_Bekker_2015/fungi_alignment/merged_asm/merged.gtf

cuffdiff -o cuffdiff_out -b $genome -p 8 -library-norm-method classic-fpkm -no-update-check -L Live_manipulation,Dead_after_Mani,Fungal_Control $cmerged ${dir}43${tail},${dir}44${tail},${dir}45${tail} ${dir}46${tail},${dir}47${tail},${dir}48${tail} ${dir}55${tail},${dir}56${tail},${dir}57${tail}
