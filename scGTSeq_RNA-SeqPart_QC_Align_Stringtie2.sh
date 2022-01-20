#!/bin/bash

# folder with all folders of fastq files
top_level_folder="/data/guang/Experiment_20210511/raw_data/scRNA_Seq_Folder_of_Samples"
######### Parameters related to Trimmomatic ##########
# How to run Trimmomatic (inlcude path of Trimmomatic)
execute_Trimmomatic="java -jar /home/guang/bio_softwares/Trimmomatic-0.39/trimmomatic-0.39.jar"
# Paired-end Trimmomatic TruSeq3 adapter file
TruSeq3_PE__adapter="/home/guang/bio_softwares/Trimmomatic-0.39/adapters/TruSeq3-PE.fa"
# Single-end Trimmomatic TruSeq3 adapter file
TruSeq3_SE_adapter="/home/guang/bio_softwares/Trimmomatic-0.39/adapters/TruSeq3-SE.fa"
# Paired-end Trimmomatic NexteraPE-PE adapter file
NexteraPE_PE_adapter="/home/guang/bio_softwares/Trimmomatic-0.39/adapters/NexteraPE-PE.fa"
######################################################

######### Parameters related to STAR ###############
# genome_STAR_index_Dir="/data/guang/genome_index/RNA-STAR/RNA_STAR_overhang100/Mus_musculus.GRCm38.97"
genome_STAR_index_Dir="/home/guang/mouse_genome_index/RNA_STAR_GRCm38.101_Overhang100_with_ERCC92"
####################################################

######### Parameter for StringTie #############
gtf_annotation="/home/guang/mouse_genome_index/RNA_STAR_GRCm38.101_Overhang100_with_ERCC92/Mus_musculus.GRCm38.101_plus_ERCC92.gtf"
###############################################
##******************* Parameter Definition Finished Here *********************##

##*************** The actual alignment script starts here. ********************##
################################################################################

## Global variables used by all script pieces.
## The global variables will be re-defined in each part. Although this re-definition
## is not necessary for execution of this merged script, re-definition of these
## global variables will make each part still a complete script and can be copied
## out to run independently.
## Re-define of the global variables to make  this part independent.
## top_level_folder="/data/guang/Experiment_20210312/raw_data/scRNA_Seq_Folder_of_Samples"
## Initialize the top_level folder. Must use full path!!
## This folder should contain the sample folders with single-end fatq.gz files.
## This folder will be used by all script pieces below.
cd $top_level_folder
sample_folder_names="$(ls -l | grep "^d" | awk '{print $NF}')"
## Get names of sample folders:
## The command on the right site will first use 'ls -l' to check all files and folders
## then 'grep "^d" ' will select the ones will a 'd' property at the beginning of 
## 'ls -l' command which are folders
## finally 'awk '{print $NF}' will print out the last column of 'ls -l' which are 
## the actual folder names. 
## NOTE: There should be no space in the folder names. If space exists in folder names
##       only the last word of folder name will be print out. This is not what we want!
## sample_folder_names will be used by all script pieces below.

################## Part 1 Quality Control and fastq data trimming.#####################
############# Part 1.1 Check fastq data quality using FastQC ##########################

for sample_folder in $sample_folder_names
do
	cd $top_level_folder/$sample_folder
	# Get into the sample_folder with fastq.gz file(s)
	mkdir -p $top_level_folder/$sample_folder/$sample_folder\_fastqc_results
	# Make a new folder in sample_folder to store FastQC result; Full path used here.
	fastqc -t 8 *.fq.gz -O ./$sample_folder\_fastqc_results/
	# -t 8: use 8 threads
	# relative path is used. The full path is 
	# $top_level_folder/$sample_folder/$sample_folder\_fastqc_results
	# Two files generate after calling fastqc: 
	#                (fastq.gz filename)_fastqc.html and (fastq.gz filename)_fastqc.zip
done


########################################################################################
################# Trimming 
cd $top_level_folder
sample_folder_names="$(ls -l | grep "^d" | awk '{print $NF}')"

