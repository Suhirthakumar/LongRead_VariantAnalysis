process BAM_QC {

    tag "${sample_id}"

    input:
    tuple val(sample_id), path(bam), path(bai)

    output:
    path "${sample_id}.flagstat.txt", emit: flagstat
    path "${sample_id}.coverage.txt", emit: coverage

    script:
    """
    samtools flagstat \
        ${bam} \
        > ${sample_id}.flagstat.txt

    samtools coverage \
        ${bam} \
        > ${sample_id}.coverage.txt
    """
}
