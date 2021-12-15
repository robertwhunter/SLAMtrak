#!/bin/sh

# Set grid Engine options:
#$ -N miniMAP
#$ -wd <working directory>
#$ -o <output dir>
#$ -e <errors dir>
#$ -l h_rt=02:00:00
#$ -l h_vmem=8G
#$ -pe sharedmem 4
#$ -m bea -M <insert email>


source ~/miniconda3/bin/activate bowtie2

bowtie2-build miniMAP_gene_list.fa miniMAP_gene_list
mv *.bt2 Bowtie_indeces/

parallel "bowtie2 -q {} -x Bowtie_indeces/miniMAP_gene_list --no-unal --no-hd | cut -f3,10 > {/.}.hits" ::: fastq/*trimmed.fq

conda deactivate
