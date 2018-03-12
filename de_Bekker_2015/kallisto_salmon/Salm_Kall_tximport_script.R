rm(list=ls())

# Insalling DESeq2
# source("https://bioconductor.org/biocLite.R")
# biocLite("DESeq2")

# Installing the tximport package- not the usual process!
source("https://bioconductor.org/biocLite.R")
# biocLite("tximport")
# biocLite("tximportData")
# Intalling rhdf5 to read kallisto data
# biocLite("rhdf5")
# biocLite("rjson")
# biocLite("GenomicFeatures")
# biocLite("AnnotationForge")
# biocLite("AnnotationDbi")
# biocLite("RSQLite")

library(rhdf5)
library(rjson)
library(DESeq2)
library(tximport)
library(tximportData)
library(GenomicFeatures)
library(AnnotationForge)
library(AnnotationDbi)
library(RSQLite)
library(corrgram)
library(dplyr)

#setwd("C:/Users/mattt/Desktop/Transcriptome Project/Ants")

# makeOrgPackageFromNCBI(
#   version= "1.0",
#   maintainer="Matt <mthorstensen@ucdavis.edu>",
#   author="Matt <mthorstensen@ucdavis.edu>",
#   outputDir=".",
#   tax_id = "268505",
#   genus="Ophiocordyceps",
#   species="unilateralis",
#   verbose = "TRUE"
# )

setwd("C:/Users/mattt/Desktop/Transcriptome Project/Ants/salm_ant_output")

# Running the Salmon pipeline from tximport to DEseq2

# Creating the directory path, but you don't have to set it to the R home directory thing
dir <- system.file("extdata", package="tximportData")
list.files(dir)


# Read in Susan's metadata file, changed to match your particular set of samples
samples <- read.csv(file.path(dir, "Zombie_Metadata.csv"), header=TRUE, sep = ",")

# Tell the script to look in the salmon directory for names based on Susan's metadata and quant.sf for salmon
files <- file.path(dir, "salmon", samples$Name_Fastq,"quant.sf")
files

# Add a bunch of sample names, change the range to match how many samples you actually have
names(files) <- paste0("sample",1:12)
files
all(file.exists(files))

# Here's where you start tximport proper
txi <- tximport(files, ignoreTxVersion = TRUE, type = "salmon", tx2gene = NULL, txOut=TRUE)

# Input the metadata from the sample descriptions
sampleTable <- data.frame(condition = factor(samples$Description), each = 1)
rownames(sampleTable) <- colnames(txi$counts)


# Create a deseq dataset from the teximport stuff
dds <- DESeqDataSetFromTximport(txi, sampleTable, ~condition)

# Actually run deseq!
dds <- DESeq(dds)
resultsNames(dds) # lists the coefficients

salm.live.v.10.res <- results(dds, contrast = c("condition", "live_infected_ant_head_during_manipulation", "C._castaneus_control_at_10AM"))

salm.live.v.10.res <- cbind(salm.live.v.10.res, comp = "live_v_10")

salm.live.v.2.res <- results(dds, contrast = c("condition", "live_infected_ant_head_during_manipulation", "C._castaneus_control_at_2PM"))

salm.live.v.2.res <- cbind(salm.live.v.2.res, comp = "live_v_2")

salm.live.v.dead.res <- results(dds, contrast = c("condition", "live_infected_ant_head_during_manipulation", "dead_infected_ant_head_after_manipulation"))

salm.live.v.dead.res <- cbind(salm.live.v.dead.res, comp = "live_v_dead")

salm.ant.comparisons <- rbind(salm.live.v.10.res, salm.live.v.2.res, salm.live.v.dead.res)

salm.ant.comparisons <- salm.ant.comparisons[complete.cases(salm.ant.comparisons),]
salm.ant.comparisons <- salm.ant.comparisons[salm.ant.comparisons$log2FoldChange >= abs(1),]


# Look at the results of your work
salm.res <- results(dds)
salm.res

# Make a handy little volcano plot
plotMA(salm.res, ylim=c(-10,10), main = "Salmon Ant DGE")

######################################################################

# starting the kallisto pipeline on the ant data
dir <- system.file("extdata", package="tximportData")
list.files(dir)

kall.samples <- read.csv(file.path(dir, "Kall_Zombie_Metadata.csv"), header=TRUE, sep = ",")

kall.files <- file.path(dir, "kallisto_boot", kall.samples$Name_Fastq, "abundance.h5")
names(kall.files) <- paste0("sample", 1:12)
kall.files
all(file.exists(kall.files))


txi.kallisto <- tximport(kall.files, type = "kallisto", txOut = TRUE)
head(txi.kallisto$counts)

kall.sampleTable <- data.frame(condition = factor(kall.samples$Description), each = 1)
rownames(kall.sampleTable) <- colnames(txi.kallisto$counts)

kall.dds <- DESeqDataSetFromTximport(txi.kallisto, kall.sampleTable, ~condition)

kall.dds <- DESeq(kall.dds)
resultsNames(kall.dds) # lists the coefficients


# Do this for live vs 2 pm and live vs dead
# Rbind all these objects together
# Filter out abs value of log 2 fold change <1
# Do things w fpkm where at least in one treatment not greater than 4 for each comparison using the fpkm function. Will willing to do this part


