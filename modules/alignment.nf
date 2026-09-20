process ALIGN {

    tag "${sample_id}"

    input:
    tuple val(sample_id), path(reads), path(reference)

    output:
    tuple val(sample_id),
          path("${sample_id}.sorted.bam"),
          path("${sample_id}.sorted.bam.bai"),
          emit: alignment

    script:
    """
    minimap2 \
        -t ${task.cpus} \
        -ax map-ont \
        ${reference} \
        ${reads} \
        | samtools sort \
        -@ ${task.cpus} \
        -o ${sample_id}.sorted.bam

    samtools index \
        ${sample_id}.sorted.bam
    """
}
