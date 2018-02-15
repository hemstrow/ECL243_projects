#!/bin/bash -l
#SBATCH --array=1-15
#SBATCH --mem=20G
#SBATCH -t 2-12:00:00

module load bio

list=fastqlist.txt
gff=/home/smmoenga/RNASeq/ECL_Zombie/data/GCA_001272575.2_ASM127257v2_genomic.gff

string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}"
str=$($string)

var=$(echo $str | awk -F"\t" '{print $1, $2}')
set -- $var
c1=$1
c2=$2

echo "$c1"
echo "$c2"

tophat -i 5 -I 1000 -p 4 -G ${gff} -o ${c1}_top /home/hemstrow/ECL243/project/de_Bekker_2015/genome/GCA_001272575.2_ASM127257v2_genomic /home/smmoenga/RNASeq/ECL_Zombie/data/${c1} /home/smmoenga/RNASeq/ECL_Zombie/data/${c2}
cufflinks -p 4 -o ${c1}_cuff ${c1}_top/accepted_hits.bam

