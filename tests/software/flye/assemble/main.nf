#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FLYE_ASSEMBLE } from '../../../../software/flye/assemble/main.nf' addParams( options: [:] )

workflow test_flye_assemble {

    input = [ [ id:'test' ], // meta map
              file(params.test_data['sarscov2']['nanopore']['test_fastq_gz'], checkIfExists: true)
            ]

    FLYE_ASSEMBLE ( input, 'nanopore', 'raw' )
}
