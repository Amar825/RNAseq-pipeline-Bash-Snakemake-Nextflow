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

### `main.nf`

This is the main workflow script that defines each process (like a rule in Snakemake) and how data flows between them.

Each `process` in `main.nf` represents a distinct analysis step:

- `FastQC_Raw`: runs FastQC on raw paired-end reads
- `Trimmomatic`: performs adapter and quality trimming
- `FastQC_Trimmed`: runs FastQC again on trimmed reads
- `STAR_Align`: maps trimmed reads to the reference genome
- `FeatureCounts`: counts aligned reads per gene using the annotation file

Processes are connected using **Nextflow channels**, which pass data from one process to the next in a dependency-aware way. All sample names are inferred dynamically from the input file names.

This script is designed to process all samples in parallel, using available CPU resources efficiently.

---

### `nextflow.config`

This configuration file sets global workflow parameters and tool-specific settings. It includes:

- Paths to input files: reference genome, annotation GTF, STAR index, adapter file
- Default thread count for parallelized steps
- Specification of container images (Singularity or Docker) for each process

Each process pulls its container image from the BioContainers repository via the `process.container` setting. This ensures reproducibility and eliminates the need to manage software dependencies manually.


