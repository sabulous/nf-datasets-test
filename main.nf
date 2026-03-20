nextflow.enable.dsl=2

params.input  = params.input ?: null
params.outdir = params.outdir ?: 'results'

process HEAD_TAIL {
    tag "${input_file.simpleName}"

    publishDir "${params.outdir}/${workflow.runName}", mode: 'copy'

    input:
    path input_file

    output:
    path "first3.txt"
    path "last3.txt"

    script:
    """
    head -n 3 ${input_file} > first3.txt
    tail -n 3 ${input_file} > last3.txt
    """
}

workflow {
    if( !params.input ) {
        error "Please provide --input"
    }

    ch_input = Channel.fromPath(params.input, checkIfExists: true)

    HEAD_TAIL(ch_input)
}
