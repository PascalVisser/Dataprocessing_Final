"""
This script creates a genome-wide Ribo-Seq profile using one of
the two ends of the reads. The following python script generates
a genome-wide Ribo-Seq profile with a user-selected end.
The profile is a read count on each position of the genome.

Rules:

- ribo_profile: Calls python script with arguments
"""

configfile: "config/config.yaml"

rule ribo_profile:
    input:
        files = "results/bam_files/decompiled_{sample}.bed",
        data = "results/meta_analysis/meta_positional_density_{sample}.txt"

    output:
        "results/ribo/ribo_profile_{sample}.gff"
    params:
        annotation="data/NC_000913.3_CDS.gff",
        read_end=5,
        normalization_factor=1000000
    message:
        "Creating a ribo profile of {input}"
    log:
        "logs/ribo_seq_profile/ribo_profile_{sample}.log"
    shell:
        "python3 scripts/python/generate_profile.py "
        "-i {input.files} -e {params.read_end} -a {params.annotation} "
        "-n {params.normalization_factor} -o {output} 2> {log}"
