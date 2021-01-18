nextflow.preview.dsl=2

/*
 * T-Coffee DSL2 nextflow workflow design to work as the t-coffee server backend
 *
 * Authors:
 * - Jose Espinosa-Carrasco <espinosacarrascoj@gmail.com>
 * - Edgar Garriga <edgano@gmail.com>
 */

// MODE should be the parameter to control the execution of the workflow
// All data should be consistently named data_hash.in

// params.mode = "tcoffee_regular"
params.mode = "mcoffee"

// params.seqs = 'https://raw.githubusercontent.com/edgano/datasets-test/tcoffee_protocols/sh3.fasta'
params.seqs = "${baseDir}/data/sh3.fasta"

params.outdir = 'results'

// Parameteres tcoffee
// params.case = 'upper'
// params.outorder = 'input'
// params.aln_format = 'score_html clustalw_aln fasta_aln score_ascii phylip' 
// output files should depen on the previous parameter
// params.modules = [:]
// params.modules.shared = [:]
// params.modules.shared.case = 'upper'

// Don't overwrite global params.modules, create a copy instead and use that within the main script.
def modules = params.modules.clone()

log.info """
modules.shared.aln_format   ----====== ${params.modules.shared.aln_format}
"""
// params.modules.tcoffee_regular = [:]
// params.modules.tcoffee_regular.case
// =${params.case}

include { TCOFFEE_REGULAR; TCOFFEE_MCOFFEE; FOO; BAR } from './modules/process/tcoffee_regular' addParams( options: modules['shared'] )

data_in = Channel.fromPath ( params.seqs, checkIfExists: true )//.map { item -> [ item.baseName, item] }

workflow tcoffee_server_pipeline {

    main:
    tcoffee_result = Channel.empty()

    if (params.mode == "tcoffee_regular") {
        tcoffee_result = TCOFFEE_REGULAR (data_in)
    }
        
    if (params.mode == "mcoffee") {
        tcoffee_result = TCOFFEE_MCOFFEE (data_in)
    }
    
    FOO()
    BAR(FOO.out)
    
    emit:
    tcoffee_result
}

workflow {
  tcoffee_server_pipeline()
  tcoffee_server_pipeline.out.tcoffee_result.view()
}
