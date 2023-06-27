rule bgzip_genome:
  input:
    lambda wildcards: config["refs"][wildcards.ref]["genome"],
  output:
    "results/Genome/{ref}/{ref}.genome.fna.gz",
  threads: 32
  shell:
    "bgzip -c {input} -@ {threads} > {output}"
