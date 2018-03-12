#!/bin/bash -l
#SBATCH -t 12:00:00

genome=~/ECL243/project/de_Bekker_2015/genome/NW_011876401.1.fa
outfile=merged_ant.fa

gtf_to_fasta merged.gtf $genome $outfile
