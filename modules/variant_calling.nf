process CLAIR3 {

    tag "HG003"

    container 'hkubal/clair3:v2.0.2'

    input: tuple path(bam), path(bai), path(reference), path(reference_index)

    output: path "clair3_output/merge_output.vcf.gz", emit: vcf path "clair3_output/merge_output.vcf.gz.tbi", emit: 
    vcf_index

    script: """ mkdir -p clair3_output

    /opt/bin/run_clair3.sh \ --bam_fn=${bam} \ --ref_fn=${reference} \ --threads=${task.cpus} \ --platform=ont \ 
        --model_path=/opt/models/ont \ --output=clair3_output \ --include_all_ctgs
    """
}
