rule minimap2_index_genome:
  input:
    "results/Genome/{ref}/{ref}.genome.fna.gz",
  output:
    "results/Genome/{ref}/{ref}.genome.{tech}.mmi",
  threads: 3
  params:
    preset=get_minimap_preset,
  shell:
    "minimap2 -x {params.preset} -d {output} {input}"

rule minimap2_genome:
  input:
    mmi="results/Genome/{ref}/{ref}.genome.{tech}.mmi",
    reads=lambda wildcards: config["fastqs"][wildcards.sample][wildcards.tech][int(wildcards.i)],
  output:
    "results/BAMS/{ref}/{sample}/genome/{tech}/{ref}.{sample}.genome.{tech}.{i,[0-9]+}.sam"
  threads: 31
  params:
    preset=get_minimap_preset,
  shell:
    "minimap2 -x {params.preset} -t {threads} -a {input.mmi} {input.reads} > {output}"
