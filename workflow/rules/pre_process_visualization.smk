"""
This script pre-processes the bed files to be usable for the visualizations

rules:

- bedtools coverage: transform reads from .bed to .cov
- merge_and_reFormat: re-format reads into a single file
"""

configfile: "config/config.yaml"


rule bedtools_coverage:
    """
    Bedtools coverage compares one bed file to another 
    and compute the breadth and depth of coverage
    
    input: decompiled files + genome annotation.gff
    output: coverage_{sample}.cov
    """
    input:
        files=config["results_dir"] + "bam_files/decompiled_{sample}.bed",
        ref_DB=config["data_dir"] + "NC_000913.3_CDS.gff"
    output:
        temp(config["results_dir"] + "pre_process_visualizations/coverage_{sample}.cov")
    message:
        "Performing bedtools coverage on {input.files} with ref_DB {input.ref_DB}"
    log:
        config["log_dir"] + "pre_process_visualizations/bedtools_coverage/coverage_{sample}.log"
    shell:
        "bedtools coverage -a {input.ref_DB} -b {input.files} -s > {output} 2> {log}"

rule merge_and_reFormat:
    """
    Merge and re-format the read count into a single
    file that can be analyzed by the DESeq2 package
    
    input: covered reads by bedtools coverage
    output: re-formatted file ready for analysis
    """
    input:
        expand(config["results_dir"] + "pre_process_visualizations/coverage_{sample}.cov",sample=config["samples"])
    output:
        temp(config["results_dir"] + "differential_expression/re-formatted-DESeqInput.txt")
    message:
        "merge and re-formatting read counts"
    log:
        config["log_dir"] + "pre_process_visualizations/merge_and_reFormat/format.log"
    shell:
        "python3 scripts/python/format_DESeq_input.py -i {input} -o {output} 2> {log}"