for sample_folder in $sample_folder_names
do
	cd $top_level_folder/$sample_folder
	# Get into the sample_folder with fastq.gz file
	mkdir -p $top_level_folder/$sample_folder/$sample_folder\_Trimmomatic_trimmed
	# Make a new folder in sample_folder to store trimmed result; Full path used here.
	fastq_gz_files="$(ls *.fq.gz)"
	
	$execute_Trimmomatic PE -threads 8 -phred33 \
	$fastq_gz_files \
	./$sample_folder\_Trimmomatic_trimmed/trimmed.$sample_folder\_paired.R1.fq.gz \
	./$sample_folder\_Trimmomatic_trimmed/trimmed.$sample_folder\_unpaired.R1.fq.gz \
	./$sample_folder\_Trimmomatic_trimmed/trimmed.$sample_folder\_paired.R2.fq.gz \
	./$sample_folder\_Trimmomatic_trimmed/trimmed.$sample_folder\_unpaired.R2.fq.gz \
	ILLUMINACLIP:$NexteraPE_PE_adapter:2:30:10 LEADING:3 \
	TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
	
	# remove old fastq files to save space
	# rm *.gz
done


######### Parameters related to STAR ###############
# STAR genome index is generated in TruSeq_totalRNA-Seq.sh script
genome_STAR_index_Dir="/home/guang/mouse_genome_index/RNA_STAR_GRCm38.101_Overhang100_with_ERCC92"
####################################################

######### Parameter for StringTie #############
gtf_annotation="/home/guang/mouse_genome_index/RNA_STAR_GRCm38.101_Overhang100_with_ERCC92/Mus_musculus.GRCm38.101_plus_ERCC92.gtf"

top_level_folder="/data/guang/Experiment_20210511/raw_data/scRNA_Seq_Folder_of_Samples"

cd $top_level_folder
sample_folder_names="$(ls -l | grep "^d" | awk '{print $NF}')"

for sample_folder in $sample_folder_names
do
	cd $top_level_folder/$sample_folder
	#get into sample_folder
	mkdir -p $top_level_folder/$sample_folder/$sample_folder\_RNA_STAR_Results
	
	trimmed_fastq_gz_files="$(ls -d $PWD/$sample_folder\_Trimmomatic\_trimmed/*.fq.gz)"
	#$PWD is current path
	#This command get the full path of trimmed fast.gz files
	
	num_trimmed_fastq="$(echo "$trimmed_fastq_gz_files" | wc -l)"
	if [ $num_trimmed_fastq -ge 2 ] 
	# Check numer of trimmed fastq.gz files. If great than or equals to 2, they must come from 
	# paired-end read files.
	# Treat as trimmed fastq files from paired-end fastq files
	then
	paired_trimmed_reads="$(ls -d $PWD/$sample_folder\_Trimmomatic_trimmed/*_paired.*)"
	# use paired_reads to store the filenames of the 2 paired-end read files
	unpaired_trimmed_reads="$(ls -d $PWD/$sample_folder\_Trimmomatic_trimmed/*_unpaired.*)"
	# use unpaired_reads to store the filenames of the 2 unpaired read files trimmed out by trimmomatic
	
	STAR --runThreadN 8 \
    --genomeDir $genome_STAR_index_Dir \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate \
	--quantMode GeneCounts \
	--twopassMode Basic \
	--sjdbGTFfile $gtf_annotation \
    --readFilesIn $paired_trimmed_reads \
    --outReadsUnmapped Fastx \
    --outFileNamePrefix ./$sample_folder\_RNA_STAR_Results/STAR_alignment\_$sample_folder\_paired_


	# Then align the two unpaired read files trimmed out by Trimmomatic
    for unpaired_one_end_read in $unpaired_trimmed_reads
	
    do
		real_unpaired_fastq_name="$(basename $unpaired_one_end_read)"
        STAR --runThreadN 8 \
        --genomeDir $genome_STAR_index_Dir \
        --readFilesCommand zcat \
        --outSAMtype BAM SortedByCoordinate \
		--quantMode GeneCounts \
		--twopassMode Basic \
        --readFilesIn $unpaired_one_end_read \
        --outReadsUnmapped Fastx \
		--sjdbGTFfile $gtf_annotation \
        --outFileNamePrefix ./$sample_folder\_RNA_STAR_Results/STAR_alignment\_$real_unpaired_fastq_name\_

    done

	# Merge the 3 bam files and sort it
	cd $top_level_folder/$sample_folder/$sample_folder\_RNA_STAR_Results
	# get all the 3 bam files created by RNA-STAR
	bam_files="$(ls *.bam)"
	# merge all the 3 bam files together with samtools merge
	samtools merge $sample_folder\_merged_paired.and.unpaired.bam $bam_files
	# sort the big merged bam file by coordinate with samtools sort(6 threads, 4G RAM for each thread)
	samtools sort -@ 8 -m 4G -o $sample_folder\_output.sorted.bam \
                     $sample_folder\_merged_paired.and.unpaired.bam
	# index the big merged and sorted bam file
	samtools index $sample_folder\_output.sorted.bam
	


	elif [ $num_trimmed_fastq -eq 1 ]
	# Trimmed fastq.gz file from single-end reads
	then
	trimmed_reads="$(ls -d $PWD/$sample_folder\_Trimmomatic_trimmed/*.fq.gz)"
	# Get the only single-end trimmed fastq.gz file
	STAR --runThreadN 8 \
    --genomeDir $genome_STAR_index_Dir \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate \
	--quantMode GeneCounts \
	--twopassMode Basic \
	--sjdbGTFfile $gtf_annotation \
    --readFilesIn $trimmed_reads \
    --outReadsUnmapped Fastx \
    --outFileNamePrefix ./$sample_folder\_RNA_STAR_Results/$sample_folder\_output.sorted.bam
	
	cd $top_level_folder/$sample_folder/$sample_folder\_RNA_STAR_Results
	mv *.bam $sample_folder\_output.sorted.bam
	# Change long name of outputed bam of RNA-STAR into a shorter one
	samtools index $sample_folder\_output.sorted.bam
	
	fi
