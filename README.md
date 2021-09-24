# facets-nf
nextflow implementation of the facets data flow.

# usage

For `vcf`, see the docs over at:

https://github.com/mskcc/facets/tree/master/inst/extcode

```
nextflow run brwnj/facets-nf -r v1.0.0 -profile docker \
    --vcf common_all.vcf.gz \
    --normal normal.recal.bam \
    --tumor tumor.recal.bam
```

# results

The workflow runs `snp-pileup` and generates:

+ facets.cncf
+ facets.pdf
+ facets.rdata
