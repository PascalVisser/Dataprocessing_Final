"""
This script takes the mapped reads as input and converts, sorts and decompiles it.

Rules:

- convert_sam_to_bam: Convert the .SAM alignment files into a .BAM file format
- samtools_bam_sort: Sort the .BAM files
- decompile_bam_to_bed: Decompile the sorted alignment files to .BED files
"""

configfile: "config/config.yaml"

rule convert_sam_to_bam:
    """
    Convert the .SAM alignment file into a .BAM file format
    
    - input: mapped reads in SAM format
    - output: converted mapped reads in BAM format
    """
    input:
        config["results_dir"] + "mapped/{sample}_mapping.sam"
    output:
        temp(config["results_dir"] + "bam_files/bam_file_{sample}.bam")
    message:
        "Converting {input} from .SAM to .BAM file"
    log:
        config["log_dir"] + "decompiler/convert_sam_to_bam/convert_{sample}.log"
    shell:
        "samtools view -bS {input} > {output} 2> {log}"

rule samtools_bam_sort:
    """
    Sort the .BAM file for further analysis
    
    - input: mapped read in BAM format
    - output: Sorted reads in BAM format
    """
    input:
        config["results_dir"] + "bam_files/bam_file_{sample}.bam"
    output:
        temp(config["results_dir"] + "bam_files/sorted_bam_{sample}.bam")
    message:
        "Sorting sample {wildcards.sample}.bam"
    log:
        config["log_dir"] + "decompiler/samtools_bam_sort/sorting_{sample}.log"
    shell:
        "samtools sort -T results/sorted_reads/{wildcards.sample} -O bam {input} > {output} 2> {log}"

rule decompile_bam_to_bed:
    """
    Decompile the sorted alignment file (.BAM)
    
    - input: Sorted reads in BAM format
    - output: Decompiled BED files
    """
    input:
        config["results_dir"] + "bam_files/sorted_bam_{sample}.bam"
    output:
        config["results_dir"] + "bam_files/decompiled_{sample}.bed"
    message:
        "Decompiling {wildcards.sample}.bam to .BED file"
    log:
        config["log_dir"] + "decompiler/decompile_bam_to_bed/decompile_{sample}.log"
    shell:
        "bedtools bamtobed -i {input} > {output} 2> {log}"
