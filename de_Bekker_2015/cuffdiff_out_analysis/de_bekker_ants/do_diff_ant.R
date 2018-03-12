#import and do basic plots for cuffdiff data

library(cummeRbund); library(ggplot2)



#=========================================================================================
#first without the strand fix

dat <- readCufflinks("de_bekker_ants/cuffdiff_out/")

#######################################
#get and plot number of diff expr genes
#get genes
gdd <- diffData(genes(dat), features = TRUE)

#pick out significant genes according to their metrics
sgd <- gdd[(gdd$value_1 >= 4 | gdd$value_2 >= 4) & abs(gdd$log2_fold_change) >= 1 & gdd$significant == "yes",]


##number of differentially expressed genes.
length(unique(sgd$gene_id))
##plot the number of significant genes per comparison
###prepare
sgd$comp <- paste0(sgd$sample_1, "/", sgd$sample_2)
keep.comps <- c("Live_manipulation/Ant_Control_10am", 
                "Dead_after_Mani/Ant_Control_2pm", 
                "Live_manipulation/Dead_after_Mani") #comparisons to keep
sgd <- sgd[sgd$comp %in% keep.comps,]


sgd$comp <- ifelse(sgd$comp == "Live_manipulation/Ant_Control_10am", "Manip/Control",
                   ifelse(sgd$comp == "Dead_after_Mani/Ant_Control_2pm", "After/Control",
                          "Manip/After"))

sgd$dir <- ifelse(sgd$log2_fold_change < 0, "down", "up")
sgd.tab <- as.data.frame(xtabs(~sgd$dir + sgd$comp))
colnames(sgd.tab) <- c("Direction", "Comparison", "Count")


###plot
ggplot(sgd.tab, aes(Comparison, Count, fill = Direction)) + geom_bar(stat = "identity", position = "dodge") +
  theme_bw() + scale_fill_manual(values = c("gray", "black")) +
  scale_x_discrete(limits = c("Manip/Control",
                              "After/Control",
                              "Manip/After")) +
  theme(axis.text.x = element_text(angle = 90, size = 13))


#====================================================================
#after strand fix

dat <- readCufflinks("de_bekker_ants/cuffdiff_ant_out/")

#######################################
#get and plot number of diff expr genes
#get genes
gdd <- diffData(genes(dat), features = TRUE)

#pick out significant genes according to their metrics
sgd <- gdd[(gdd$value_1 >= 4 | gdd$value_2 >= 4) & abs(gdd$log2_fold_change) >= 1 & gdd$significant == "yes",]


##number of differentially expressed genes.
length(unique(sgd$gene_id))
##plot the number of significant genes per comparison
###prepare
sgd$comp <- paste0(sgd$sample_1, "/", sgd$sample_2)
keep.comps <- c("Live_manipulation/Ant_Control_10am", 
                "Dead_after_Mani/Ant_Control_2pm", 
                "Live_manipulation/Dead_after_Mani") #comparisons to keep
sgd <- sgd[sgd$comp %in% keep.comps,]


sgd$comp <- ifelse(sgd$comp == "Live_manipulation/Ant_Control_10am", "Manip/Control",
                   ifelse(sgd$comp == "Dead_after_Mani/Ant_Control_2pm", "After/Control",
                          "Manip/After"))

sgd$dir <- ifelse(sgd$log2_fold_change < 0, "down", "up")
sgd.tab <- as.data.frame(xtabs(~sgd$dir + sgd$comp))
colnames(sgd.tab) <- c("Direction", "Comparison", "Count")


###plot
ggplot(sgd.tab, aes(Comparison, Count, fill = Direction)) + geom_bar(stat = "identity", position = "dodge") +
  theme_bw() + scale_fill_manual(values = c("gray", "black")) +
  scale_x_discrete(limits = c("Manip/Control",
                              "After/Control",
                              "Manip/After")) +
  theme(axis.text.x = element_text(angle = 90, size = 13))
