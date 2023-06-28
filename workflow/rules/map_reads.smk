rule minimap2_index_genome:
  input:
    f"results/Genome/{ref}/{ref}.genome.fna.gz",
  output:
    f"results/Genome/{ref}/{ref}.genome.hifi.mmi",
  threads: 3
  shell:
    "minimap2 -x map-hifi -d {output} {input}"

rule minimap2_genome:
  input:
    mmi=f"results/Genome/{ref}/{ref}.genome.hifi.mmi",
    reads=lambda wildcards: config["ubams"][wildcards.sample],
  output:
    f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sam"
  threads: 31
  shell:
    "samtools fastq {input.reads} | minimap2 -x map-hifi -t {threads} -a {input.mmi} - > {output}"
