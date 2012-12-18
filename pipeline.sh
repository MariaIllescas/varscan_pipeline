!#/bin/bash

# INPUT:
#  $1 - reference genome in FASTA format
#  $2 - normal BAM file
#  $3 - tumor BAM file
#

n_name=`basename $2 .bam`
t_name=`basename $3 .bam`
cn_base="$n_name-$t_name"
cn_name="$cn_base.copynumber"
cnc_name="$cn_name.called"
cbs_name="$cn_base.cbs"

echo "Normal BAM file: $n_name"
echo "Tumor BAM file: $t_name"
echo "VarScan copynumber output file: $cn_name"
echo "VarScan copycaller output file: $cnc_name"
echo "CBS output file: $cbs_name"
echo "..."
echo ""

#-----------------------------------------------------
echo "STEP 1 -- SAMTOOLS pileup of Normal/Tumor sample pair"

#samtools mpileup -q 1 -f $1 $2 $3 | tee sample_mpileup | java -jar VarScan.jar copynumber --mpileup 1
#samtools mpileup -q 1 -f $1 $2 $3 | java -jar VarScan.jar copynumber - varScan --mpileup 1
samtools mpileup -q 1 -f $1 $2 $3 | java -jar VarScan.jar copynumber - $cn_base --mpileup 1

#-------------------------------------------------------------------
echo "STEP 2 -- refinement/adjusting for GC content and preliminary calls"

#java -jar VarScan.jar copyCaller varScan.copynumber --output-file varScan.copynumber.called
java -jar VarScan.jar copyCaller $cn_name --output-file varScan.copynumber.called

#-------------------------------------------------------------------
echo "STEP 3 -- apply circular binary segmentation (CBS) using the DNAcopy library from BioConductor"

R CMD BATCH cbs.r
mv varScan.copynumber.called $cnc_name
mv varScan.copynumber.called.gc "$cnc_name.gc"
mv out.cbs $cbs_name

#-------------------------------------------------------------------
#echo "STEP 4 -- Merge adjacent segments of similar copy number and classify events by size"

#perl mergeSegments.pl cbs.out

