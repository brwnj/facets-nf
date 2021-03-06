#!/usr/bin/env Rscript
library(facets)

set.seed(1234)
rcmat = readSnpMatrix("$matrix")
xx = preProcSample(rcmat, ndepth=15)
oo = procSample(xx, min.nhet=5)
fit = emcncf(oo)

fileConn <- file("log.txt")
writeLines(c("ploidy", fit\$ploidy, "purity", fit\$purity), fileConn)
close(fileConn)

save(xx, oo, fit, file="facets.rdata")

write.table(fit\$cncf, "facets.cncf", sep="\\t", row.names=FALSE, col.names=TRUE, quote=FALSE)
pdf("facets.pdf");
plotSample(x=oo, emfit=fit)
dev.off();
