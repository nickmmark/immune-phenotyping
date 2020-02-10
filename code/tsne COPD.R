# load libraries
# library(tidyr)
library(ggfortify)
library(cluster)
library(lfda)
library(xlsx)
library(dplyr) # For SQL
library(data.table)
library(ggplot2)


# load excel function
loadExcel <- function(filename, sheetIndex) {
  read.xlsx(filename, sheetIndex, encoding="UTF8",colNames = TRUE, colClasses = "character", stringsAsFactors = FALSE)
}

# Load files
setwd("/Users/nicholas/Desktop/R PCA analysis/")
copd <- loadExcel("COPD2.xlsx",1)
copd <- mutate(copd, new_gold = ifelse(gold_stage < 1, "No COPD present", "COPD present"))
# copd <- mutate(copd, new_goddard = ifelse(goddard_score < 0.5, 0, 1))
copd <- mutate(copd, new_goddard = ifelse(goddard_score < 0.5, "No emphysema present", "Emphysema present"))
copd <- mutate(copd, new_copd_any_definition = ifelse(copd_anydefinition < 1, "No COPD", "COPD"))

copd <- na.omit(copd)
copd <- select(copd, gold_stage, goddard_score, new_gold, new_goddard, colNames, sample, copd_anydefinition,
               cd45, cd3, cd4, cd8, nkt, pmn, nk, b, #gdt, nk, b, mac, pmn,  # basic cell types
               cd8ifng, th1, th17, treg, gdtil17, gdtifng,      # cytokine profiles
              #cd4_pd1, cd8_pd1,                                # pd-1 expression
              #pmnpdl1, macpdl1, monopdl1, nocd45pdl1,           # pd-l1 expression
              #cd4_tim3, cd8_tim3,                                # tim3 expression
              #cd4pd1tim3, cd8pd1tim3,                          # dual checkpoint expression
               )          

minus_gold <- select(copd, -new_gold, -new_goddard, -copd_anydefinition,
                     -colNames, -sample, -gold_stage, -goddard_score)


pr <- prcomp(minus_gold)
#pc_comps <- data.frame(pr$rotation)
#pc1_vars <- select(pc_comps, PC1)
#pc2_vars <- select(pc_comps, PC2)
#arrange(pc1_vars, PC1)

# Output options "new_gold", "new_goddard", "copd_any_definition")

# Write 2 axis PCA
autoplot(pr, data = copd,
         colour = "new_gold", frame = TRUE, frame.type = "norm",
         #loadings = TRUE, loadings.label = TRUE, loadings.colour = "black"            # show eigenvectors
         ) +
         ggtitle(label = "COPD vs Non-COPD PCA")
