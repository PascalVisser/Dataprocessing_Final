"""
This script will use the genome annotation NC_00913.3.gff3 file to create
an essential GFF file, this will be done by using a python script

Rules:

- generate_extract_CDS_annotation: creates a gff file
"""

configfile: "config/config.yaml"

rule generate_extract_CDS_annotation:
    """
    creating a gff file by executing python script
    
    input: Genome annotation file.gff3
    output: Essential gff annotation file
    """
    input:
        config["data_dir"] + config["ref_genome"] + config["ext"]["annotation"]
    output:
        config["data_dir"] + "NC_000913.3_CDS.gff"
    message:
        "creating GGF3 file from {input}"
    log:
        config["log_dir"] + "GGF3_annotation/generate_extract_CDS_annotation.log"
    shell:
        "python3 scripts/python/parse_genome_annotation.py -i {input} -o {output} 2> {log}"
