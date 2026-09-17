nextflow.enable.dsl=2

include { FETCH_REFERENCE }         from './modules/fetch_reference'
include { FASTQC }                  from './modules/fastqc'
include { TRIM_GALORE }             from './modules/trim_galore'
include { FASTQC_TRIMMED }          from './modules/fastqc_trimmed'
include { PREPARE_REF_GENOME }      from './modules/prepare_ref_genome'
include { MULTIQC }                 from './modules/multiqc' 

workflow {
    // first get the reference files
    ref_fetch_ch = FETCH_REFERENCE()

    ch_fasta = ref_fetch_ch.fasta.first()
    ch_gtf   = ref_fetch_ch.gtf.first()

    // make STAR index from the fasta and gtf
    ch_star_idx = PREPARE_REF_GENOME(ch_fasta, ch_gtf).index.first()

    // all paired fastq files, names should match params.reads
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)

    // quick read quality check on original reads
    fastqc_ch = FASTQC(reads_ch)

    // trim adapters and low-quality bases
    trim_ch = TRIM_GALORE(reads_ch)
    
    // reconstruct paired-read channel
    trimmed_reads_ch = trim_ch.trimmed_reads.map { sample_id, r1, r2 ->
        tuple(sample_id, [r1, r2])
    }

    // quality check after trimming
    fastqc_trimmed_ch = FASTQC_TRIMMED(trimmed_reads_ch)

    // collect all QC outputs for MultiQC
    multiqc_ch = fastqc_ch
        .mix(fastqc_trimmed_ch)
        .mix(trim_ch.reports)
    MULTIQC(multiqc_ch.collect())
    
}


