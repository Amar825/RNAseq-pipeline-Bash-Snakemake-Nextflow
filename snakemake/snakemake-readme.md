# Snakemake RNA-seq Pipeline

This workflow replicates the full Bash-linear RNA-seq pipeline using Snakemake for automation and reproducibility.  
It performs the following steps:

1. Run FastQC on raw FASTQ files
2. Run Trimmomatic to clean reads
3. Run FastQC again on trimmed reads
4. Align reads using STAR
5. Count reads per gene using featureCounts
6. Output one count file per sample

## Setting up
Snakemake is pretty rigid with its rules, so special care should be taken to folder, directories, sample names and such. 
## Overview

This project is not intended as a full production-grade pipeline, but it mimics the structure and rigor of one.  
The goal was to structure the RNA-seq processing in a reproducible way, using Snakemake to define each computational step and dependency explicitly.

All steps are logged, parameterized via `config.yaml`, and organized with reproducible file naming and directory structure.  
Each rule was tested and mirrors standard practices in RNA-seq data preprocessing.

---

## Pipeline Steps

### 1. Raw FASTQ Quality Control

Runs FastQC on the raw FASTQ files and saves the output to `fastqc_raw/`.

### 2. Trimming with Trimmomatic

Uses the Illumina TruSeq3 adapter set and quality filtering parameters:
- Sliding window trimming
- Trailing base trimming
- Minimum length threshold

Trimmed files are stored in `trimmed_fastq/`. Only **paired reads** are used downstream.

### 3. Post-trimming FastQC

Quality of trimmed reads is evaluated again using FastQC. Output is stored in `fastqc_trimmed/`.

### 4. STAR Alignment

Trimmed paired reads are aligned to the human reference genome (hg38), using a STAR genome index generated separately.  
Aligned reads are output as coordinate-sorted BAM files into `star_aligned/`.

### 5. Read Counting with featureCounts

Uses the GTF annotation to assign reads to exons and aggregate counts by `gene_id`.  
One count file per sample is written to `counts/`.

---

## Execution Summary

This Snakemake pipeline was run locally using:

```bash
snakemake --use-singularity --cores 4
```

## Rule Summary

Each processing step is implemented as a Snakemake rule, with dependencies handled automatically. Here's a breakdown:

---

### `fastqc_raw`
Runs FastQC on the original untrimmed FASTQ files.  
**Container**: `fastqc` from BioContainers  
**Output**: `.html` reports → `fastqc_raw/`

```python
singularity: config["singularity_images"]["fastqc"]
```
### `trimmomatic`

Trims adapters and low-quality bases using Trimmomatic.  
Only paired reads are retained and used for downstream processing.

**Container**: `trimmomatic` from BioContainers  
**Output**: `_1P.fastq`, `_2P.fastq` → `trimmed_fastq/`

```python
singularity: config["singularity_images"]["trimmomatic"]
```
### `fastqc_trimmed`

Runs FastQC again, this time on the trimmed reads.  
This step verifies that trimming successfully removed adapter sequences and improved read quality.

**Container**: same `fastqc` container as the raw read step  
**Output**: `.html` reports → `fastqc_trimmed/`

---

### `star_align`

Aligns trimmed paired-end reads to the reference genome using STAR.  
The STAR genome index must be generated separately beforehand.

**Container**: `star` from BioContainers  
**Output**: sorted BAM file → `star_aligned/`

```python
singularity: config["singularity_images"]["star"]
```
### `featurecounts`
Counts reads per gene using Subread's `featureCounts`.  
Reads are assigned to **exons** and summarized at the **gene level** using the `gene_id` attribute in the GTF file.

**Container**: `subread` from BioContainers  
**Output**: `{sample}_gene_counts.txt` → `counts/`

```python
singularity: config["singularity_images"]["featurecounts"]
```


