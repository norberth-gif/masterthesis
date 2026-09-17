process PREPARE_REF_GENOME {
    tag "Building STAR Index"

    input:
    path genome_fa
    path gtf

    output:
    path "star_index", emit: index

    script:
    """
    mkdir star_index

    STAR --runMode genomeGenerate \\
         --genomeDir star_index \\
         --genomeFastaFiles ${genome_fa} \\
         --sjdbGTFfile ${gtf} \\
         --sjdbOverhang ${params.star.sjdb_overhang} \\
         --runThreadN ${task.cpus}
    """
}
