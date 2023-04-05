"""
This script analysis the differential translation, count the mapped read and
transforming the reads into a single file

rules:

- bedtools coverage: transform reads from .bed to .cov
- format_reads: format reads into a single file
"""

configfile: "config/config.yaml"


rule bedtools_coverage:
    """
    To analyze the differential translation, count the mapped
    reads on every CDSs from the alignment file. Genome annotation
    should be provided as a GFF file.
    
    input: decompiled files + genome annotation.gff
    output: diff_expr_{sample}.cov
    """
    input:
        files="results/bam_files/decompiled_{sample}.bed",
        ref_DB="data/NC_000913.3_CDS.gff"
    output:
        "results/differential_expression/diff_expr_{sample}.cov"
    message:
        "Performing bedtools coverage on {input.files} with ref_DB {input.ref_DB}"
    log:
        "logs/differential_expression/bedtools_coverage/bed_cov_{sample}.log"
    shell:
        "bedtools coverage -a {input.ref_DB} -b {input.files} -s > {output} 2> {log}"

rule format_reads:
    """
    Merge and re-format the read count into a single
    file that can be analyzed by the DESeq2 package
    
    input: mapped reads on every CDS
    output: re formatted file ready for analysis
    """
    input:
        expand("results/differential_expression/diff_expr_{sample}.cov",sample=config["samples"])
    output:
        "results/differential_expression/re-formatted-DESeqInput.txt"
    message:
        "merge and re-formatting read counts"
    log:
        "logs/differential_expression/format_reads/format.log"
    shell:
        "python3 scripts/python/format_DESeq_input.py -i {input} -o {output} 2> {log}"
