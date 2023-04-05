"""
Run the RunDESeq.R script generates multiple pdf files. First,
Dendrogram_and_heatmap.pdf contains a dendrogram
and a heatmap showing the hierarchical clustering of samples
based on pairwise Euclidean distances between samples Also,
the two-dimensional principal component
analysis (PCA) plot is printed as PCA.pdf.

rules:

- install_R_packages: install the necessary R packages
- runDESeq: Runs the RunDESeq.R script
"""

configfile: "config/config.yaml"

rule install_R_packages:
    """
    Installs and check R packages
    
    input: -
    output: -
    """
    input:
        "results/differential_expression/re-formatted-DESeqInput.txt"
    output:
        "results/vis/check.txt"
    message:
        "Installing and checking required packages..."
    log:
        "logs/visualizations/install_packages.log"
    shell:
        "Rscript scripts/R/Library.R 2> {log} && echo check > {output}"

rule runDESeq:
    """
    Runs the runDESeq.R file to create visualizations
    
    input: formatted_differential_expressions.txt, designsheet.txt
    output: heatmap, dendrogram and PCAP plot
    """
    input:
        file="results/differential_expression/re-formatted-DESeqInput.txt",
        check="results/vis/check.txt"
    output:
        directory("results/DESeq")
    params:
        design_sheet=config["datadir"] + "design_sheet.txt",
        script="scripts/R/RunDESeq.R"
    message:
        "running {params.script} to create visualizations"
    log:
        "logs/visualizations/runDESeq.log"
    run:
        shell("mkdir results/DESeq")
        shell("Rscript {params.script} -i {input.file} -d {params.design_sheet} -o {output} 2> {log}")
