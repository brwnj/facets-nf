nextflow.enable.dsl=2

params.help = false
if (params.help) {
    log.info """
    -----------------------------------------------------------------------

    r-facets
    ========

    Documentation and issues can be found at:
    https://github.com/brwnj/facets-nf

    Required arguments:
    -------------------

    --tumor     path to tumor cram/bam(s). when more than one, use
                wildcard syntax with single quotes ('/path/*.cram')
    --normal    path to normal cram/bam
    --vcf       snp locations VCF. see:
                https://github.com/mskcc/facets/tree/master/inst/extcode

    -----------------------------------------------------------------------
    """.stripIndent()
    exit 0
}

params.tumor = false
params.normal = false
params.vcf = false

if(!params.tumor) {
    exit 1, "--tumor argument like '/path/to/*.cram' is required"
}
if(!params.normal) {
    exit 1, "--normal argument like /path/to/normal.cram is required"
}
if(!params.vcf) {
    exit 1, "--vcf argument is required"
}

process snp_pileup {
    input:
    path(vcf)
    path(normal)
    path(tumor)

    output:
    path("snp-pileup.csv.gz"), emit: matrix

    script:
    """
    snp-pileup --gzip $vcf snp-pileup.csv.gz $normal $tumor
    """
}

process r_facets {
    publishDir "${params.outdir}", mode: 'symlink'

    input:
    path(matrix)

    output:
    path("facets.rdata"), emit: rdata
    path("facets.cncf"), emit: cncf
    path("facets.pdf"), emit: pdf
    path("log.txt"), emit: log

    script:
    template 'facets.R'
}

workflow {
    tumor_ch = Channel.fromPath(params.tumor, checkIfExists: true)
    snp_pileup(params.vcf, params.normal, tumor_ch.collect())
    r_facets(snp_pileup.out.matrix)
}
