#!/bin/bash

# Setup
mkdir -p star_aligned counts logs

# Reference files
GENOME_DIR="star_index"
GTF="reference/annotation.gtf"

# Loop through all trimmed paired-end files
for file in trimmed_fastq/*_1P.fastq; do
    sample=$(basename "$file" _1P.fastq)

    echo "[$(date '+%H:%M:%S')] - Processing sample $sample" | tee -a logs/mapping_counting.log

    # STAR mapping
    STAR --runThreadN 4 \
         --genomeDir $GENOME_DIR \
         --readFilesIn trimmed_fastq/${sample}_1P.fastq trimmed_fastq/${sample}_2P.fastq \
         --outFileNamePrefix star_aligned/${sample}_ \
         --outSAMtype BAM SortedByCoordinate \
         --outStd Log > logs/${sample}_STAR.log 2>&1

    # featureCounts quantification
    featureCounts -T 4 -p -t exon -g gene_id \
        -a $GTF \
        -o counts/${sample}_gene_counts.txt \
        star_aligned/${sample}_Aligned.sortedByCoord.out.bam \
        > logs/${sample}_featureCounts.log 2>&1

    echo "[$(date '+%H:%M:%S')] - Finished $sample" | tee -a logs/mapping_counting.log
done

echo "[$(date '+%H:%M:%S')] - All samples processed." | tee -a logs/mapping_counting.log
