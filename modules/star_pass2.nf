process STAR_PASS2 {

    tag "$sample_id"
    publishDir "${params.outdir}/star", mode: 'copy'
    input:
    tuple val(sample_id), path(reads), path(junctions)
    path star_index
    path annotation

    output:
    tuple val(sample_id), path("${sample_id}_Aligned.sortedByCoord.out.bam"), emit: bam
    path "${sample_id}_Log.final.out", emit: log

    script:
    """
    STAR \
        --genomeDir ${star_index} \
        --runThreadN ${task.cpus} \
        --readFilesIn ${reads[0]} ${reads[1]} \
        --sjdbGTFfile ${annotation} \
        --sjdbFileChrStartEnd ${junctions} \
        --readFilesCommand gunzip -c \
        --outFileNamePrefix ${sample_id}_ \
        --outSAMtype BAM Unsorted SortedByCoordinate \
        --outSAMunmapped Within \
        --quantMode TranscriptomeSAM GeneCounts \
        --outSAMstrandField intronMotif \
        --outSAMattributes NH HI AS nM NM MD jM jI MC ch XS \
        --outFilterScoreMinOverLread 0.5 \
        --outFilterMatchNminOverLread 0.5
    """
}
