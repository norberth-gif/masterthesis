process ASTOOL {

    tag "${sam.simpleName}"

    container 'ghcr.io/norberth-gif/astool_nextflow_image:v1'

    input:
    path gtf
    path sam

    output:
    path "junction"
    path "IR_PSI.txt"
    path "ES_PSI.txt"
    path "A5SS_PSI.txt"
    path "A3SS_PSI.txt"

    script:
    """
    perl /opt/ASTool/junction_count.pl \
        --gtf ${gtf} \
        --sam ${sam} \
        --thread 16 \
        --readlength 101 \
        --m 10 \
        --outdir junction

    perl /opt/ASTool/IR_PSI.pl \
        --junction junction/junction_count.txt \
        --gtf ${gtf} \
        --m 10 \
        --outdir IR_PSI.txt

    perl /opt/ASTool/ES_PSI.pl \
        --junction junction/junction_count.txt \
        --gtf ${gtf} \
        --m 10 \
        --outdir ES_PSI.txt

    perl /opt/ASTool/A5SS_A3SS_PSI.pl \
        --junction junction/junction_count.txt \
        --gtf ${gtf} \
        --m 10 \
        --A5SS_outdir A5SS_PSI.txt \
        --A3SS_outdir A3SS_PSI.txt
    """
}
