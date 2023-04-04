"""
This script maps/aligns the newly formed high quality reads against a reference genome
The process takes place in two steps:

Rules:

- building_referenceDB: Building a reference database
- mapping: Align the reads
"""

configfile: "config/config.yaml"

EXT = ["1.bt2", "2.bt2", "3.bt2", "4.bt2", "rev.1.bt2", "rev.2.bt2"]

rule building_referenceDB:
    """
    Building a reference Database from reference genome
    - input: reference genome
    - output: build genome reference database
    """
    input:
        config["datadir"] + config["ref_genome"] + config["ext"]["genome"]
    output:
        expand(config["datadir"] + config["ref_DB"] + "bt2_DB.{ext}", ext=EXT)
    params:
        name= config["datadir"] + config["ref_DB"] + "bt2_DB"
    message:
        "Building reference database from input genome {input}"
    log:
        "logs/mapping/reference_DB/refDB.log"
    shell:
        "bowtie2-build -f {input} {params.name} 2> {log}"


rule mapping:
    """
    Maps reference database against high quality trimmed reads
    - input: trimmed reads, database 
    - output: mapped reads in .SAM format
    """
    input:
        trimmed_reads="results/trimmed_reads/{sample}_trimmed.fastq.gz",
        database=expand(config["datadir"] + config["ref_DB"] + "bt2_DB.{ext}", ext=EXT)
    output:
        "results/mapped/{sample}_mapping.sam"
    params:
        database=config["datadir"] + config["ref_DB"] + "bt2_DB"
    message:
        "Bowtie2 mapping on trimmed read {input.trimmed_reads}"
    log:
        "logs/mapping/bowtie2_mapping/bowtie2_{sample}_mapping"
    shell:
        "bowtie2 -q -U {input.trimmed_reads} -x {params.database} -S {output} --local 2> {log}"
