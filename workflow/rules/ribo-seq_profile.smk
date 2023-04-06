"""
This script creates a genome-wide Ribo-Seq profile using one of
the two ends of the reads. The following python script generates
a genome-wide Ribo-Seq profile with a user-selected end.
The profile is a read count on each position of the genome.

Rules:

- calculate_ribosome_density: Calls python script with arguments
"""

configfile: "config/config.yaml"

rule calculate_ribosome_density:
    """
    Calculate the ribosome density by analysing decompiled
    files, using external python script
    
    input: decompiled files, positional density.txt
    output: ribosome_density files
    """
    input:
        files = config["results_dir"] + "bam_files/decompiled_{sample}.bed",
        data = config["results_dir"] + "meta_analysis/meta_positional_density_{sample}.txt"

    output:
        config["results_dir"] + "ribosome_density_sample_{sample}.gff"
    params:
        # parameters received from article
        annotation=config["data_dir"] + "NC_000913.3_CDS.gff",
        read_end=5,
        normalization_factor=1000000
    message:
        "Creating a ribo profile of {input}"
    log:
        config["log_dir"] + "ribo_seq_profile/calculated_ribosome_density_{sample}.log"
    shell:
        "python3 scripts/python/generate_profile.py "
        "-i {input.files} -e {params.read_end} -a {params.annotation} " 
        "-n {params.normalization_factor} -o {output} 2> {log}"
