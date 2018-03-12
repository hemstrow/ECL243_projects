#!/bin/bash -l
#SBATCH -t 12:00:00

genome=~/ECL243/project/de_Bekker_2015/genome/GCA_001272575.2_ASM127257v2_genomic.fa
outfile=merged.fa

gtf_to_fasta merged.gtf $genome $outfile
