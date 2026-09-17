process TRIM_GALORE {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)
    
    output:
    tuple val(sample_id), path("*_val_1.fq.gz"), path("*_val_2.fq.gz"), emit: trimmed_reads
    path "${sample_id}*.txt", emit: reports

    script:
    """
    trim_galore \
        --paired \
        --gzip \
        ${reads[0]} ${reads[1]}
    """
}
