# RNAseq-pipeline-Bash-Snakemake-Nextflow

This bioinformatic pipeline performs a basic RNA-seq analysis. We start by downloading the FASTQ files and end with a Differential Expression Genes list. I'll be using three different methods to do this:
1. Bash-linear
2. Snakemake
3. Nextflow

In every method, the fundamental processes are going to be the same, but there are going to be different ways to achieve that. Each method offers a unique value, which we shall experience on our own, and document like our lives depend on it.

This project is documented as if I am explaining this to a friend. No AI fluff, no big  and complex sentences.
I might write a medium article about it going in much details about the codes and stuff, but in this repo I will stick to explaining the **conceptual elements and rationale** behind every steps and parameters. So basically explaining the whys.

## Dataset
This pipeline analyzes RNA-seq data from the GEO dataset **[GSE37211](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE37211)**, which investigates estrogen receptor signaling in parathyroid adenoma cells.

- **Organism**: *Homo sapiens*
- **Platform**: Illumina HiSeq 2000 (paired-end, 100 bp)
- **Samples**: 23 total, across 6 conditions:
  - Control (24h, 48h)
  - DPN (24h, 48h)
  - OHT (24h, 48h)
- **Experimental Focus**: Transcriptomic response to DPN and Tamoxifen (OHT), targeting estrogen receptor beta.
- **Source**: Haglund et al., *J Clin Endocrinol Metab*, 2012 ([PubMed](https://pubmed.ncbi.nlm.nih.gov/23024189/))


***Why this dataset?*** It was one of the complete datasets suggested under 50GB during one of my master's courses called **[Bioinformatic Methods for Next Generation Sequencing Analysis](https://www.ntnu.edu/studies/courses/MOL8008#tab=omEmnet)** at NTNU.

Usually, for personal learning projects, people tend to choose only specific parts of the large sequencing data. It is okay for learning purposes, but it won't lead to replicating the paper's figures or any meaningful results. Depending upon your hardware (I did it in 16gb RAM device), this should not pose too big a problem as long as you run sample by sample.
