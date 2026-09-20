process INDEX_REFERENCE {

    tag "Reference"

    input:
    path reference

    output:
    tuple path(reference), path("${reference}.fai"), emit: reference_bundle

    script:
    """
    samtools faidx ${reference}
    """
}
