## This script in progress for testing on Carbonate
# must add routine to do with gff3 files
# current script will run, but encounters a 'segmentation fault' error

library(PopGenome)
library(bigmemory)
library(tools)

##########################################################################
vcfDir <- "/N/u/rtraborn/Carbonate/scratch/variantPipe/el_paco_vcf"
vcfFile <- "P_pacificus_combined.vcf"
myAnnot <- "/N/u/rtraborn/Carbonate/scratch/variantPipe/annotation/El_Paco_gene_annotations_v1_gene_CDS.gff"
popListFile <- "/N/dc2/scratch/rtraborn/variantPipe/pop_info/PP_popInfo_updated.csv"
pristFaFile <- "/N/dc2/projects/Pristionchus/MKT_shared/El_Paco_genome.fa"
#pristChr <- c("ChrI.fa","ChrII.fa","ChrIII.fa","ChrIV.fa","ChrV.fa","ChrX.fa", "pbcontig117.fa","pbcontig118.fa","pbcontig2839.fa","pbcontig2855.fa","pbcontig2856.fa","pbcontig2858.fa","pbcontig2865.fa","pbcontig2867.fa","pbcontig2876.fa","pbcontig2879.fa","pbcontig2880.fa","pbcontig2881.fa","pbcontig2882.fa","pbcontig2884.fa","pbcontig2886.fa","pbcontig2887.fa","pbcontig2890.fa","pbcontig2894.fa","pbcontig2897.fa","pbcontig2898.fa","pbcontig2.fa","pbcontig323.fa","pbcontig410.fa","pbcontig508.fa","pbcontig514.fa","pbcontig517.fa","pbcontig519.fa","pbcontig544.fa","pbcontig585.fa","pbcontig627.fa","pbcontig654.fa","pbcontig660.fa","pbcontig695.fa","pbcontig709.fa","pbcontig710.fa","pbcontig72.fa","pbcontig741.fa","pbcontig744.fa","pbcontig745.fa","pbcontig759.fa","pbcontig787.fa")
##########################################################################

setwd(vcfDir)

    source("/N/u/rtraborn/Carbonate/scratch/variantPipe/identifiers_to_list.R")
    pop.list <- identifiers_to_list(csv.file=popListFile)

    GFF_split_into_scaffolds(myAnnot, "scaffoldGFFs")
    VCF_split_into_scaffolds(vcfFile, "TaylorSplit")

    GENOME.class <- readData("TaylorSplit", format="VCF", gffpath="scaffoldGFFs", include.unknown=TRUE)
    GENOME.class <- set.populations(GENOME.class, new.populations=pop.list, diploid=TRUE)  
    #save(GENOME.class, file="GENOME.class_test.RData")   
    #save.session(GENOME.class, "GENOME.class_test")   

    pristChr <- GENOME.class@region.names
    GENOME.class <- set.synnonsyn(GENOME.class, save.codons=FALSE, ref.chr=pristChr)
    GENOME.class <- neutrality.stats(GENOME.class)
    save(GENOME.class, file="GENOME.class_test.RData")
    GENOME.class@region.data@synonymous
    GENOME.class.split <- splitting.data(GENOME.class, subsites="gene", whole.data=FALSE)
    GENOME.class.split <- neutrality.stats(GENOME.class.split)
    GENOME.class.split@region.data@synonymous
    GENOME.class.split <- MKT(GENOME.class.split)
    mkt_pp <- get.MKT(GENOME.class.split)
    write.table(mkt_pp, file="mkt_pp_out.txt",col.names=TRUE)
q()
