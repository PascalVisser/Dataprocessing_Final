"""
Removing the low-quality reads (or bases) and the adapter sequence
that may not be removed from sequencer, so that only the high
quality ribosome-protected sequence remains.
"""

configfile: "config/config.yaml"

rule all:
    input:
        expand("results/trimmed_reads/{sample}_trimmed.fastq.gz", sample=config["samples"])


rule trimmomatic:
    input:
        raw_reads = 'data/{sample}' + config["ext"]["raw_reads"],
        adapter = "data/" + config["ribo_adapter"] + config["ext"]["genome"]

    output:
        "results/trimmed_reads/{sample}_trimmed.fastq.gz"

    threads:
        config["threads"]

    params:
        jar = config["trimmomatic"]["jar"],
        phred =  config["trimmomatic"]["phred"],
        minlen = config["trimmomatic"]["minlen"],
        maxmis = config["trimmomatic"]["maxmismatch"],
        pairend = config["trimmomatic"]["pairend"],
        minscore =  config["trimmomatic"]["minscore"],
        slidewindow = config["trimmomatic"]["slidewindow"],
        minqual =  config["trimmomatic"]["minqual"]

    message:
        "Trimmomatic started trimming {input.raw_reads}"

    log:
        "logs/trimmomatic/{sample}_trimmed.log"

    shell:
        "java -jar {params.jar} \
         SE {params.phred} {input.raw_reads} {output} \
         ILLUMINACLIP:{input.adapter}:{params.maxmis}:{params.pairend}:{params.minscore} \
         SLIDINGWINDOW:{params.slidewindow}:{params.minqual} \
         MINLEN:{params.minlen} -threads {threads} 2> {log}"


