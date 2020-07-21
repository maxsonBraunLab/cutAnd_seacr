# Pipeline for CUT&Tag/RUN
Input: fastq or bams; Output: bedgraphs, seacr peaks, counts table

`align.sh` > `downsample.sh` > `seacrToUnion.sh` > `countsTable.sh`

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

  This is a tab delimited file. It may be easiest to make this in excel, save it as a .txt, then put it in your cutAnd_seacr directory. However, there are a number of different ways of making these, just make sure it is tab delimited and you should be good! There is an example of how the metadata file should look in the example directory of this repo. *If using IgGs from a different experiment, use `cp` to copy the bam files into alignment directory.* 

# 1. Align fastq files *align.sh*

INPUT | OUTPUT
------|-------
.fastq.gz| bam and sam files


*QC: alignment statistics* 
  
  *note*: this is for the log files from Wes's script `20_sbatchHumanBowtie.sh` or `20_sbatchMouseBowtie.sh` if you use the `align.sh` the log files will have a different name.
  
  First, you will have to make a directory `mkdir PROJECT/cutAnd_seacr/logs/alignment` (fill in PROJECT, with your project path). Then use `mv Bowtie* PROJECT/cutAnd_seacr/logs/alignment`to move log files into directory. Once they are all together, use `srun collectBowtieStats.sh PROJECT/cutAnd_seacr/logs/alignment > align_stats.csv` to extract the alignment statistics. You can use these counts to determine downsampling number.
  
  **Set up *cutAndConfig.sh***

  You can have different configs for each mark, or use the same config and change the variables. There are five varibles that need to be changed in this file (todo, meta, REF, RN, and MARK).

# 2. Downsample to lowest number of reads within a mark *downsample.sh*

INPUT | OUTPUT | directory
------|-------|-------------
.bam|downsampled bam | process/bams/*.ds.bam
 na|downsampled bedgraphs | process/beds/*.ds.bedgraph
 na|downsampled bigwigs | process/beds/*.ds.bw
 na|seacr peaks| process/seacr/*.relaxed.bed
  
  Before using this script, ensure your `cutAndconfig.sh` is properly set up. You can either do all samples to the same number of reads or have seperate todo files for each set of marks then downsample on a mark by mark basis. Also make sure to change `PROJECT` to your project's file path.
  
  We don't suggest going below 3 million reads based on findings from original paper (Hatice et al. 2019), however, 2 million may be okay in some cases.

*QC: number of peaks called per replicate, fraction of reads in peak*

  To look at the number of peaks called per relicate you can use this command in the directory process/seacr: `wc -l *.bed`. 

  To assess the fraction of reads in peak use `frip.py`. This requires making a conda environment
  
# 3. Merged bed file *seacrToUnion.sh*

 Change `PROJECT` to your project's file path.
 
 This script produces a merged bed file from all of the samples in a mark.
  
*QC: number of peaks in each merge, number of peaks in superset*  

# 4. Counts table *countsTable.sh*
  Change `PROJECT` to your project's file path.
  This script also assigns a unique peak IDs for downstream analysis.
  
 *QC: ??* 
