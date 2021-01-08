
params.seqs = "${baseDir}/data/sh3.fasta"

params.outdir = 'results'

// Parameteres tcoffee
params.options = [:] //declare as empty
def arguments = params.options

log.info """
out_case   ---- $arguments.out_case
aln_format ---- $arguments.aln_format
outorder   ---- $arguments.outorder\n
"""

// params.case = 'upper'
// params.outorder = 'input'
// params.aln_format = 'score_html clustalw_aln fasta_aln score_ascii phylip' 
// output files should depen on the previous parameter

process TCOFFEE_REGULAR {
    container 'cbcrg/tcoffee@sha256:8894ba57a7ff34965d8febd51dcb7765b71314ca06893bc473d32e22032bf66f'
    tag "Regular tcoffee ${data_in.name}"
    publishDir "${params.outdir}/alignments", pattern: '*.fasta_aln'
    label 'aws'

    input:
    path data_in
    
    output:    
    path ("result.fasta_aln"), emit: fasta_aln    

    script:
    """
    t_coffee -in ${data_in} \
             -mode regular \
             -output=${arguments.aln_format} \
             -maxnseq=150 \
             -maxlen=10000 \
             -case=${arguments.out_case} \
             -seqnos=off \
             -outorder=${arguments.outorder} \
             -run_name=result \
             -multi_core=4 \
             -quiet=stdout > ${data_in}.tc_LOG  
    """
}

process TCOFFEE_MCOFFEE {
    container 'cbcrg/tcoffee@sha256:8894ba57a7ff34965d8febd51dcb7765b71314ca06893bc473d32e22032bf66f'
    tag "m-coffee ${data_in.name}"
    publishDir "${params.outdir}/alignments", pattern: '*.fasta_aln'

    input:
    path data_in
    
    output:    
    path ("result.fasta_aln"), emit: fasta_aln    

    script:
    """
    t_coffee -in ${data_in} \
             -mode mcoffee \
             -output=${arguments.aln_format} \
             -maxnseq=150 \
             -maxlen=10000 \
             -case=${arguments.out_case} \
             -seqnos=off \
             -outorder=${arguments.outorder} \
             -run_name=result \
             -multi_core=4 \
             -quiet=stdout > ${data_in}.tc_LOG  
    """
} 

process FOO {
    container 'biocontainers/biocontainers:vdebian-stretch-backports_cv2'
    output:
    path 'foo.txt'
    
    script:
    """
    echo "Hello" > foo.txt
    """
}

 process BAR {
    container 'biocontainers/biocontainers:vdebian-stretch-backports_cv2'
    input:
    path x
    
    output:
    path 'bar.txt'
    
    script:
    """
    cat $x > bar.txt
    echo " World" >> bar.txt
    """
}