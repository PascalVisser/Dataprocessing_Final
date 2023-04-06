"""
This script removes the low-quality reads (or bases) and the adapter sequence
that may not be removed from sequencer, so that only the high
quality ribosome-protected sequences remains.

rules:

- Trimmomatic: trimming the raw reads
"""

configfile: "config/config.yaml"

rule trimmomatic:
    """
    Trims the low quality reads to achieve only high quality reads,
    discard low quality reads 
    
    - input: raw samples
    - output: high quality trimmed samples
    """
    input:
        raw_reads=config["data_dir"] + '{sample}' + config["ext"]["raw_reads"],
        adapter=config["data_dir"] + config["ribo_adapter"] + config["ext"]["genome"]
    output:
         temp(config["results_dir"] + "trimmed_reads/{sample}_trimmed.fastq.gz")

    threads:
        config["threads"]

    params:
        # parameters received from article
        jar=config["trimmomatic"]["jar"],
        phred=config["trimmomatic"]["phred"],
        minlen=config["trimmomatic"]["minlen"],
        maxmis=config["trimmomatic"]["maxmismatch"],
        pairend=config["trimmomatic"]["pairend"],
        minscore=config["trimmomatic"]["minscore"],
        slidewindow=config["trimmomatic"]["slidewindow"],
        minqual=config["trimmomatic"]["minqual"]

    message:
        "Trimmomatic started trimming {input.raw_reads}"

    log:
       config["log_dir"] + "trimmomatic/{sample}_trimmed.log"

    shell:
        "java -jar {params.jar} \
         SE {params.phred} {input.raw_reads} {output} \
         ILLUMINACLIP:{input.adapter}:{params.maxmis}:{params.pairend}:{params.minscore} \
         SLIDINGWINDOW:{params.slidewindow}:{params.minqual} \
         MINLEN:{params.minlen} -threads {threads} 2> {log}"
