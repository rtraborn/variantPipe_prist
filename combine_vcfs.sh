#!/bin/bash

#PBS -N Prist_variant_calling_GATK
#PBS -k o
#PBS -l nodes=1:ppn=24,vmem=100gb
#PBS -l walltime=12:00:00
#PBS -m abe

workingdir=/N/dc2/scratch/rtraborn/variantPipe
refDir=/N/dc2/scratch/rtraborn/variantPipe/fasta
alnDir=alignments/completed_vcfs
PP_ref=pacificus_Hybrid2.fasta
vcfList=/N/dc2/scratch/rtraborn/variantPipe/prist_vcfs.list
nThreads=16

gatk='java -jar /N/soft/rhel7/gatk/3.8/GenomeAnalysisTK.jar'
picard='java -jar /N/soft/rhel7/picard/2.14.0/picard.jar'

module load picard
module load gatk

cd ${workingdir}/${alnDir}


        echo ""
	echo "=============================================================================="
	echo "Step 1 Combining all vcf files into a single file  ..."
	echo "=============================================================================="
	echo ""

$gatk \
   -T CombineGVCFs \
   -R ${refDir}/${PP_ref} \
   --variant $vcfList  \
   -o P_pacificus_strains.g.vcf 

echo ""
echo "=============================================================================="
echo " Finished generating vcf file"
echo "=============================================================================="
echo ""

exit
