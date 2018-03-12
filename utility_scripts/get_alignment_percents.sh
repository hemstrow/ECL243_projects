#!/bin/bash -l

grep "concordant" SRR*_top/align_summary.txt > temp1.txt
grep "Aligned" SRR*_top/align_summary.txt > temp2.txt
paste temp1.txt temp2.txt > overall_align_summary.txt
rm temp1.txt
rm temp2.txt
