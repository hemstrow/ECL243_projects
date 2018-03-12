#!/bin/R

output <- readLines("de_bekker_ants/overall_align_summary.txt")
opath <- "de_bekker_ants/summary_table.txt"

output <- unlist(strsplit(output, "  "))
output <- output[!(output == "")]
odf <- data.frame(samp = rep(NA, length(output)/2), percent = rep(NA, length(output)/2), 
                   pairs = as.numeric(gsub(" ","", output[seq(2, length(output), by = 2)])))

output <- output[seq(1, length(output), by = 2)]
output <- gsub(" concordant.+", "", output)
output <- gsub("_1.+:", "_", output)
output <- gsub("%", "", output)
output <- gsub(" ", "", output)
output <- unlist(strsplit(output, "_"))
omat <- matrix(output, 15, 2, T)
odf$percent <- omat[,2]
odf$samp <- omat[,1]
inters <- matrix("", nrow(odf), ncol(odf))

odf <- cbind(odf, inters)

odf <- as.vector(t(odf))
odf <- as.data.frame(matrix(odf, length(odf)/3, ncol = 3, byrow = T))

write.table(odf, opath, quote = F, row.names = F, col.names = F, sep = "\t")
