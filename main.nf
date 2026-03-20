nextflow.enable.dsl=2

params.input  = params.input ?: null
params.outdir = params.outdir ?: 'results'

process HEAD_TAIL {
  tag "${input_file.simpleName}"

  publishDir "${params.outdir}", mode: 'copy'

  input:
  path input_file

  output:
  path "*.txt"

  script:
  """
  run_id=\${TOWER_WORKFLOW_ID:-${workflow.sessionId}}
  {
      echo "=== First 3 lines ==="
      head -n 3 ${input_file}
      echo ""
      echo "=== Last 3 lines ==="
      tail -n 3 ${input_file}
  } > \${run_id}.txt
  """
}

workflow {
    if( !params.input ) {
        error "Please provide --input"
    }

    ch_input = Channel.fromPath(params.input, checkIfExists: true)

    HEAD_TAIL(ch_input)
}
