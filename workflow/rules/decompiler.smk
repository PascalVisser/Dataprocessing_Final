"""
This script takes the mapped reads as input and converts, sorts and decompiles it.
This is going to take place in three steps:

Rules:

- convert_sam: Convert the .SAM alignment files into a .BAM file format
- bam_sort: Sort the .BAM files
- decompile_bam: Decompile the sorted alignment files to .BED files
"""

configfile: "config/config.yaml"

rule convert_sam:
    """
    Convert the .SAM alignment file into a .BAM file format
    - input: mapped reads in SAM format
    - output: converted mapped reads in BAM format
    """
    input:
        "results/mapped/{sample}_mapping.sam"
    output:
        "results/bam_files/bam_file_{sample}.bam"
    message:
        "Converting {input} from .SAM to .BAM file"
    log:
        "logs/decompiler/convert/convert_sam_{sample}.log"
    shell:
        "samtools view -bS {input} > {output} 2> {log}"

rule bam_sort:
    """
    Sort the .BAM file for further analysis
    - input: mapped read in BAM format
    - output: Sorted reads in BAM format
    """
    input:
        "results/bam_files/bam_file_{sample}.bam"
    output:
        "results/bam_files/sorted_bam_{sample}.bam"
    message:
        "Sorting sample {wildcards.sample}.bam"
    log:
        "logs/decompiler/sort_bam/sorting_{sample}.log"
    shell:
        "samtools sort -T results/sorted_reads/{wildcards.sample} -O bam {input} > {output} 2> {log}"

rule decompile_bam:
    """
    Decompile the sorted alignment file (.BAM)
    - input: Sorted reads in BAM format
    - output: Decompiled BED files
    """
    input:
        "results/bam_files/sorted_bam_{sample}.bam"
    output:
        "results/bam_files/decompiled_{sample}.bed"
    message:
        "Decompiling {wildcards.sample}.bam to .BED file"
    log:
        "logs/decompiler/decompile_bam/decompile_{sample}.log"
    shell:
        "bedtools bamtobed -i {input} > {output} 2> {log}"
