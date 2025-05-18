# RNA seq pipeline (Bash-linear)

In this method, I am going to use the most fundamental way of doing an RNA-seq analysis, the bash-way. We are going to run these bash commands one by one, and at the end, we are also going to automate it. Not fully though, because we still need to intervene during the QC stages


## Dataset
As already mentioned in the main README.md file, I am using RNA-seq data from the GEO dataset **[GSE37211](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE37211)**, which investigates estrogen receptor signaling in parathyroid adenoma cells.

## Raw Data Download
To begin RNA-seq analysis, we first need to download the raw sequencing data from NCBI’s Sequence Read Archive (SRA). We use the `fasterq-dump` tool from the **SRA Toolkit**, which is faster than the older `fastq-dump`.

### Requirements

- SRA Toolkit (`fasterq-dump`) (My version was 
- Accession list of SRR IDs (`SRR_Acc_List.txt`)

The SRR accession list was retrieved from the [NCBI SRA Run Selector](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=GSE37211) by exporting the "Accession List" for the study. This list was saved as `SRR_Acc_List.txt`, containing one SRR ID per line.

Use the `download_fastqc.sh` script, REMEMBER to make it executable (chmod +x)
```bash
#!/bin/bash
mkdir -p rawReads
while read id; do
    fasterq-dump "$id" --split-files --threads 4 -O rawReads/
done < SRR_Acc_List.txt
```
- `--split-files` separates paired-end reads into two files (`_1.fastq` and `_2.fastq`), which is required for downstream tools like STAR for paired-end alignment.
- `--threads 4` enables multi-threaded downloading, which basically means that your computer will use 4 CPU threads in parallel instead of 1, which is the default, to speed up conversion from SRA to fastq format.

## Read Preprocessing
This step includes initial quality assessment of raw reads, adapter and quality trimming using **Trimmomatic**, and re-evaluation of trimmed reads. Trimming improves alignment accuracy and reduces noise in downstream analyses.

### Tools Used

- `FastQC`: for quality assessment
- `MultiQC`: for summarizing FastQC results
- `Trimmomatic`: for adapter removal and quality trimming

### 1. Run FastQC on Raw FASTQ Files

```bash
fastqc raw_fastq/*.fastq -o fastqc_raw -t 4








