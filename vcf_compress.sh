#!/bin/bash

#PBS -N Prist_compress_index
#PBS -k o
#PBS -l nodes=1:ppn=16,vmem=100gb
#PBS -l walltime=10:00:00
#PBS -m abe

workingdir=/N/dc2/scratch/rtraborn/variantPipe
refDir=/N/dc2/scratch/rtraborn/variantPipe/fasta
alnDir=alignments/completed_vcfs
PP_ref=pacificus_Hybrid2.fasta
vcfFile=P_pacificus_strains.g.vcf
nThreads=16

gatk='java -jar /N/soft/rhel7/gatk/3.8/GenomeAnalysisTK.jar'
picard='java -jar /N/soft/rhel7/picard/2.14.0/picard.jar'

module load tabix

cd ${workingdir}/${alnDir}


        echo ""
	echo "=============================================================================="
	echo "Step 1 Compressing and indexing our vcf file   ..."
	echo "=============================================================================="
	echo ""

bgzip -c $vcfFile > P_pacificus_strains.vcf.gz
tabix -p vcf P_pacificus_strains.vcf.gz

echo ""
echo "=============================================================================="
echo " Finished generating vcf file"
echo "=============================================================================="
echo ""

exit
