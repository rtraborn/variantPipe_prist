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
pristFaFile <- "/N/dc2/scratch/rtraborn/variantPipe/pacificus_Hybrid2.fasta"
##########################################################################

setwd(vcfDir)

    source("/N/u/rtraborn/Carbonate/scratch/variantPipe/identifiers_to_list.R")
    pop.list <- identifiers_to_list(csv.file=popListFile)
    GFF_split_into_scaffolds(myAnnot, "scaffoldGFFs")
    VCF_split_into_scaffolds(vcfFile, "TaylorSplit")
    GENOME.class <- readData("TaylorSplit", format="VCF", gffpath="scaffoldGFFs")
    GENOME.class <- set.populations(GENOME.class, new.populations=pop.list, diploid=TRUE)  
    GENOME.class <- set.synnonsyn(GENOME.class, ref.chr=pristFaFile, save.codons=TRUE)
    GENOME.class@region.data@synonymous
    GENOME.class.split <- splitting.data(GENOME.class, subsites="gene")
    #GENOME.class.split <- neutrality.stats(GENOME.class.split)
    GENOME.class.split <- MKT(GENOME.class.split)
    mkt_pp <- get.MKT(GENOME.class.split)
    write.table(mkt_pp, file="mkt_pp_out.txt",col.names=TRUE)
q()
