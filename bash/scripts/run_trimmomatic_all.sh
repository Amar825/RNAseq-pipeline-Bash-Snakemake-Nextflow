#!/bin/bash

# Directory setup
mkdir -p trimmed_fastq

# Path to adapter file (assumes it's in the current directory)
ADAPTERS="TruSeq3-PE.fa"

# Loop through all forward read files
for file in raw_fastq/*_1.fastq; do
    # Extract sample base name
    sample=$(basename "$file" _1.fastq)
    
    echo "Processing $sample..."

    trimmomatic PE -threads 4 \
      raw_fastq/${sample}_1.fastq raw_fastq/${sample}_2.fastq \
      trimmed_fastq/${sample}_1P.fastq trimmed_fastq/${sample}_1U.fastq \
      trimmed_fastq/${sample}_2P.fastq trimmed_fastq/${sample}_2U.fastq \
      ILLUMINACLIP:$ADAPTERS:2:30:10 \
      SLIDINGWINDOW:4:20 TRAILING:20 MINLEN:36

    echo "Finished $sample"
done

echo "All samples processed."
