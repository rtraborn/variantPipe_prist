#!/bin/bash

#PBS -N Prist_variant_calling_GATK
#PBS -k o
#PBS -l nodes=1:ppn=24,vmem=40gb
#PBS -l walltime=1:00:00
#PBS -m abe
#PBS -q debug

workingdir=/N/dc2/scratch/rtraborn/variantPipe
refDir=fasta
outDir=vcf_out
bamDir=alignments
PP_ref=pacificus_Hybrid2.fasta
nThreads=16

gatk='java -jar /N/soft/rhel7/gatk/3.8/GenomeAnalysisTK.jar'
picard='java -jar /N/soft/rhel7/picard/2.14.0/picard.jar'

module load samtools
module load picard
module load gatk
module load r

cd $workingdir


        echo ""
	echo "=============================================================================="
	echo "Step 0 Sorting each bam file  ..."
	echo "=============================================================================="
	echo ""

cd ${bamDir}
            for file1 in *.rh.bam; do
	    echo "$samtools sort -@ 8 -o $(basename $file1 .rh.bam).sorted.bam $file1"
	          samtools sort -@ 8 -o $(basename $file1 .rh.bam).sorted.bam $file1
		  done

        echo ""
	echo "=============================================================================="
	echo "Step 1 Performing picard markDuplicates on each bam file  ..."
	echo "=============================================================================="
	echo ""

cd ..

echo "Processing files"

cd ${bamDir}
      for file1 in *.rh.bam; do
	    echo "$picard MarkDuplicates $file1"
	    $picard MarkDuplicates \
		I=$(basename $file1 .rh.bam).sorted.bam \
		O=$(basename $file1 .rh.bam).markedDup.bam \
		M=$(basename $file1 .rh.bam)_metrics.txt
      done

echo "Splitting N Cigar Reads"

 for file1 in *.rh.bam; do

$gatk \
    -T SplitNCigarReads -R ../${refDir}/$PP_ref \
    -I $(basename $file1 .rh.bam).markedDup.bam \
    -o $(basename $file1 .rh.bam).split.bam \
    -rf ReassignOneMappingQuality \
    -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS
 done

        echo ""
	echo "=============================================================================="
	echo "Step 2 Generating VCF files from BAMs using GATK ..."
	echo "=============================================================================="
	echo ""

###################################################################
#   Prepping reference genome fasta file for GATK
echo "Prepping reference genome fasta file for GATK....."
cd ../${refDir}

# Create sequence dictionary using Picard Tools.
# the following command produces a SAM-style header file describing the contents of our fasta file.
$picard CreateSequenceDictionary \
    REFERENCE=$PP_ref \
    OUTPUT=$(basename $PP_ref .fasta).dict

echo "created sequence dictionary for the reference genomes."

echo "indexing the reference genomes...."

# Create the fasta index file.
# The index file describes byte offset in the fasta file for each contig. It is a text file with one record
# per line for each of the fasta contigs. Each record is of the type -
# contig, size, location, basePerLine, bytesPerLine
#samtools faidx $PP_ref

echo "Reference genomes are now ready for GATK."

cd ../${bamDir}

###############################################################
## Summary Statistics

#    for file1 in *.rh.bam; do

#        $picard MeanQualityByCycle \
#	    INPUT=$(basename $file1 .rh.bam).markedDup.bam \
#	    CHART_OUTPUT=$(basename $file1 .rh.bam)_mean_quality_by_cycle.pdf \
#	    OUTPUT=$(basename $file1 .rh.bam)_read_quality_by_cycle.txt \
#	    REFERENCE_SEQUENCE=${workingdir}/${refDir}/$PP_ref

#        $picard QualityScoreDistribution \
#	    INPUT=$(basename $file1 .rh.bam).markedDup.bam \
#	    CHART_OUTPUT=$(basename $file1 .rh.bam)_mean_quality_overall.pdf \
#	    OUTPUT=$(basename $file1 .rh.bam)_read_quality_overall.txt \
#	    REFERENCE_SEQUENCE=${workingdir}/${refDir}/$PP_ref

#	$picard CollectWgsMetrics \
#	    INPUT=$(basename $file1 .rh.bam).markedDup.bam \
#	    OUTPUT=$(basename $file1 .rh.bam)_stats_picard.txt \
#	    REFERENCE_SEQUENCE=${workingdir}/${refDir}/$PP_ref \
#	    MINIMUM_MAPPING_QUALITY=20 \
#	    MINIMUM_BASE_QUALITY=20

#done

#############################################################

## GATK Data Pre-Processing

# Step 1 - Local realignment around indels.
# Create a target list of intervals to be realigned.

echo "Creating a target list of intervals to be realigned...."

for file1 in *.rh.bam; do

samtools index $(basename $file1 .rh.bam).split.bam

$gatk \
    -T RealignerTargetCreator \
    -R ../${refDir}/$PP_ref \
    -I $(basename $file1 .rh.bam).split.bam \
    -o $(basename $file1 .rh.bam)_target_intervals.list

# do the local realignment.
echo "local realignment..."

$gatk \
    -T IndelRealigner \
    -R ../${refDir}/$PP_ref \
    -I $(basename $file1 .rh.bam).split.bam \
    -targetIntervals $(basename $file1 .rh.bam)_target_intervals.list \
    -o $(basename $file1 .rh.bam)_realigned.bam

echo "indexing the realigned bam file..."

# Create a new index file.
samtools index $(basename $file1 .rh.bam)_realigned.bam

done 

###########################################################################
# GATK Variant Calling -  HaplotypeCaller
# Set -nct, outmode, emit_thresh, call_threh,

outmode="EMIT_ALL_CONFIDENT_SITES"
hetrate=0.01	#Popgen heterozygosity rate (that is, for any two random chrom in pop, what is rate of mismatch).Human is ~0.01, so up maize to ~0.03
minBaseScore=20	#Minimum Phred base score to count a base (20 = 0.01 error, 30=0.001 error, etc)

echo "$hetrate"
echo "$call_thresh"

echo "calling variants...."

for file1 in *.rh.bam; do

$gatk \
    -T HaplotypeCaller \
    -R ../${refDir}/$PP_ref \
    -I $(basename $file1 .rh.bam)_realigned.bam \
    --emitRefConfidence GVCF \
    --variant_index_type LINEAR \
    --variant_index_parameter 128000 \
    -hets $hetrate \
    -mbq $minBaseScore \
    -ploidy 2 \
    -out_mode $outmode \
    -nct 4 \
    -nt $nThreads
    -o $(basename $myfile .rh.bam)_output.g.vcf

done

echo ""
echo "=============================================================================="
echo " Finished generating files"
echo "=============================================================================="
echo ""

exit
