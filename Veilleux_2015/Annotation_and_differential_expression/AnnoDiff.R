library(readr); library(ggplot2); library

library(GO.db)

#################################
#associate uniProt out with blast out to get best matches.

#read in data
bn <- read.table("Veilloux/bn_out.txt")
up <- read_delim("~/2017-2018/ECL 243/Project/Veilloux/uniprot.tab", 
                      "\t", escape_double = FALSE, trim_ws = TRUE)
up <- as.data.frame(up)

#fix column names
colnames(up)[2] <- "sseqid"

colnames(bn) <- c("qseqid", "sseqid", "pident", "length", "mismatch", "gapopen", "qstart", 
                  "qend", "sstart", "send", "evalue", "bitscore")

#fix sseqids
bn$sseqid <- gsub("\\..+", "", bn$sseqid)

#merge the two datasets by sseqid
mbn <- merge(bn, up, by = "sseqid")

#take only the best hits (evalues) with protiens that were fround with UniProt.
mbn <- dplyr::arrange(mbn, qseqid, evalue)
mbn <- mbn[!duplicated(mbn$qseqid, fromLast = T),] #gives us 42 hits.


######################################
#associate with diff data.

#get data, fix qseqid column
res <- readRDS("Veilloux/res.RDS")
res$qseqid <- rownames(res)
res$qseqid <- gsub("\\|.+", "", res$qseqid)

#remove unsignificant values
#res <- res[!is.na(res$padj),]
#res <- res[res$padj <= 0.05 & abs(res$log2FoldChange) >= 1.5,]

#merge
mres <- merge(mbn, res, by = "qseqid")

#remove uneeded columns
mres <- mres[,colnames(mres) %in% c("qseqid", "sseqid", "evalue", "Gene ontology IDs",
                                    "Protein names", "Gene names", "log2FoldChange", "padj", "comp.X")]


###############################
#plots
##get go terms, most generic
gos <- mres$`Gene ontology IDs`
gos <- gsub(".+GO:", "", gos)
gos <- gsub("GO:", "", gos)

terms <- as.list(GOTERM)
GOIDS <- terms[names(terms) %in% paste0("GO:", gos)]
GOnames <- data.frame(ID = names(GOIDS), lGOT = character(length(GOIDS)), stringsAsFactors = F)
for(i in 1:length(GOIDS)){
  GOnames$lGOT[i] <- GOIDS[[i]]@Term
}

mres$lGO <- paste0("GO:", gos)
mres <- merge(mres, GOnames, by.x = "lGO", by.y = "ID")


##get go terms, send most generic
gos <- mres$`Gene ontology IDs`
gos <- gsub(";.+", "", gos)

GOIDS <- terms[names(terms) %in% gos]
GOnames <- data.frame(ID = names(GOIDS), sGOT = character(length(GOIDS)), stringsAsFactors = F)
for(i in 1:length(GOIDS)){
  GOnames$sGOT[i] <- GOIDS[[i]]@Term
}

mres$sGO <- gos
mres <- merge(mres, GOnames, by.x = "sGO", by.y = "ID")

#prepare plotting vars
mres$sGOu <- paste0(mres$sGOT, "_", mres$sseqid)
mres$lGOu <- paste0(mres$lGOT, "_", mres$sseqid)


##do clustering
ord <- hclust( dist(cbind(mres$log2FoldChange, mres$comp.X), method = "euclidean"), method = "ward.D" )$order
mres$sGOu <- factor(mres$sGOu, levels = unique(mres$sGOu[ord]))
mres$lGOu <- factor(mres$lGOu, levels = unique(mres$lGOu[ord]))

setwd("Veilloux/")

ggplot(mres, aes(y = sGOu, x = comp.X, fill = log2FoldChange)) + geom_tile() + 
  theme_bw() + scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0) +
  theme(axis.text.y = element_text(size = 15), axis.title.y = element_blank()) + 
  xlab("Comparison")

ggplot(mres, aes(y = lGOu, x = comp.X, fill = log2FoldChange)) + geom_tile() + 
  theme_bw() + scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0) +
  theme(axis.text.y = element_text(size = 15), axis.title.y = element_blank()) + 
  xlab("Comparison")


#save
saveRDS(mres, "mres.RDS")
