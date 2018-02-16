#!/bin/bash -l
#SBATCH -D /home/matt87/ecl243/ants/data
#SBATCH -o /home/matt87/ecl243/ants/data/stdout-%j.txt
#SBATCH -e /home/matt87/ecl243/ants/data/stderr-%j.txt
#SBATCH -J ant_index_kallisto
#SBATCH -t 24:00:00
set -e
set -u

module load kallisto
kallisto index --index=kall_ants_index.k_idx  GCA_001272575.2_ASM127257v2_genomic.fa

