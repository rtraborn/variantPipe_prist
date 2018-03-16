## This script in progress for testing on Carbonate
# must add routine to do with gff3 files
# current script will run, but encounters a 'segmentation fault' error

library(PopGenome)
library(bigmemory)
library(tools)

##########################################################################
vcfDir <- "/N/u/rtraborn/Carbonate/scratch/variantPipe/alignments/completed_vcfs/combined_vcf"
vcfFile <- "P_pacificus_combined.vcf"
myAnnot <- "/N/u/rtraborn/Carbonate/scratch/variantPipe/annotation/Hybrid2_AUGUSTUS2014_gene.gff3"
##########################################################################

setwd(vcfDir)

    #source("/N/dc2/projects/PromoterPopGen/DmPromoterPopGen/scripts/identifiers_to_list.R")
    #pop.list <- identifiers_to_list(csv.file=popListFile)
    GFF_split_into_scaffolds(myAnnot, "scaffoldGFFs")
    VCF_split_into_scaffolds(vcfFile, "TaylorSplit")	  
    GENOME.class <- readData("TaylorSplit", format="VCF", gffpath="scaffoldGFFs")
    GENOME.class
    MKT(GENOME.class)
q()
