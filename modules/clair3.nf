process CLAIR3 {

    tag "${sample_id}"

    container 'hkubal/clair3:v2.0.2'

    input:
    tuple val(sample_id),
          path(bam),
          path(bai),
          path(reference),
          path(reference_index),
          path(target_bed)

    output:
    tuple val(sample_id),
          path("clair3_output/merge_output.vcf.gz"),
          path("clair3_output/merge_output.vcf.gz.tbi"),
          emit: variants

    script:
    """
    mkdir -p clair3_output

    /opt/bin/run_clair3.sh \
        --bam_fn=${bam} \
        --ref_fn=${reference} \
        --threads=${task.cpus} \
        --platform=ont \
        --model_path=/opt/models/ont \
        --output=clair3_output \
        --bed_fn=${target_bed}
    """
}