kall.live.v.10.res <- results(kall.dds, contrast = c("condition", "live_infected_ant_head_during_manipulation", "C._castaneus_control_at_10AM"))

kall.live.v.10.res <- cbind(kall.live.v.10.res, comp = "live_v_10")

kall.live.v.2.res <- results(kall.dds, contrast = c("condition", "live_infected_ant_head_during_manipulation", "C._castaneus_control_at_2PM"))

kall.live.v.2.res <- cbind(kall.live.v.2.res, comp = "live_v_2")

kall.live.v.dead.res <- results(kall.dds, contrast = c("condition", "live_infected_ant_head_during_manipulation", "dead_infected_ant_head_after_manipulation"))

kall.live.v.dead.res <- cbind(kall.live.v.dead.res, comp = "live_v_dead")

kall.ant.comparisons <- rbind(kall.live.v.10.res, kall.live.v.2.res, kall.live.v.dead.res)

kall.ant.comparisons <- kall.ant.comparisons[complete.cases(kall.ant.comparisons),]
kall.ant.comparisons <- kall.ant.comparisons[kall.ant.comparisons$log2FoldChange >= abs(1),]



write.csv(kall.ant.comparisons, file = "kallisto_ant_comparisons.csv", quote = FALSE, sep = ",")

fragments <- fpkm(kall.dds)

kall.res <- results(kall.dds)

plotMA(kall.res, ylim=c(-20,20), main = "Kallisto Ant DGE")

plotMA(kall.live.v.10.res, ylim=c(-20,20), main = "Kallisto Ant DGE Live vs. 10 am")


#################################################################
# Playing with different correlations

salm.p <- as.numeric(salm.res$padj)
kall.p <- as.numeric(kall.res$padj)

combined.p <- as.matrix(cbind(salm.p, kall.p))

p.object <- ifelse(is.na(combined.p), 1, 0)
clean.p <- combined.p[rowSums(p.object) == 0,]

p.correlation <- cor(clean.p, use = "all.obs")
p.cov <- cov(clean.p)

corrgram(p.correlation)
corrgram(p.cov)


salm.fold <- as.numeric(salm.res$log2FoldChange)
kall.fold <- as.numeric(kall.res$log2FoldChange)

combined.fold <- as.matrix(cbind(salm.fold, kall.fold))

fold.object <- ifelse(is.na(combined.fold), 1, 0)
clean.fold <- combined.fold[rowSums(fold.object) == 0,]

fold.correlation <- cor(clean.fold)

corrgram(fold.correlation)

##########################################################
# Running the pipeline on the Kallisto fungus counts
fung.dir <- "C:/Users/mattt/Desktop/Transcriptome Project/Ants/kall_fung_output"
list.files(fung.dir)

kall.fung.samples <- read.csv(file.path(fung.dir, "Zombie_Metadata.txt"), header=TRUE, sep = "\t")

kall.fung.files <- file.path(fung.dir, kall.fung.samples$Name_Fastq, "abundance.h5")
names(kall.fung.files) <- paste0("sample", 1:9)
kall.fung.files
all(file.exists(kall.fung.files))

txi.fung.kallisto <- tximport(kall.fung.files, type = "kallisto", txOut = TRUE)
head(txi.fung.kallisto$counts)

kall.fung.sampleTable <- data.frame(condition = factor(kall.fung.samples$Description), each = 1)
rownames(kall.fung.sampleTable) <- colnames(txi.fung.kallisto$counts)

kall.fung.dds <- DESeqDataSetFromTximport(txi.fung.kallisto, kall.fung.sampleTable, ~condition)

kall.fung.dds <- DESeq(kall.fung.dds)
resultsNames(kall.fung.dds) 


kall.fung.results <- results(kall.fung.dds)
plotMA(kall.fung.results, ylim=c(-20,20), main = "Kallisto Fungus DGE")

# Do this for live vs 2 pm and live vs dead
# Rbind all these objects together
# Filter out abs value of log 2 fold change <1
# Do things w fpkm where at least in one treatment not greater than 4 for each comparison using the fpkm function. Will willing to do this part


kall.live.v.fung.res <- results(kall.fung.dds, contrast = c("condition", "live_infected_ant_head_during_manipulation", "O._unilateralis_s.l._control"))

kall.live.v.fung.res <- cbind(kall.live.v.fung.res, comp = "live_v_fung")

kall.dead.v.fung.res <- results(kall.fung.dds, contrast = c("condition", "dead_infected_ant_head_after_manipulation", "O._unilateralis_s.l._control"))

kall.dead.v.fung.res <- cbind(kall.dead.v.fung.res, comp = "dead_v_fung")

kall.fung.live.v.dead.res <- results(kall.fung.dds, contrast = c("condition", "live_infected_ant_head_during_manipulation", "dead_infected_ant_head_after_manipulation"))

kall.fung.live.v.dead.res <- cbind(kall.fung.live.v.dead.res, comp = "live_v_dead")

kall.fung.comparisons <- rbind(kall.live.v.fung.res, kall.dead.v.fung.res, kall.fung.live.v.dead.res)

kall.fung.comparisons <- kall.fung.comparisons[complete.cases(kall.fung.comparisons),]
kall.fung.comparisons <- kall.fung.comparisons[kall.fung.comparisons$log2FoldChange >= 1,]

write.csv(kall.fung.comparisons, "kallisto_fungus_comparisons.csv")
