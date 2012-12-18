library(DNAcopy)
cn <- read.table("2825.copynumber.called",header=T)
CNA.object <-CNA( genomdat = cn[,7], chrom = cn[,1], maploc = cn[,2], data.type = 'logratio')
CNA.smoothed <- smooth.CNA(CNA.object)
segs <- segment(CNA.smoothed, verbose=0, min.width=2)
segs2 = segs$output
write.table(segs2[,2:6], file="2825.copynumber.called.cbs", row.names=F, col.names=T, quote=F, sep="\t")