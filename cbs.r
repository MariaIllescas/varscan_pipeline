library(DNAcopy)
cn <- read.table("varScan.copynumber.called",header=T)
CNA.object <-CNA( genomdat = cn[,6], chrom = cn[,1], maploc = cn[,2], data.type = 'logratio')
CNA.smoothed <- smooth.CNA(CNA.object)
segs <- segment(CNA.smoothed, verbose=0, min.width=2)
segs2 = segs$output
write.table(segs2[,2:6], file="out.cbs", row.names=F, col.names=F, quote=F, sep="\t")
