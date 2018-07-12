
## This script in progress for testing on Carbonate
# must add routine to do with gff3 files
# current script will run, but encounters a 'segmentation fault' error

library(PopGenome)
library(bigmemory)
library(tools)

##########################################################################
vcfDir <- "/N/dc2/projects/Pristionchus/LBUI/Pop_gene/variantPipe_prist/vcf_out"
vcfFile <- "Ppacificus_filtered.recode.vcf"
Pexs <- "SRR646204_output.g.vcf"
myAnnot <- "/N/dc2/projects/Pristionchus/LBUI/Pop_gene/PopGenome_scripts/El_Paco_gene_annotations_v1_gene_CDS.gff" 
popListFile <- "/N/dc2/projects/Pristionchus/LBUI/Pop_gene/PopGenome_scripts/Pop_info_updated.csv"
pristFaFile <- "El_Paco_genome.fa"
pristChr <- c("ChrI.fa","ChrII.fa","ChrIII.fa","ChrIV.fa","ChrV.fa","ChrX.fa","pbcontig118.fa","pbcontig2855.fa","pbcontig2858.fa","pbcontig2867.fa","pbcontig2880.fa","pbcontig2881.fa","pbcontig2886.fa","pbcontig2887.fa","pbcontig2890.fa","pbcontig2894.fa","pbcontig2897.fa","pbcontig517.fa","pbcontig627.fa","pbcontig654.fa","pbcontig660.fa","pbcontig695.fa","pbcontig710.fa","pbcontig72.fa","pbcontig759.fa")
##########################################################################

setwd(vcfDir)

    source("/N/dc2/projects/Pristionchus/LBUI/Pop_gene/PopGenome_scripts/identifiers_to_list.R")
    pop.list <- identifiers_to_list(csv.file=popListFile)

   #GFF_split_into_scaffolds(myAnnot, "scaffoldGFFs")
    #VCF_split_into_scaffolds(vcfFile, "VCFSplit")

    GENOME.class <- readData("VCFSplit", format="VCF", gffpath="scaffoldGFFs", include.unknown=TRUE)
    get.sum.data(GENOME.class)
    get.individuals(GENOME.class)
    GENOME.class <- set.populations(GENOME.class, new.populations=pop.list, diploid=TRUE)  
    #outgroup <- c("Control")
    GENOME.class <- set.outgroup(GENOME.class, c("SRR646204"), diploid =TRUE)
    save(GENOME.class, file="GENOME.class_test.RData")   
    #save.session(GENOME.class, "GENOME.class_test")   
    #pristChr <- GENOME.class@region.names
    GENOME.class <- set.synnonsyn(GENOME.class, save.codons=FALSE, ref.chr=pristChr)
    GENOME.class <- neutrality.stats(GENOME.class, new.outgroup=FALSE, detail=TRUE, do.R2=TRUE, subsites="syn")
    GENOME.class <- diversity.stats(GENOME.class)
     GENOME.class@region.stats@nucleotide.diversity
    save(GENOME.class, file="GENOME.class.RData")
    EuR.sum <- get.sum.data(GENOME.class)
    write.table(EuR.sum, file = "EuR.sum.csv", sep = "\t")
    EuR.Tajima <- GENOME.class@Tajima.D
    write.table(EuR.Tajima, file = "EuR.Tajima.csv")
    GENOME.class@region.data@synonymous
    GENOME.class.split <- splitting.data(GENOME.class, subsites="gene", whole.data=FALSE)
    GENOME.class.split <- neutrality.stats(GENOME.class.split)
    GENOME.class.split@region.data@synonymous
    GENOME.class.split <- MKT(GENOME.class.split, do.fisher.test=TRUE)
    mkt_pp <- get.MKT(GENOME.class.split)
    write.table(mkt_pp, file="EuR_mkt_pp_out.txt",col.names=TRUE, sep = "\t")
    EuR.genes <- GENOME.class.split@region.names
    write.table(EuR.genes, file = "EuR.genes.csv", sep = "\t")
    EuR.Tajima.split <- GENOME.class.split@Tajima.D
    write.table(EuR.Tajima.split, file = "EuR.Tajima.split.csv", sep = "\t")
q()
