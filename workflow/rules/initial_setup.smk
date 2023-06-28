rule bgzip_genome:
  input:
    lambda wildcards: config["ref"][ref],
  output:
    f"results/Genome/{ref}/{ref}.genome.fna.gz",
  threads: 32
  shell:
    "bgzip -c {input} -@ {threads} > {output}"
