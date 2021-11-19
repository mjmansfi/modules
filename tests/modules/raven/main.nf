#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { RAVEN } from '../../../modules/raven/main.nf' addParams( options: [:] )

workflow test_raven {
    
<<<<<<< HEAD
    input = [ [ id:'test' ], // meta map
              file(params.test_data['bacteroides_fragilis']['nanopore']['test_fastq_gz'], checkIfExists: true) ]
=======
    input = [ 
              [ id:'test', single_end:false ], // meta map
              [ file(params.test_data['bacteroides_fragilis']['nanopore']['test_fastq_gz'], checkIfExists: true) ] 
            ]
>>>>>>> 6f3424694734690b9aee8b12f3a21104eb454add

    RAVEN ( input )
}
