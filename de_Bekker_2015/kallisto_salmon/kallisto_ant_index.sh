#!/bin/bash -l
#SBATCH -J ant_index_kallisto
#SBATCH -t 24:00:00
#SBATCH --mem=44G

module load kallisto
kallisto index --index=kall_ant_genome_index.k_idx  merged_ant.fa 
