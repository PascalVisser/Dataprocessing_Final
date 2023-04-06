"""
This script maps/aligns the newly formed high quality reads
against a reference genome

Rules:

- building_reference_DB: Building a reference database
- bowtie2_mapping_reads: Align the reads
"""

configfile: "config/config.yaml"


rule building_reference_DB:
    """
    Building a reference Database from reference genome
    
    - input: reference genome
    - output: build genome reference database
    """
    input:
        config["data_dir"] + config["ref_genome"] + config["ext"]["genome"]
    output:
        expand(config["data_dir"] + config["ref_DB"] + "bt2_DB.{ext}",ext=config["EXT"])
    params:
        name=config["data_dir"] + config["ref_DB"] + "bt2_DB"
    message:
        "Building reference database from input genome {input}"
    log:
         config["log_dir"] + "mapping/building_reference_DB/ref_DB.log"
    shell:
        "bowtie2-build -f {input} {params.name} 2> {log}"


rule bowtie2_mapping_reads:
    """
    Maps reference database against high quality trimmed reads
    
    - input: trimmed reads, database 
    - output: mapped reads in .SAM format
    """
    input:
        trimmed_reads=config["results_dir"] + "trimmed_reads/{sample}_trimmed.fastq.gz",
        database=expand(config["data_dir"] + config["ref_DB"] + "bt2_DB.{ext}",ext=config["EXT"])
    output:
        temp(config["results_dir"] + "mapped/{sample}_mapping.sam")
    params:
        database=config["data_dir"] + config["ref_DB"] + "bt2_DB"
    message:
        "Bowtie2 mapping on trimmed read {input.trimmed_reads} with reference database {params.database}"
    log:
        config["log_dir"] + "mapping/bowtie2_mapping_reads/mapping_{sample}.log"
    shell:
        "bowtie2 -q -U {input.trimmed_reads} -x {params.database} -S {output} --local 2> {log}"