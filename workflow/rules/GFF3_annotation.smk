"""
This script will use the genome annotation NC_00913.3.gff3 file to create
an essential GFF file, this will be done by using a python script

Rules:

- create_GFF: creates a gff file
"""

configfile: "config/config.yaml"
script_dir = config["script_dir"]["python"]

rule create_GFF:
    input:
        config["datadir"] + config["ref_genome"] + config["ext"]["annotation"]
    output:
        "results/anno/NC_000913.3_CDS.gff"
    message:
        "creating GGF3 file from {input}"
    log:
        "logs/create_GGF3/create_GFF.log"
    script:
        "../../" + script_dir + "/ParseGenomeAnnotation.py"