#!/bin/bash

 mkdir -p star_index
index_path=#path to index
fasta_path=#path to reference fasta
GTF_path=#path to annoation file

 STAR --runThreadN 4 \
  --runMode genomeGenerate \
  --genomeDir $index_path \
  --genomeFastaFiles $fasta_path/genome.fa \
  --sjdbGTFfile $GTF_path/annotation.gtf \
