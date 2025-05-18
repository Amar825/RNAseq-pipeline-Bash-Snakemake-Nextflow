# RNA seq pipeline (Bash-linear)

In this method, I am going to use the most fundamental way of doing an RNA-seq analysis, the bash-way. We are going to run these bash commands one by one, and at the end, we are also going to automate it. Not fully though, because we still need to intervene during the QC stages


## Dataset
As already mentioned in the main README.md file, I am using RNA-seq data from the GEO dataset **[GSE37211](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE37211)**, which investigates estrogen receptor signaling in parathyroid adenoma cells.

## Raw Data Download
To begin RNA-seq analysis, we first need to download the raw sequencing data from NCBI’s Sequence Read Archive (SRA). We use the `fasterq-dump` tool from the **SRA Toolkit**, which is faster than the older `fastq-dump`.

### 1. Requirements

- [SRA Toolkit](https://github.com/ncbi/sra-tools)
- A list of SRA accession IDs (e.g. SRR numbers) in a plain text file

Install SRA Toolkit using Conda:

```bash
conda install -c bioconda sra-tools
