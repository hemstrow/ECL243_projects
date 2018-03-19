# Annotation_and_differential_expression

Contains scripts and files which take blast and DESeq results, get gene names/GO terms from uniprot, and create heatmaps of differentially expressed tanscripts.

## File Descriptions:

AnnoDiff.R:
Takes uniProt and Blast outputs, associates them with differential expression results, finds the definition of associated GO terms, then clusters and creates heatmaps of the results.

DE_heatmap_lGO.pdf and DE_heatmap_sGO.pdf:
Heatmaps of differentially expressed genes with the assoicated GO definitions for both the last and first GO terms, respecitvely.

blastn_sseqid:
Terms from blastn to put into uniprot.

bn_out.txt:
Blastn output

get_matching_seqs.sh:
Finds the raw sequences matching the sequence identifiers given as a list.

matches.fa:
Matches found by get_matching_seqs.sh.

mres.RDS:
Final R data set make in AnnoDiff.R

res.RDS:
Input results object from ../DamselfishDESeq.Rmd

significantcontigs:
List of significant contigs to give to get_matching_seqs.sh

uniprot.tab
Output from searching the uniprot database with the blastn_sseqid list. For AnnoDiff.R
