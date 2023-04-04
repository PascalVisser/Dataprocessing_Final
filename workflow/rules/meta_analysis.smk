"""
This script will conduct a meta-analysis using the check_periodicity.py script
creates a tab-separated information text file of meta-ribosome density.

Rules:

- analysis: Execute pyton script with in and outputs
"""

configfile: "config/config.yaml"

rule analysis:
    input:
        files = "results/bam_files/decompiled_{sample}.bed",
        data = "data/NC_000913.3_CDS.gff"
    output:
        "results/meta_analysis/meta_positional_density_{sample}.txt"
    params:
        anno="data/NC_000913.3_CDS.gff"
    message:
        "Creating meta analysis data file from {input}"
    log:
        "logs/meta_analysis/meta_data_{sample}.log"
    shell:
        "python3 scripts/python/check_periodicity.py -i {input.files} -a {params.anno} -o {output} 2> {log}"
