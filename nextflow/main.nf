// main.nf

params.samples = file("samples.txt")
params.adapters = "TruSeq3-PE.fa"
params.genome = "reference/genome.fa"
params.gtf = "reference/annotation.gtf"
params.star_index = "star_index"

process fastqc_raw {
    tag "$sample"
    publishDir "results/qc_raw", mode: 'copy'

    input:
    tuple val(sample), path(reads)

    output:
    path("${sample}_fastqc.html")

    container 'quay.io/biocontainers/fastqc:0.11.9--0'
    script:
    """
    fastqc ${reads[0]} ${reads[1]}
    """
}

process trimmomatic {
    tag "$sample"
    publishDir "results/trimmed_fastq", mode: 'copy'

    input:
    tuple val(sample), path(reads)

    output:
    tuple val(sample), path("${sample}_1P.fastq"), path("${sample}_2P.fastq")

    container 'quay.io/biocontainers/trimmomatic:0.39--hdfd78af_2'
    script:
    """
    trimmomatic PE -threads 4 \
      ${reads[0]} ${reads[1]} \
      ${sample}_1P.fastq unpaired_1.fastq \
      ${sample}_2P.fastq unpaired_2.fastq \
      ILLUMINACLIP:${params.adapters}:2:30:10 SLIDINGWINDOW:4:20 TRAILING:20 MINLEN:36
    """
}

process fastqc_trimmed {
    tag "$sample"
    publishDir "results/qc_trimmed", mode: 'copy'

    input:
    tuple val(sample), path(r1), path(r2)

    output:
    path("${sample}_trimmed_fastqc.html")

    container 'quay.io/biocontainers/fastqc:0.11.9--0'
    script:
    """
    fastqc ${r1} ${r2}
    """
}

process star_align {
    tag "$sample"
    publishDir "results/aligned", mode: 'copy'

    input:
    tuple val(sample), path(r1), path(r2)

    output:
    path("${sample}_Aligned.sortedByCoord.out.bam")

    container 'quay.io/biocontainers/star:2.7.10b--0'
    script:
    """
    STAR --runThreadN 4 \
      --genomeDir ${params.star_index} \
      --readFilesIn ${r1} ${r2} \
      --outFileNamePrefix ${sample}_ \
      --outSAMtype BAM SortedByCoordinate
    """
}

process featurecounts {
    tag "$sample"
    publishDir "results/counts", mode: 'copy'

    input:
    path bam_file

    output:
    path("counts_${bam_file.simpleName}.txt")

    container 'quay.io/biocontainers/subread:2.0.3--h9a82719_1'
    script:
    """
    featureCounts -T 4 -p -t exon -g gene_id \
      -a ${params.gtf} \
      -o counts_${bam_file.simpleName}.txt ${bam_file}
    """
}

workflow {
    samples_ch = Channel.fromPath("raw_fastq/*_1.fastq")
      .map { file ->
        def sample = file.baseName.replaceAll(/_1\.fastq$/, '')
        tuple(sample, [file, file.toString().replace('_1.fastq', '_2.fastq')])
      }

    trimmed = trimmomatic(samples_ch)
    fastqc_raw(samples_ch)
    fastqc_trimmed(trimmed)
    aligned = star_align(trimmed)
    featurecounts(aligned.map { it[0] })
}
