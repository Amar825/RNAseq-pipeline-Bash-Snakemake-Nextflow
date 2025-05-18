# RNA seq pipeline (Bash-linear)

In this method, I am going to use the most fundamental way of doing an RNA-seq analysis, the bash-way. We are going to run these bash commands one by one, and at the end, we are also going to automate it. Not fully though, because we still need to intervene during the QC stages


## Dataset
As already mentioned in the main README.md file, I am using RNA-seq data from the GEO dataset **[GSE37211](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE37211)**, which investigates estrogen receptor signaling in parathyroid adenoma cells.

## Raw Data Download
To begin RNA-seq analysis, we first need to download the raw sequencing data from NCBI’s Sequence Read Archive (SRA). We use the `fasterq-dump` tool from the **SRA Toolkit**, which is faster than the older `fastq-dump`.

### Requirements

- SRA Toolkit (`fasterq-dump`)
- Accession list of SRR IDs (`SRR_Acc_List.txt`)

The SRR accession list was retrieved from the [NCBI SRA Run Selector](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=GSE37211) by exporting the "Accession List" for the study. This list was saved as `SRR_Acc_List.txt`, containing one SRR ID per line.




