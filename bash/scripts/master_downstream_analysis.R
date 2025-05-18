#Load packages
suppressMessages({
  library(DESeq2)
  library(pheatmap)
  library(ggplot2)
  library(EnhancedVolcano)
  library(ggrepel)
})

# Load data
countdata <- read.table('data/merged_gene_counts.tsv', header = TRUE, sep = "\t", row.names = 1)
countdata <- subset(countdata, select = -transcript_id.s.)
countdata <- round(countdata, 0)

coldata <- read.table('data/metadata_Haguland.tsv', header = TRUE, sep = "\t", row.names = 1)
coldata$condition <- factor(coldata$condition)
coldata$patient <- factor(coldata$patient)

stopifnot(all(colnames(countdata) == rownames(coldata)))

# DESeq2 analysis
dds <- DESeqDataSetFromMatrix(countData = countdata, colData = coldata, design = ~ patient + condition)
dds <- dds[rowSums(counts(dds)) > 0, ]
dds <- DESeq(dds)

# VST and PCA
vsd <- vst(dds, blind = FALSE)
pcaData <- plotPCA(vsd, intgroup = c("condition", "patient"), returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

p <- ggplot(pcaData, aes(PC1, PC2, color = patient, shape = condition)) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = rownames(pcaData))) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  coord_fixed()
ggsave("results/PCA_plot.png", p, width = 10, height = 6)

# Define contrasts and run DEG analysis for each
contrasts <- list(
  c("condition", "OHT", "Control"),
  c("condition", "DPN", "Control")
)

for (contrast in contrasts) {
  contrast_name <- paste(contrast[2], "vs", contrast[3], sep = "_")
  res <- results(dds, contrast = contrast)
  resOrdered <- res[order(res$padj), ]
  res.sig <- resOrdered[resOrdered$padj < 0.05 & !is.na(resOrdered$padj), ]

  # Save DEG table
  write.csv(as.data.frame(res.sig), file = paste0("results/DEG_", contrast_name, ".csv"))

  # Heatmap for top 20 genes
  N <- 20
  sigGenes <- head(rownames(resOrdered), N)
  mat <- assay(vsd)[sigGenes, ]
  selectedSamples <- rownames(subset(coldata, condition %in% c(contrast[2], contrast[3])))
  mat <- mat[, colnames(mat) %in% selectedSamples]
  mat <- mat - rowMeans(mat)
  pheatmap(mat,
           cluster_rows = TRUE,
           show_rownames = TRUE,
           cluster_cols = TRUE,
           annotation_col = as.data.frame(colData(dds)[, c("condition", "patient")]),
           filename = paste0("results/heatmap_top20_", contrast_name, ".png"))

  # Volcano plot
  volcano <- EnhancedVolcano(res,
                             lab = rownames(res),
                             x = 'log2FoldChange',
                             y = 'padj',
                             xlim = c(-2, 2),
                             title = paste(contrast[2], 'vs.', contrast[3], 'Volcano Plot'),
                             pCutoff = 0.05,
                             FCcutoff = 0.2)

  ggsave(paste0("results/volcano_", contrast_name, ".png"), volcano, width = 10, height = 6)
}
