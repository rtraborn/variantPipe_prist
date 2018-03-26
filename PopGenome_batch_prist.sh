#!/bin/bash

#PBS -N PopGenome_batch_prist_test
#PBS -k o
#PBS -l nodes=1:ppn=8,vmem=48gb
#PBS -l walltime=30:00
#PBS -m abe
#PBS -q debug

module load r

WD=/N/u/rtraborn/Carbonate/scratch/variantPipe

cd $WD

echo "Starting job"

R CMD BATCH PopGenome_batch_PP.R

echo "Job complete"

exit
