# Load libraries
suppressPackageStartupMessages(library(tidyverse))

# Set path to your count files
count_files <- list.files(path = "counts/", pattern = "_gene_counts.txt$", full.names = TRUE)

# Read and clean all count files
count_list <- lapply(count_files, function(file) {
  df <- read.delim(file, comment.char = "#", stringsAsFactors = FALSE)
  df <- df[, c("Geneid", ncol(df))]  # Keep only Geneid and count column
  sample_name <- tools::file_path_sans_ext(basename(file))
  sample_name <- sub("_gene_counts", "", sample_name)
  colnames(df)[2] <- sample_name
  return(df)
})

# Merge all into one table by Geneid
merged_counts <- reduce(count_list, full_join, by = "Geneid")

# Save to file
write.table(merged_counts, file = "counts/merged_gene_counts.tsv", sep = "\t", row.names = FALSE, quote = FALSE)
