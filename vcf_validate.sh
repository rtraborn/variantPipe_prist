#!/bin/bash

#PBS -N Prist_vcf_validate
#PBS -k o
#PBS -l nodes=1:ppn=16,vmem=100gb
#PBS -l walltime=1:00:00
#PBS -m abe
#PBS -q debug

workingdir=/N/dc2/scratch/rtraborn/variantPipe
refDir=/N/dc2/scratch/rtraborn/variantPipe/fasta
alnDir=alignments/completed_vcfs
PP_ref=/N/u/rtraborn/Carbonate/Pristionchus/Taylor/genome/pacificus_Hybrid2.fa
vcfFile=P_pacificus_strains.g.vcf
nThreads=16

gatk='java -jar /N/soft/rhel7/gatk/3.8/GenomeAnalysisTK.jar'
picard='java -jar /N/soft/rhel7/picard/2.14.0/picard.jar'

module load gatk

cd ${workingdir}/${alnDir}


        echo ""
	echo "=============================================================================="
	echo "Step 1 Compressing and indexing our vcf file   ..."
	echo "=============================================================================="
	echo ""

 $gatk \
   -T ValidateVariants \
   -R $PP_ref \
   -V $vcfFile

echo ""
echo "=============================================================================="
echo " Finished generating vcf file"
echo "=============================================================================="
echo ""

exit
