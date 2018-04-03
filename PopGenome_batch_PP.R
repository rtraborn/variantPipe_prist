## This script in progress for testing on Carbonate
# must add routine to do with gff3 files
# current script will run, but encounters a 'segmentation fault' error

library(PopGenome)
library(bigmemory)
library(tools)

##########################################################################
vcfDir <- "/N/u/rtraborn/Carbonate/scratch/variantPipe/alignments/completed_vcfs/combined_vcf"
vcfFile <- "P_pacificus_combined.vcf"
myAnnot <- "/N/u/rtraborn/Carbonate/scratch/variantPipe/annotation/Hybrid2_AUGUSTUS2014_CDS_final.gff3"
popListFile <- "/N/dc2/scratch/rtraborn/variantPipe/pop_info/PP_popInfo.csv"
pristFaFile <- "/N/dc2/scratch/rtraborn/variantPipe/fasta/pacificus_Hybrid2.fasta"
#pristFaFile <- "/N/dc2/scratch/rtraborn/variantPipe/pacificus_Hybrid2_first10.fa"
pristFasta <- "/N/u/rtraborn/Carbonate/scratch/variantPipe/fasta/PP_scaffolds_test"
##########################################################################

setwd(vcfDir)

    source("/N/u/rtraborn/Carbonate/scratch/variantPipe/identifiers_to_list.R")
    pop.list <- identifiers_to_list(csv.file=popListFile)
    GFF_split_into_scaffolds(myAnnot, "scaffoldGFFs")
    VCF_split_into_scaffolds(vcfFile, "TaylorSplit")
    #GENOME.class <- readData("TaylorSplit", format="VCF", gffpath="scaffoldGFFs")
    GENOME.class <- readData("TaylorSplit", format="VCF", gffpath="scaffoldGFFs")
    GENOME.class <- set.populations(GENOME.class, new.populations=pop.list, diploid=TRUE)  
    GENOME.class <- neutrality.stats(GENOME.class)
    GENOME.class <- set.synnonsyn(GENOME.class, save.codons=TRUE, ref.chr=rep(pristFaFile, length(GENOME.class@region.names)))
    GENOME.class@region.data@synonymous
    GENOME.class.split <- splitting.data(GENOME.class, subsites="gene")
    GENOME.class.split <- neutrality.stats(GENOME.class.split)
    #GENOME.class.split@region.data@synonymous
    GENOME.class.split <- set.synnonsyn(GENOME.class.split, save.codons=TRUE, ref.chr=pristFaFile)
    GENOME.class.split@region.data@synonymous
    GENOME.class.split <- MKT(GENOME.class.split)
    mkt_pp <- get.MKT(GENOME.class.split)
    write.table(mkt_pp, file="mkt_pp_out.txt",col.names=TRUE)
q()
