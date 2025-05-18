# Nextflow RNA-seq Pipeline

This pipeline replicates the same RNA-seq processing steps as the Bash and Snakemake workflows, but using **Nextflow** for enhanced portability, scalability, and modularity.


---

## Overview

The pipeline follows the standard RNA-seq preprocessing structure:

1. Run FastQC on raw FASTQ files  
2. Run Trimmomatic for adapter and quality trimming  
3. Run FastQC again on trimmed reads  
4. Align reads using STAR  
5. Count reads per gene using featureCounts  
6. Output one count file per sample  

All samples are processed in parallel, and steps are executed in a dependency-aware manner.

---

## Pipeline Setup

This pipeline consists of:

- `main.nf` — main Nextflow workflow script  
- `nextflow.config` — configuration for paths, threads, and containers  
- `data/` — input FASTQ files and reference files  
- `results/` — output directory with counts, logs, and QC reports

---

## How to Run

Run the workflow with:

```bash
nextflow run main.nf -profile local,singularity