done
##****************************Part2 Finished here *******************************##

##******** Part 3.1 Using StringTie to get gen expression table from .bam and .gtf files **********##

## Re-define of the global variables to make Part3.1 independent script.
## top_level_folder="/data/guang/Experiment_20210312/raw_data/scRNA_Seq_Folder_of_Samples"
## Initialize the top_level folder. Must use full path!!
## This folder should contain the sample folders with single-end fatq.gz files.
cd $top_level_folder
sample_folder_names="$(ls -l | grep "^d" | awk '{print $NF}')"
## Get names of sample folders
## The command on the right site will first use 'ls -l' to check all files and folders
## then 'grep "^d" ' will select the ones will a 'd' property at the beginning of 
## 'ls -l' command which are folders
## finally 'awk '{print $NF}' will print out the last column of 'ls -l' which are 
## the actual folder names. 
## NOTE: There should be no space in the folder names. If space exists in folder names
##       only the last word of folder name will be print out. This is not what we want!

for sample_folder in $sample_folder_names
do
	cd $top_level_folder/$sample_folder
	#get into sample_folder
	mkdir -p $top_level_folder/$sample_folder/$sample_folder\_StringTie_Results
	
	# stringtie -p 6 -G /home/guang/human_genome/Homo_sapiens.GRCh38.96.gtf \
	stringtie -p 8 -G $gtf_annotation \
    -B -e -o ./$sample_folder\_StringTie_Results/$sample_folder\_transcripts\_WITHeOption.gtf \
    -A ./$sample_folder\_StringTie_Results/$sample_folder\_gene_abundances.tsv \
    ./$sample_folder\_RNA_STAR_Results/*merged_paired.and.unpaired.bam
    # The last parameter is the only aligned .bam file
done


##************** Part3.2 Get gene counts(for DESeq2 analysis) for each sample ***************##
##***************************** Description of Part3.2 **************************************##
## In this part, the 'prepDE.py' script is used to generate the gene count matrix for all
## samples in $sample_folder.
##
## The gene count matrix will be stored in /$top_level_folder/prepDE_gene_count_matrix      
## folder.
##******************************************************************************************##

## Re-define of the global variables to make Part3.2 independent script.
## top_level_folder="/data/guang/scRNA_Seq_Folder_of_Samples"
## Initialize the top_level folder. Must use full path!!
## This folder should contain the sample folders with single-end fatq.gz files.
cd $top_level_folder
sample_folder_names="$(ls -l | grep "^d" | awk '{print $NF}')"
## Get (only) the folder names of all samples
mkdir -p $top_level_folder/prepDE_gene_count_matrix
# Get sample folder name which is also the sample names
for sample_folder in $sample_folder_names
do
	cd $top_level_folder
	gtf_directory="$(ls -d $PWD/$sample_folder/$sample_folder\_StringTie_Results/*.gtf)"
	# Get the full path of the gtf file which will be used to write into sample_list.txt
	echo "$sample_folder $gtf_directory" >> $top_level_folder/prepDE_gene_count_matrix/sample_list.txt
	# Write 'sample_name sample_gtf_location' into sample_list.txt
done
cd $top_level_folder/prepDE_gene_count_matrix
cd $top_level_folder/prepDE_gene_count_matrix
# wget http://ccb.jhu.edu/software/stringtie/dl/prepDE.py
# prepDE.py already exists in stringtie-2.0.4 folder
python2 ~/bio_softwares/stringtie-2.1.4.Linux_x86_64/prepDE.py -i sample_list.txt
## Call prepDE.py using python2. MUST use python2 !!!
