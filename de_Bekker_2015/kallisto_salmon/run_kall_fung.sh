#!/bin/bash -l
#SBATCH -J kallisto_ant_quant
#SBATCH -t 2:00:00
#SBATCH --array=1-15
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

kallisto quant -i kall_fungidx_fa -o /home/matt87/ecl243/ants/data/kall_ant_output/output_${c1} /home/hemstrow/ECL243/project/de_Bekker_2015/fungi_alignment/trimmomatic/clean_paired_${c1} /home/hemstrow/ECL243/project/de_Bekker_2015/fungi_alignment/trimmomatic/clean_paired_${c2} -gtf merged_fung.gtf
