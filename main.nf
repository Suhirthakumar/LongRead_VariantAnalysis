nextflow.enable.dsl=2

include { FASTQ_QC } from './modules/fastq_qc.nf'
include { INDEX_REFERENCE } from './modules/reference.nf'
include { ALIGN } from './modules/alignment.nf'
include { BAM_QC } from './modules/bam_qc.nf'
include { CLAIR3 } from './modules/clair3.nf'
include { VARIANT_STATS } from './modules/variant_stats.nf'
include { BENCHMARK } from './modules/benchmark.nf'


workflow {

    /*
     * ---------------------------------------------------------
     * Static input files
     * ---------------------------------------------------------
     */

    reference = file(params.reference, checkIfExists: true)
    reference_index = file("${params.reference}.fai", checkIfExists: true)

    truth_vcf = file(params.truth_vcf, checkIfExists: true)
    truth_vcf_index = file("${params.truth_vcf}.tbi", checkIfExists: true)

    truth_bed = file(params.truth_bed, checkIfExists: true)


    /*
     * Target region for Clair3
     *
     * chr20:100000-300000
     */

    target_bed = file(params.target_bed, checkIfExists: true)


    /*
     * ---------------------------------------------------------
     * FASTQ input
     * ---------------------------------------------------------
     */

    reads_ch = Channel
        .fromPath(params.reads, checkIfExists: true)
        .map { reads ->
            tuple(params.sample, reads)
        }


    /*
     * ---------------------------------------------------------
     * Step 1: FASTQ QC
     * ---------------------------------------------------------
     */

    FASTQ_QC(reads_ch)


    /*
     * ---------------------------------------------------------
     * Step 2: Reference indexing
     * ---------------------------------------------------------
     */

    reference_ch = Channel
        .fromPath(params.reference, checkIfExists: true)

    reference_bundle = INDEX_REFERENCE(reference_ch)


    /*
     * ---------------------------------------------------------
     * Step 3: Alignment
     * ---------------------------------------------------------
     */

    align_input = reads_ch.map { sample_id, reads ->
        tuple(
            sample_id,
            reads,
            reference
        )
    }

    aligned = ALIGN(align_input)


    /*
     * ---------------------------------------------------------
     * Step 4: BAM QC
     * ---------------------------------------------------------
     */

    BAM_QC(aligned)


    /*
     * ---------------------------------------------------------
     * Step 5: Clair3
     * ---------------------------------------------------------
     */

    clair3_input = aligned.map {
    sample_id,
    bam,
    bai ->

    tuple(
        sample_id,
        bam,
        bai,
        reference,
        reference_index,
        target_bed
    )
    }

    variants = CLAIR3(clair3_input)


    /*
     * ---------------------------------------------------------
     * Step 6: Variant statistics
     * ---------------------------------------------------------
     */

    VARIANT_STATS(variants)


    /*
     * ---------------------------------------------------------
     * Step 7: Benchmark against GIAB truth set
     * ---------------------------------------------------------
     */

    benchmark_input = variants.map {
        sample_id,
        query_vcf,
        query_vcf_index ->

        tuple(
            sample_id,
            query_vcf,
            query_vcf_index,
            truth_vcf,
            truth_vcf_index,
            truth_bed,
            reference,
            reference_index
        )
    }

    BENCHMARK(benchmark_input)
}
