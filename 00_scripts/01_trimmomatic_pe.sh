#!/bin/bash
#PBS -N trimmomatic__BASE__
#PBS -o trimmomatic__BASE__.out
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#####PBS -m ea
#PBS -l ncpus=8
#PBS -q omp
#PBS -r n

#cd $PBS_O_WORKDIR

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Global variables
ADAPTERFILE="univec.fasta"
TRIMMOMATIC_JAR="trimmomatic-0.36.jar"
NCPU=20

for i in $(ls -1 02_data/NS*_R1.fastq.gz | perl -pe 's/_R1\.fastq\.gz//')
do
    base=$(basename "$i")
    echo "Treating $base"
        java -Xmx60G -jar $TRIMMOMATIC_JAR PE \
            -threads $NCPU \
            -phred33 \
            02_data/"$base"_R1.fastq.gz \
            02_data/"$base"_R2.fastq.gz \
            03_trimmed/"$base"_R1.paired.fastq.gz \
            03_trimmed/"$base"_R1.single.fastq.gz \
            03_trimmed/"$base"_R2.paired.fastq.gz \
            03_trimmed/"$base"_R2.single.fastq.gz \
            ILLUMINACLIP:"$ADAPTERFILE":2:20:7 \
            LEADING:20 \
            TRAILING:20 \
            SLIDINGWINDOW:30:30 \
            MINLEN:60 2> 98_log_files/log.trimmomatic.pe."$TIMESTAMP"
done
