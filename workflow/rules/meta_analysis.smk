"""
This script will conduct a meta-analysis using the check_periodicity.py script
creates a tab-separated information text file of meta-ribosome density.

Rules:

- meta_analysis: Executes a python script with in and outputs
"""

configfile: "config/config.yaml"

rule meta_analysis:
    """
    conduct meta-analysis on decompiled bed file with 
    the genome annotation file
    
    input: genome annotation file, decompiled .bed files
    output: positional density.txt
    """
    input:
        files = config["results_dir"] + "bam_files/decompiled_{sample}.bed",
        data = config["data_dir"] + "NC_000913.3_CDS.gff"
    output:
        config["results_dir"] + "meta_analysis/meta_positional_density_{sample}.txt"
    params:
        anno="data/NC_000913.3_CDS.gff"
    message:
        "Creating meta analysis data file from {input}"
    log:
        config["log_dir"] + "meta_analysis/meta_analysis_{sample}.log"
    shell:
        "python3 scripts/python/check_periodicity.py -i {input.files} -a {params.anno} -o {output} 2> {log}"
