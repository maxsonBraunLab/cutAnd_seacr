#!/bin/bash

### PURPOSE: merge IgG bams for downstream analysis. Output is merge_IgG.bam ###

#SBATCH --partition          exacloud                # partition (queue)
#SBATCH --nodes              1                       # number of nodes
#SBATCH --ntasks             1                       # number of "tasks" to be allocated for the job
#SBATCH --ntasks-per-core    1                       # Max number of "tasks" per core.
#SBATCH --cpus-per-task      4                       # Set if you know a task requires multiple processors
#SBATCH --mem                8000                  # memory pool for each node
#SBATCH --time               0-24:00                 # time (D-HH:MM)
#SBATCH --output             mergeIgG_%A.out           # Standard output
#SBATCH --error              mergeIgG_%A.err           # Standard error

#Set ayour project directory (and possibly IN directory depending on the location of your alignment files)

PROJECT=/your/project/directory/

#########################################################

source $PROJECT/cutAnd_seacr/cutAndConfig.sh

#These don't need to change
IN=$PROJECT/process/20_alignments
OUT1=$PROJECT/process/bams
mkdir -p $OUT1

### Record slurm info
echo "SLURM_JOBID: " $SLURM_JOBID


#Sort bam files
for file in `ls $IN/*IgG.bam`; do
	name=`echo $file | cut -d "/" -f 9 | sed 's/.bam//g'`
	echo $name
	cmd="$SAMTOOLS sort $file -o $OUT1/$name\.sorted.bam"
	echo $cmd
	eval $cmd
done

#Index bam files
for file2 in `ls $OUT1/*IgG.sorted.bam`; do
        cmd="$SAMTOOLS index $file2"
        echo $cmd
        eval $cmd
done

#Merge IgGs
cmd3="$SAMTOOLS merge $OUT1/merge_IgG.bam $OUT1/*IgG.sorted.bam"
echo $cmd3
eval $cmd3 
