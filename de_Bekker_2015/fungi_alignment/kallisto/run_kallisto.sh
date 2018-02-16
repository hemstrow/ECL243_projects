#!/bin/bash -l
#SBATCH -J kallisto_ant_quant
#SBATCH -t 12:00:00
#SBATCH --array=0-15
#SBATCH --mem=22G


module load kallisto

list=fastqlist.txt
string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}"
str=$($string)

var=$(echo $str | awk -F"\t" '{print $1, $2}')
set -- $var
c1=$1
c2=$2

echo "$c1"
echo "$c2"

kallisto quant -i kall_ants_index.k_idx -o output -b 100 ${c1} ${c2}
