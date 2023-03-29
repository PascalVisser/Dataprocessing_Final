"""
This script takes the mapped reads as input and converts, sorts and decompiles it.
This is going to take place in three steps:

- Convert the .SAM alignment files into a .BAM file format
- Sort the .BAM files
- Decompile the sorted alignment files

At the end the output = ...
"""

configfile: "config/config.yaml"

rule all:
    input:
        expand("results/bam_files/bam_file_{sample}.bam ", sample=config["samples"])

rule convert_sam:
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

