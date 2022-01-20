#!/bin/bash

# Make dir to store RNA-STAR index
mkdir -p /home/guang/mouse_genome_index/RNA_STAR_GRCm38.101_Overhang100_with_ERCC92
# get into the foldre for RNA-STAR index and download the reference genome and gtf here
cd /home/guang/mouse_genome_index/RNA_STAR_GRCm38.101_Overhang100_with_ERCC92

################# Below Deprecated part #################
#### This part download all chromosome sequences and merge them together to get whole genome sequence.
#### This part is replaced by download primary_assembly file instead.
#### The primary_assembly contains all chromsome sequences exactlay the same as download them one by one and 
#### merge together(here). But other than chromosome sequences, primary_assembly also contains some non-chromosomal
#### sequences:
### ----------------------------------------------------------------- ###
### (base) guang@guang:~$ grep "dna"  ~/mouse_genome_index/RNA_STAR_GRCm38.101_Overhang100_with_ERCC92/Mus_musculus.GRCm38.101.chromosomes.1-19XYMT.fa
##### >10 dna:chromosome chromosome:GRCm38:10:1:130694993:1 REF
##### >11 dna:chromosome chromosome:GRCm38:11:1:122082543:1 REF
##### >12 dna:chromosome chromosome:GRCm38:12:1:120129022:1 REF
##### >13 dna:chromosome chromosome:GRCm38:13:1:120421639:1 REF
##### >14 dna:chromosome chromosome:GRCm38:14:1:124902244:1 REF
##### >15 dna:chromosome chromosome:GRCm38:15:1:104043685:1 REF
##### >16 dna:chromosome chromosome:GRCm38:16:1:98207768:1 REF
##### >17 dna:chromosome chromosome:GRCm38:17:1:94987271:1 REF
##### >18 dna:chromosome chromosome:GRCm38:18:1:90702639:1 REF
##### >19 dna:chromosome chromosome:GRCm38:19:1:61431566:1 REF
##### >1 dna:chromosome chromosome:GRCm38:1:1:195471971:1 REF
##### >2 dna:chromosome chromosome:GRCm38:2:1:182113224:1 REF
##### >3 dna:chromosome chromosome:GRCm38:3:1:160039680:1 REF
##### >4 dna:chromosome chromosome:GRCm38:4:1:156508116:1 REF
##### >5 dna:chromosome chromosome:GRCm38:5:1:151834684:1 REF
##### >6 dna:chromosome chromosome:GRCm38:6:1:149736546:1 REF
##### >7 dna:chromosome chromosome:GRCm38:7:1:145441459:1 REF
##### >8 dna:chromosome chromosome:GRCm38:8:1:129401213:1 REF
##### >9 dna:chromosome chromosome:GRCm38:9:1:124595110:1 REF
##### >MT dna:chromosome chromosome:GRCm38:MT:1:16299:1 REF
##### >X dna:chromosome chromosome:GRCm38:X:1:171031299:1 REF
##### >Y dna:chromosome chromosome:GRCm38:Y:1:91744698:1 REF
### (base) guang@guang:~$ grep dna ~/Downloads/Mus_musculus.GRCm38.dna.primary_assembly.fa
##### >1 dna:chromosome chromosome:GRCm38:1:1:195471971:1 REF
##### >10 dna:chromosome chromosome:GRCm38:10:1:130694993:1 REF
##### >11 dna:chromosome chromosome:GRCm38:11:1:122082543:1 REF
##### >12 dna:chromosome chromosome:GRCm38:12:1:120129022:1 REF
##### >13 dna:chromosome chromosome:GRCm38:13:1:120421639:1 REF
##### >14 dna:chromosome chromosome:GRCm38:14:1:124902244:1 REF
##### >15 dna:chromosome chromosome:GRCm38:15:1:104043685:1 REF
##### >16 dna:chromosome chromosome:GRCm38:16:1:98207768:1 REF
##### >17 dna:chromosome chromosome:GRCm38:17:1:94987271:1 REF
##### >18 dna:chromosome chromosome:GRCm38:18:1:90702639:1 REF
##### >19 dna:chromosome chromosome:GRCm38:19:1:61431566:1 REF
##### >2 dna:chromosome chromosome:GRCm38:2:1:182113224:1 REF
##### >3 dna:chromosome chromosome:GRCm38:3:1:160039680:1 REF
##### >4 dna:chromosome chromosome:GRCm38:4:1:156508116:1 REF
##### >5 dna:chromosome chromosome:GRCm38:5:1:151834684:1 REF
##### >6 dna:chromosome chromosome:GRCm38:6:1:149736546:1 REF
##### >7 dna:chromosome chromosome:GRCm38:7:1:145441459:1 REF
##### >8 dna:chromosome chromosome:GRCm38:8:1:129401213:1 REF
##### >9 dna:chromosome chromosome:GRCm38:9:1:124595110:1 REF
##### >MT dna:chromosome chromosome:GRCm38:MT:1:16299:1 REF
##### >X dna:chromosome chromosome:GRCm38:X:1:171031299:1 REF
##### >Y dna:chromosome chromosome:GRCm38:Y:1:91744698:1 REF
##### >JH584299.1 dna:scaffold scaffold:GRCm38:JH584299.1:1:953012:1 REF
##### >GL456233.1 dna:scaffold scaffold:GRCm38:GL456233.1:1:336933:1 REF
##### >JH584301.1 dna:scaffold scaffold:GRCm38:JH584301.1:1:259875:1 REF
##### >GL456211.1 dna:scaffold scaffold:GRCm38:GL456211.1:1:241735:1 REF
##### >GL456350.1 dna:scaffold scaffold:GRCm38:GL456350.1:1:227966:1 REF
##### >JH584293.1 dna:scaffold scaffold:GRCm38:JH584293.1:1:207968:1 REF
##### >GL456221.1 dna:scaffold scaffold:GRCm38:GL456221.1:1:206961:1 REF
##### >JH584297.1 dna:scaffold scaffold:GRCm38:JH584297.1:1:205776:1 REF
##### >JH584296.1 dna:scaffold scaffold:GRCm38:JH584296.1:1:199368:1 REF
##### >GL456354.1 dna:scaffold scaffold:GRCm38:GL456354.1:1:195993:1 REF
##### >JH584294.1 dna:scaffold scaffold:GRCm38:JH584294.1:1:191905:1 REF
##### >JH584298.1 dna:scaffold scaffold:GRCm38:JH584298.1:1:184189:1 REF
##### >JH584300.1 dna:scaffold scaffold:GRCm38:JH584300.1:1:182347:1 REF
##### >GL456219.1 dna:scaffold scaffold:GRCm38:GL456219.1:1:175968:1 REF
##### >GL456210.1 dna:scaffold scaffold:GRCm38:GL456210.1:1:169725:1 REF
##### >JH584303.1 dna:scaffold scaffold:GRCm38:JH584303.1:1:158099:1 REF
##### >JH584302.1 dna:scaffold scaffold:GRCm38:JH584302.1:1:155838:1 REF
##### >GL456212.1 dna:scaffold scaffold:GRCm38:GL456212.1:1:153618:1 REF
##### >JH584304.1 dna:scaffold scaffold:GRCm38:JH584304.1:1:114452:1 REF
##### >GL456379.1 dna:scaffold scaffold:GRCm38:GL456379.1:1:72385:1 REF
##### >GL456216.1 dna:scaffold scaffold:GRCm38:GL456216.1:1:66673:1 REF
##### >GL456393.1 dna:scaffold scaffold:GRCm38:GL456393.1:1:55711:1 REF
##### >GL456366.1 dna:scaffold scaffold:GRCm38:GL456366.1:1:47073:1 REF
##### >GL456367.1 dna:scaffold scaffold:GRCm38:GL456367.1:1:42057:1 REF
##### >GL456239.1 dna:scaffold scaffold:GRCm38:GL456239.1:1:40056:1 REF
##### >GL456213.1 dna:scaffold scaffold:GRCm38:GL456213.1:1:39340:1 REF
##### >GL456383.1 dna:scaffold scaffold:GRCm38:GL456383.1:1:38659:1 REF
##### >GL456385.1 dna:scaffold scaffold:GRCm38:GL456385.1:1:35240:1 REF
##### >GL456360.1 dna:scaffold scaffold:GRCm38:GL456360.1:1:31704:1 REF
##### >GL456378.1 dna:scaffold scaffold:GRCm38:GL456378.1:1:31602:1 REF
##### >GL456389.1 dna:scaffold scaffold:GRCm38:GL456389.1:1:28772:1 REF
##### >GL456372.1 dna:scaffold scaffold:GRCm38:GL456372.1:1:28664:1 REF
##### >GL456370.1 dna:scaffold scaffold:GRCm38:GL456370.1:1:26764:1 REF
##### >GL456381.1 dna:scaffold scaffold:GRCm38:GL456381.1:1:25871:1 REF
##### >GL456387.1 dna:scaffold scaffold:GRCm38:GL456387.1:1:24685:1 REF
##### >GL456390.1 dna:scaffold scaffold:GRCm38:GL456390.1:1:24668:1 REF
##### >GL456394.1 dna:scaffold scaffold:GRCm38:GL456394.1:1:24323:1 REF
##### >GL456392.1 dna:scaffold scaffold:GRCm38:GL456392.1:1:23629:1 REF
##### >GL456382.1 dna:scaffold scaffold:GRCm38:GL456382.1:1:23158:1 REF
##### >GL456359.1 dna:scaffold scaffold:GRCm38:GL456359.1:1:22974:1 REF
##### >GL456396.1 dna:scaffold scaffold:GRCm38:GL456396.1:1:21240:1 REF
##### >GL456368.1 dna:scaffold scaffold:GRCm38:GL456368.1:1:20208:1 REF
##### >JH584292.1 dna:scaffold scaffold:GRCm38:JH584292.1:1:14945:1 REF
##### >JH584295.1 dna:scaffold scaffold:GRCm38:JH584295.1:1:1976:1 REF
### ----------------------------------------------------------------- ###
###
### 
# Download all chromosome files from ENSEMBL
# Current newest release (101), published July, 10th 2020
# for i in {1..19} X Y MT
# do 
# wget ftp://ftp.ensembl.org/pub/release-101/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.chromosome.$i.fa.gz -O Mus_musculus.GRCm38.101.dna.chromosome.$i.fa.gz
# done
# merge all chromosome files into single file
# cat *.gz > Mus_musculus.GRCm38.101.chromosomes.1-19XYMT.fa.gz
# unzip the merged chromosome sequence file
# gunzip -k Mus_musculus.GRCm38.101.chromosomes.1-19XYMT.fa.gz
############# Above part deprecated ############################


