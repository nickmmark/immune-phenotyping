library(xlsx)
library(dplyr) # For SQL
library(data.table)
library(ggplot2)

loadExcel <- function(filename, sheetIndex) {
  read.xlsx(filename, sheetIndex, encoding="UTF8",colNames = TRUE, colClasses = "character", stringsAsFactors = FALSE)
}