process FASTQC_TRIMMED {
    tag "$sample_id"
    publishDir "${params.outdir}/fastqc_trimmed", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "*.{html,zip}"

    script:
    """
    fastqc ${reads[0]} ${reads[1]}
    """
}
