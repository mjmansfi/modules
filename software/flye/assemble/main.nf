// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'


params.options = [:]
options        = initOptions(params.options)

process FLYE_ASSEMBLE {
    tag "$meta.id"
    label 'process_high'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:meta, publish_by_meta:['id']) }

    conda (params.enable_conda ? "bioconda::flye=2.8.3" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/flye:2.8.3--py27h6a42192_1"
    } else {
        container "quay.io/biocontainers/flye:2.8.3--py27h6a42192_1"
    }

    input:
    tuple val(meta), path(reads)
    val read_type
    val read_correction_level

    output:
    tuple val(meta), path("*/*.fasta"), emit: fasta
    tuple val(meta), path("*/*.gfa"), emit: gfa
    tuple val(meta), path("*/*.gv"), emit: gv
    tuple val(meta), path("*/*.log"), emit: log
    path "*.version.txt"            , emit: version

    script:
    def software = getSoftwareName(task.process)
    def prefix   = options.suffix ? "${meta.id}${options.suffix}" : "${meta.id}"

    if (read_type == "pacbio"){
        if (read_correction_level == "raw"){
            input_reads_flag = "--pacbio-raw"
        } else if (read_correction_level == "corrected") {
            input_reads_flag = "--pacbio-corr"
        } else if (read_correction_level == "hifi") {
            input_reads_flag = "--pacbio-hifi"
        }
    } else if (read_type == "nanopore") {
        if (read_correction_level == "raw"){
            input_reads_flag = "--nano-raw"
        } else if (read_correction_level == "corrected") {
            input_reads_flag = "--nano-corr"
        }
    }
    """
    flye \\
        $options.args \\
        --threads $task.cpus \\
        --out-dir ${prefix} \\
        $input_reads_flag $reads

    mv "${prefix}"/assembly.fasta "${prefix}"/"${prefix}".assembly.fasta
    mv "${prefix}"/assembly_graph.gfa "${prefix}"/"${prefix}".assembly_graph.gfa
    mv "${prefix}"/assembly_graph.gv "${prefix}"/"${prefix}".assembly_graph.gv
    mv "${prefix}"/flye.log "${prefix}"/"${prefix}".flye.log

    echo \$(flye --version 2>&1) > ${software}.version.txt
    """
}
