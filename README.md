# RNAseq-pipeline-Bash-Snakemake-Nextflow

This bioinformatic pipeline performs a basic RNA-seq analysis. We start by downloading the FASTQ files and end with a Differential Expression Genes list. Of course, we'll do some downstream analysis as well. I'll be using three different methods to do this:
1. [Bash-linear](bash/bash-readme.md)
2. [Snakemake](snakemake/snakemake-readme.md)
3. [Nextflow](nextflow/nextflow-readme.md)
In every method, the fundamental processes are going to be the same, but there are going to be different ways to achieve that. Each method offers a unique value, which we shall experience on our own, and document like our lives depend on it.

## Objectives
This is a purely learning project to understand the workflow differences of Bash, Snakemake, and Nextflow. We are going to evaluate the usability and reproducibility of these workflows. Ideally, I would like to benchmark the runtimes as well. But this project was run on a modest 16GB RAM laptop, not a realistic environment for evaluating performance, since I can't make use of parallel computing due to the risk of melting my laptop. So we are going to focus on these criteria:
1. Ease of use for new users (learning curve)
2. Reproducibility (Can we trace the output?)
3. Resumability (Can the pipeline recover from a crash without doing everything again?)
4. Maintainabilty (Is it easy to update one step in a process without crashing the whole damn thing?)
5. Container support (How easy is it to set up and use Docker/Singularity?)
   
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

## Pipeline overview
All three implementations (Bash, Snakemake, and Nextflow) follow the same biological logic:

1. **Download raw FASTQ files**  
   Using `fasterq-dump` to retrieve sequencing data from NCBI SRA.
2. **Quality control**  
   Assess raw read quality using **FastQC**, then summarize across samples using **MultiQC**.
3. **Trimming** *(if needed)*  
   Adapter and quality trimming using tools like **Trim Galore** or **fastp** (optional, dataset-dependent).
4. **Alignment**  
   Align reads to the reference genome using **STAR**.
5. **Read counting**  
   Quantify gene-level expression using **featureCounts**.
6. **Differential expression analysis**  
   Use **DESeq2** (in R) to identify significantly differentially expressed genes between conditions.
7. **Optional downstream analysis**  
   Includes **PCA**, **volcano plots**, and **clustering** to visualize sample variation and DEG patterns.

