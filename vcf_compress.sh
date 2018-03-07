#!/bin/bash

#PBS -N Prist_compress_index
#PBS -k o
#PBS -l nodes=1:ppn=4,vmem=48gb
#PBS -l walltime=1:00:00
#PBS -m abe
#PBS -q debug

workingdir=/N/dc2/scratch/rtraborn/variantPipe
refDir=/N/dc2/scratch/rtraborn/variantPipe/fasta
alnDir=alignments/completed_vcfs
vcfFile=P_pacificus_combined.vcf

module load tabix

cd ${workingdir}/${alnDir}


        echo ""
	echo "=============================================================================="
	echo "Step 1 Compressing and indexing our vcf file   ..."
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
