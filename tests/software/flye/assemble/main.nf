#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FLYE_ASSEMBLE } from '../../../../software/flye/assemble/main.nf' addParams( options: [:] )

workflow test_flye_assemble {
    
    input = [ [ id:'test', single_end:false ], // meta map
              file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true) ]

    FLYE_ASSEMBLE ( input )
}
