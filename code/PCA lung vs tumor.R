# Analysis of immune cell phenotype of non-small cell lung cancer (NSCLC) tumor 
# compared to surrounding lung tissue using principle component analysis (PCA)
# Uses GOLD stage to evaluate severity of COPD by degree of airflow obstruction
# Nick Mark, 2017

# load required libraries
# library(tidyr)             # optional
library(ggfortify)
library(cluster)
library(lfda)
library(xlsx)
library(dplyr)                # For SQL
library(data.table)
library(ggplot2)

# define the loadExcel function
loadExcel <- function(filename, sheetIndex) {
  read.xlsx(filename, sheetIndex, encoding="UTF8",colNames = TRUE, colClasses = "character", stringsAsFactors = FALSE)
}

# Load files
setwd("/Users/nicholas/Desktop/R PCA analysis/")
pr <- loadExcel("NSCLC.xlsx",1)

# define if the sample comes from a person with COPD or not based on GOLD stage
copd <- mutate(copd, new_tumor = ifelse(tumor < 1, "Lung", "Tumor"))
copd <- na.omit(copd)
copd <- select(copd, sample, tumor,                               # sample information
               cd45, cd4, cd8, pmn, mac, mono, nk, nkt, b,        # basic cell types
               th17, th1, treg, cd8ifng,                          # cytokine profiles
               gdtil17, cd4il22          
               )          

minus_gold <- select(copd, -sample, -tumor)

copd <- prcomp(minus_gold)
#pc_comps <- data.frame(pr$rotation)
#pc1_vars <- select(pc_comps, PC1)
#pc2_vars <- select(pc_comps, PC2)
#arrange(pc1_vars, PC1)

# Write 2 axis PCA
autoplot(pr, data = copd,
         colour = "tumor", frame = TRUE, frame.type = "norm",
         #loadings = TRUE, loadings.label = TRUE,             # remove comment to show eigenvectors
         ) +
         ggtitle(label = "Lung vs Tumor PCA")

