#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { RAVEN } from '../../../modules/raven/main.nf' addParams( options: [:] )

workflow test_raven {
    
    input = [ [ id:'test' ], // meta map
              file(params.test_data['bacteroides_fragilis']['nanopore']['test_fastq_gz'], checkIfExists: true) ]

    RAVEN ( input )
}
