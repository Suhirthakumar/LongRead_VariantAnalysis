process VARIANT_STATS {

    tag "${sample_id}"

    input:
    tuple val(sample_id), path(vcf), path(vcf_index)

    output:
    path "${sample_id}.bcftools.stats.txt"

    script:
    """
    bcftools stats \
        ${vcf} \
        > ${sample_id}.bcftools.stats.txt
    """
}
