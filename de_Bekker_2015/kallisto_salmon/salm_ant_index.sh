#!/bin/bash -l
#SBATCH -J ant_index_salmon
#SBATCH -t 24:00:00
#SBATCH --mem=44G

module load salmon
salmon index -t merged_ant.fa  -i salmon_ant_index --type quasi -k 31

