process BENCHMARK {

    tag "${sample_id}"

    container 'jmcdani20/hap.py:v0.3.12'

    input:
    tuple val(sample_id),
          path(query_vcf),
          path(query_vcf_index),
          path(truth_vcf),
          path(truth_vcf_index),
          path(truth_bed),
          path(reference),
          path(reference_index)

    output:
    path "happy"

    script:
    """
    mkdir -p happy

    /opt/hap.py/bin/hap.py \
        ${truth_vcf} \
        ${query_vcf} \
        -f ${truth_bed} \
        -r ${reference} \
        -o happy/${sample_id} \
        -l chr20:100000-300000 \
        --engine=vcfeval \
        --threads=${task.cpus} \
        --pass-only
    """
}
