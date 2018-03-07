## This script in progress for testing on Carbonate
# must add routine to do with gff3 files
# current script will run, but encounters a 'segmentation fault' error

library(PopGenome)
library(bigmemory)
library(tools)

##########################################################################
vcfDir <- "/N/u/rtraborn/Carbonate/scratch/variantPipe/alignments/completed_vcfs/combined_vcf"
myFile <- "/N/u/rtraborn/Carbonate/scratch/variantPipe/alignments/completed_vcfs/P_pacificus_strains.vcf.gz"
##########################################################################

setwd(vcfDir)

#source("/N/dc2/projects/PromoterPopGen/DmPromoterPopGen/scripts/identifiers_to_list.R")
#pop.list <- identifiers_to_list(csv.file=popListFile)
	  
    GENOME.class <- readData(path=vcfDir, populations=FALSE, format="VCF", parallized=FALSE, FAST=TRUE, big.data=TRUE)
    GENOME.class 
    #GENOME.class <- readVCF(filename=myFile, numcols=100000, frompos=1, topos=1000000, tid="scaffold1")
    #GENOME.class <- set.populations(GENOME.class, new.populations=pop.list, diploid=TRUE)  
    #split <- split_data_into_GFF_features(GENOME.class, gff.file=gffFile, chr=this.chr, feature="gene")
    }
    
}
