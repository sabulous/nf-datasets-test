nextflow.enable.dsl=2

  params.input  = params.input ?: null
  params.outdir = params.outdir ?: 'results'

  process HEAD_TAIL {
      tag "${input_file.simpleName}"

      publishDir "${params.outdir}/${workflow.runName}", mode: 'copy'

      input:
      path input_file

      output:
      path "${workflow.sessionId.take(8)}_${workflow.runName}.txt"

      script:
      def outFile = "${workflow.sessionId.take(8)}_${workflow.runName}.txt"
      """
      {
          echo "=== First 3 lines ==="
          head -n 3 ${input_file}
          echo ""
          echo "=== Last 3 lines ==="
          tail -n 3 ${input_file}
      } > ${outFile}
      """
  }

  workflow {
      if( !params.input ) {
          error "Please provide --input"
      }

      ch_input = Channel.fromPath(params.input, checkIfExists: true)

      HEAD_TAIL(ch_input)
  }
