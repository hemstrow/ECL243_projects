#!/bin/bash -l
#SBATCH -t 3-12:00:00
#SBATCH -n 4
#SBATCH --mem 8G


tophat -p 4 -G /home/smmoenga/RNASeq/ECL_Zombie/data/GCA_001272575.2_ASM127257v2_genomic.gff -o SRR1986857_1.fastq_top genome/GCA_001272575.2_ASM127257v2_genomic /home/smmoenga/RNASeq/ECL_Zombie/data/SRR1986857_1.fastq /home/smmoenga/RNASeq/ECL_Zombie/data/SRR1986857_2.fastq
cufflinks -p 4 -o SRR1986857_1.fastq_cuff SRR1986857_1.fastq_top/accepted_hits.bam