# Download primary assembly of mouse genome sequence
wget ftp://ftp.ensembl.org/pub/release-101/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz -O Mus_musculus.GRCm38.101.dna.primary_assembly.fa.gz
# unzip mouse genome sequence
gunzip Mus_musculus.GRCm38.101.dna.primary_assembly.fa.gz
# move the ERCC92.zip file to the folder for RNA_STAR index
# unzip the ERCC92.zip file to get ERCC92.fa and ERCC92.gtf

# add the ERCC92.fa to the end of mouse chromosome sequence
cat ERCC92.fa >> Mus_musculus.GRCm38.101.dna.primary_assembly.fa
# Change the name of the merged .fa file(reference genome plus ERCC)
mv Mus_musculus.GRCm38.101.dna.primary_assembly.fa Mus_musculus.GRCm38.101.dna.primary_assembly_plus_ERCC92.fa


# Download gtf file
wget ftp://ftp.ensembl.org/pub/release-101/gtf/mus_musculus/Mus_musculus.GRCm38.101.gtf.gz
gunzip Mus_musculus.GRCm38.101.gtf.gz

# Add ERCC92 annotation file to the end of mouse genome annotation gtf file
cat ERCC92.gtf >> Mus_musculus.GRCm38.101.gtf
# rename the merged gtf file
mv Mus_musculus.GRCm38.101.gtf Mus_musculus.GRCm38.101_plus_ERCC92.gtf

# Build the index for RNA-STAR 
# (For read >= 100bp, use sjdbOverhang 100 is good enough)
# Otherwise use SequencingLength-1 as sdjbOverhang
/home/guang/bio_softwares/RNA_STAR_v2.7.6a/bin/Linux_x86_64/STAR --runMode genomeGenerate --runThreadN 8 \
--genomeDir /home/guang/mouse_genome_index/RNA_STAR_GRCm38.101_Overhang100_with_ERCC92 \
--genomeFastaFiles /home/guang/mouse_genome_index/RNA_STAR_GRCm38.101_Overhang100_with_ERCC92/Mus_musculus.GRCm38.101.dna.primary_assembly_plus_ERCC92.fa \
--sjdbGTFfile /home/guang/mouse_genome_index/RNA_STAR_GRCm38.101_Overhang100_with_ERCC92/Mus_musculus.GRCm38.101_plus_ERCC92.gtf \\
--sjdbOverhang 100




