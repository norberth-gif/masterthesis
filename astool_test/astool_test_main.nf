nextflow.enable.dsl=2

include { FETCH_REFERENCE } from './modules/fetch_reference'
include { ASTOOL } from './modules/astool'

workflow {

    reference = FETCH_REFERENCE()

    sam = channel.fromPath(
        '/path/to/your/sample_Aligned.sortedByCoord.out.sam',
        checkIfExists: true
    )

    ASTOOL(
        reference.gtf,
        sam
    )
}
