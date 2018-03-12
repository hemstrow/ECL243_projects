#!/bin/bash -l
#SBATCH -J fung_index_salmon
#SBATCH -t 24:00:00
#SBATCH --mem=44G

module load salmon
salmon index -t merged_fung.fa -i salmon_fung_index --type quasi -k 31

