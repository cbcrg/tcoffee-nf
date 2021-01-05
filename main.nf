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

params.mode = "tcoffee"
// params.seqs = 'https://raw.githubusercontent.com/edgano/datasets-test/tcoffee_protocols/sh3.fasta'
params.seqs = "${baseDir}/data/sh3.fasta"

params.outdir = 'results'

// Parameteres tcoffee
params.case = 'upper'
params.outorder = 'input'
params.aln_format = 'score_html clustalw_aln fasta_aln score_ascii phylip' 
// output files should depen on the previous parameter

include { TCOFFEE_REGULAR; FOO; BAR } from './modules/process/tcoffee_regular'

data_in = Channel.fromPath ( params.seqs, checkIfExists: true )//.map { item -> [ item.baseName, item] }
          
workflow {
    TCOFFEE_REGULAR (data_in)
    FOO()
    BAR(FOO.out)
}
