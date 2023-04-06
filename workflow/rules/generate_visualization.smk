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
    output: chain file for create_visualizations
    """
    output:
        temp(config["results_dir"] + "vis/check.txt")
    message:
        "Installing and checking required packages..."
    log:
        config["log_dir"] + "generate_visualization/install_R_packages.log"
    shell:
        "Rscript scripts/R/Library.R 2> {log} && echo check > {output}"

rule create_visualizations:
    """
    Runs the runDESeq.R file to create visualizations
    
    input: formatted_differential_expressions.txt, designsheet.txt
    output: heatmap, dendrogram and PCAP plot
    """
    input:
        file=config["results_dir"] + "differential_expression/re-formatted-DESeqInput.txt",
        check=config["results_dir"] + "vis/check.txt"
    output:
        directory("results/DESeq")
    params:
        design_sheet=config["data_dir"] + "design_sheet.txt",
        script="scripts/R/RunDESeq.R"
    message:
        "running {params.script} to create visualizations"
    log:
        config["log_dir"] + "generate_visualization/create_visualizations.log"
    run:
        shell("mkdir results/DESeq")
        shell("Rscript {params.script} -i {input.file} -d {params.design_sheet} -o {output} 2> {log}")
