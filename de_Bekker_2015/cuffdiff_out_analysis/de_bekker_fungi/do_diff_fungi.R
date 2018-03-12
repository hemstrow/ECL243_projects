#import and do basic plots for cuffdiff data

library(cummeRbund); library(ggplot2)


#======================================================================================
#no strand fix


dat <- readCufflinks("de_bekker_fungi/cuffdiff_out/")

#######################################
#get and plot number of diff expr genes
#get genes
gdd <- diffData(genes(dat), features = TRUE)

#pick out significant genes according to their metrics
sgd <- gdd[(gdd$value_1 >= 4 | gdd$value_2 >= 4) & abs(gdd$log2_fold_change) >= 1 & gdd$significant == "yes",]


##number of differentially expressed genes.
length(unique(sgd$gene_id))

#plot the number of significant genes per comparison
##prepare
sgd$comp <- paste0(sgd$sample_1, "/", sgd$sample_2)
sgd$dir <- ifelse(sgd$log2_fold_change < 0, -1, 1)
##flip directions to match
sgd[sgd$comp == "Live_manipulation/Dead_after_Mani",]$dir <- sgd[sgd$comp == "Live_manipulation/Dead_after_Mani",]$dir * -1
sgd$dir <- ifelse(sgd$dir == -1, "down", "up")


sgd$comp <- ifelse(sgd$comp == "Live_manipulation/Dead_after_Mani", "Manip/After",
                   ifelse(sgd$comp == "Dead_after_Mani/Fungal_Control", "After/Control",
                   "Manip/Control"))

#tabulate
sgd.tab <- as.data.frame(xtabs(~sgd$dir + sgd$comp))
colnames(sgd.tab) <- c("Direction", "Comparison", "Count")

sgd.tab$Direction <- as.factor(sgd.tab$Direction)
sgd.tab$Direction <- relevel(sgd.tab$Direction, ref = "up")

###plot
ggplot(sgd.tab, aes(Comparison, Count, fill = Direction)) + geom_bar(stat = "identity", position = "dodge") +
  theme_bw() + scale_fill_manual(values = c("black", "grey")) + 
  scale_x_discrete(limits = c("Manip/Control",
                              "After/Control",
                              "Manip/After")) +
  theme(axis.text.x = element_text(angle = 90, size = 13, color = "black"),
        axis.text.y = element_text(size = 13, color = "black"))

#####################################
#volcano
csVolcanoMatrix(genes(dat), TRUE)
csVolcano(genes(dat), "Dead_after_Mani", "Fungal_Control", replicates = TRUE)






#====================================================================================
#strand fix
dat <- readCufflinks("de_bekker_fungi/fungi_cuffdiff_out/")

#######################################
#get and plot number of diff expr genes
#get genes
gdd <- diffData(genes(dat), features = TRUE)

#pick out significant genes according to their metrics
sgd <- gdd[(gdd$value_1 >= 4 | gdd$value_2 >= 4) & abs(gdd$log2_fold_change) >= 1 & gdd$significant == "yes",]


##number of differentially expressed genes.
length(unique(sgd$gene_id))

#plot the number of significant genes per comparison
##prepare
sgd$comp <- paste0(sgd$sample_1, "/", sgd$sample_2)
sgd$dir <- ifelse(sgd$log2_fold_change < 0, -1, 1)
##flip directions to match
sgd[sgd$comp == "Live_manipulation/Dead_after_Mani",]$dir <- sgd[sgd$comp == "Live_manipulation/Dead_after_Mani",]$dir * -1
sgd$dir <- ifelse(sgd$dir == -1, "down", "up")


sgd$comp <- ifelse(sgd$comp == "Live_manipulation/Dead_after_Mani", "Manip/After",
                   ifelse(sgd$comp == "Dead_after_Mani/Fungal_Control", "After/Control",
                          "Manip/Control"))

#tabulate
sgd.tab <- as.data.frame(xtabs(~sgd$dir + sgd$comp))
colnames(sgd.tab) <- c("Direction", "Comparison", "Count")
sgd.tab$Direction <- as.factor(sgd.tab$Direction)
sgd.tab$Direction <- relevel(sgd.tab$Direction, ref = "up")

###plot
ggplot(sgd.tab, aes(Comparison, Count, fill = Direction)) + geom_bar(stat = "identity", position = "dodge") +
  theme_bw() + scale_fill_manual(values = c("black", "grey")) + 
  scale_x_discrete(limits = c("Manip/Control",
                              "After/Control",
                              "Manip/After")) +
  theme(axis.text.x = element_text(angle = 90, size = 13, color = "black"),
        axis.text.y = element_text(size = 13, color = "black"))



#####################################
#volcano
csVolcanoMatrix(genes(dat), TRUE)
csVolcano(genes(dat), "Dead_after_Mani", "Fungal_Control", replicates = TRUE)


