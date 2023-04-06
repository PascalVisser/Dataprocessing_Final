"""
This script will run a rule that outputs a
directed acyclic graph (DAG) of jobs, representing the
automatically derived execution plan from the example workflow.

rules:

create_dag: creates a dag.png file
"""


rule create_dag:
    """
    Create a dag file
    
    input: -
    output: dag.png image
    """
    output:
        config["image_dir"] + "workflow_visualization.png"
    message:
        "Creating a DAG of the workflow"
    log:
        config["log_dir"] + "create_dag/create_dag.log"
    shell:
        "snakemake -s workflow/Snakefile --forceall --dag | dot -Tpng > {output} 2> {log}"
