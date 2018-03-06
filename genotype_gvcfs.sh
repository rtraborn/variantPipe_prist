#!/bin/bash

#PBS -N Prist_variant_calling_GATK
#PBS -k o
#PBS -l nodes=1:ppn=24,vmem=72gb
#PBS -l walltime=8:00:00
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
module load tabix

cd ${workingdir}/${alnDir}


        echo ""
	echo "=============================================================================="
	echo "Step 1 Combining all vcf files into a single file  ..."
	echo "=============================================================================="
	echo ""

$gatk \
   -T GenotypeGVCFs \
   -R ${refDir}/${PP_ref} \
   --variant $vcfList  \
   -o P_pacificus_combined.vcf 

        echo ""
	echo "=============================================================================="
	echo "Step 2 Compressing and indexing our vcf file   ..."
	echo "=============================================================================="
	echo ""

bgzip -c $vcfFile > P_pacificus_combined.vcf.gz
tabix -p vcf P_pacificus_combined.vcf.gz

echo ""
echo "=============================================================================="
echo " Finished generating vcf file"
echo "=============================================================================="
echo ""

exit
