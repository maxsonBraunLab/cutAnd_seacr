# Pipeline for CUT&Tag/RUN
Input: fastq or bams; Output: bedgraphs, seacr peaks, counts table

# For starters...

**Clone repo**
  
  `cd PATH/TO/PROJECT`
  
  `git clone LinkToThisRepo`

  Your project directory should be in your personal directory within the Maxson Lab space **not the input-data directory**
  The link to this repo can be found by clicking the green button at the top right of this page.

**Make *downsampleTodo.txt* file**
  
  You have two options here --
  1. If you want to down sample all of your marks to the same number do this:
    `cd path/to/alignments`
    `ls *.bam > downsampleTodo.txt`
    Look at file to make sure it captured the samples you want with IgGs. This should be a single column.
    Move it to the cutAnd_seacr directory
    `mv downsampleTodo.txt path/to/cutAnd_seacr`
  2. If you want to downsample to different number of reads based on mark, make seperate todo files per mark with associated IgGs.

**Make *metadata.txt* with assigned IgG**

  If using IgGs from a different experiment, use `cp` to copy the bam files into alignment directory. 

**Set up *cutAndConfig.sh***

# 1. Align fastq files *align.sh*

*QC: alignment statistics* 
  
  *note*: this is for the log files from Wes's script `20_sbatchHumanBowtie.sh` or `20_sbatchMouseBowtie.sh` if you use the `align.sh` the log files will have a different name.
  
  First, you will have to make a directory `mkdir PROJECT/cutAnd_seacr/logs/alignment` (fill in PROJECT, with your project path). Then use `mv Bowtie* PROJECT/cutAnd_seacr/logs/alignment`to move log files into directory. Once they are all together, use `srun collectBowtieStats.sh PROJECT/cutAnd_seacr/logs/alignment > align_stats.csv` to extract the alignment statistics

# 2. Downsample to lowest number of reads within a mark *downsample.sh*
  
  You can either do all samples to the same number of reads or have seperate todo files for each set of marks then downsample on a mark by mark basis.
  
  We don't suggest going below 3 million reads based on findings from original paper (Hatice et al. 2019)
  This step produces downsampled bam files *bams/sample.ds.bam* and seacr peaks *seacr/sample.relaxed.bed*

*QC: number of peaks called per replicate, fraction of reads in peak*

  To assess the fraction of reads in peak use `frip.py`. This requires making a conda environment
  
# 3. Merged bed file *seacrToUnion.sh*

 This script produces a merged bed file from all of the samples in a mark.
  
*QC: number of peaks in each merge, number of peaks in superset*  

# 4. Counts table *countsTable.sh*

  This script also assigns a unique peak IDs for downstream analysis.
  
 *QC: ??* 
