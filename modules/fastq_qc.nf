process FASTQ_QC {

    tag "${sample_id}"

    input:
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}.fastq_stats.txt", emit: stats

    script:
    """
    echo "Sample: ${sample_id}" > ${sample_id}.fastq_stats.txt
    echo "FASTQ: ${reads}" >> ${sample_id}.fastq_stats.txt

    echo "Read count:" >> ${sample_id}.fastq_stats.txt

    zcat ${reads} | awk 'END {print NR/4}' \
        >> ${sample_id}.fastq_stats.txt
    """
}
