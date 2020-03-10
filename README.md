# Pipeline for CUT&Tag/RUN
Input: fastq or bams; Output: bedgraphs, seacr peaks, counts table

# For starters...

**Clone repo**
Clone this repo into your project directory *note: your project directory should be in your personal directory within the Maxson Lab space **not the input-data directory***

**Make *30_downsampleTodo.txt* file**

**Make *metadata.txt* with assigned IgG**

  If using IgGs from a different experiment, use `cp` to copy the bam files into alignment directory. 

**Set up *cutAndConfig.sh***

# 1. Align fastq files *align.sh*

*QC: alignment statistics* 

# 2. Downsample to lowest number of reads within a mark *downsample.sh*
  
  You can either do all samples to the same number of reads or have seperate todo files for each set of marks then downsample on a mark by mark basis.
  
  We don't suggest going below 3 million reads based on findings from original paper (Hatice et al. 2019)
  This step produces downsampled bam files *bams/sample.ds.bam* and seacr peaks *seacr/sample.relaxed.bed*

*QC: number of peaks called per replicate, fraction of reads in peak*

# 3. Merged bed file *seacrToUnion.sh*

 This script produces a merged bed file from all of the samples in a mark.
  
*QC: number of peaks in each merge, number of peaks in superset*  

# 4. Counts table *countsTable.sh*

  This script also assigns a unique peak IDs for downstream analysis.
  
 *QC: ??* 
