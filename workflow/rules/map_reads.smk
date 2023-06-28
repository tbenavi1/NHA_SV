#rule minimap2_index_genome:
#  input:
#    "results/Genome/{ref}/{ref}.genome.fna.gz",
#  output:
#    "results/Genome/{ref}/{ref}.genome.{tech}.mmi",
#  threads: 3
#  params:
#    preset=get_minimap_preset,
#  shell:
#    "minimap2 -x {params.preset} -d {output} {input}"

#rule minimap2_genome:
#  input:
#    mmi="results/Genome/{ref}/{ref}.genome.{tech}.mmi",
#    reads=lambda wildcards: config["fastqs"][wildcards.sample][wildcards.tech][int(wildcards.i)],
#  output:
#    "results/BAMS/{ref}/{sample}/genome/{tech}/{ref}.{sample}.genome.{tech}.{i,[0-9]+}.sam"
#  threads: 31
#  params:
#    preset=get_minimap_preset,
#  shell:
#    "minimap2 -x {params.preset} -t {threads} -a {input.mmi} {input.reads} > {output}"

rule minimap2_index_genome:
  input:
    "results/Genome/{ref}/{ref}.genome.fna.gz",
  output:
    "results/Genome/{ref}/{ref}.genome.hifi.mmi",
  threads: 3
  shell:
    "minimap2 -x map-hifi -d {output} {input}"

rule minimap2_genome:
  input:
    mmi="results/Genome/{ref}/{ref}.genome.hifi.mmi",
    reads=lambda wildcards: config["ubams"][wildcards.sample],
  output:
    "results/BAMS/{ref}/{sample}/{ref}.{sample}.sam"
  threads: 31
  shell:
    "samtools fastq {input.reads} | minimap2 -x map-hifi -t {threads} -a {input.mmi} - > {output}"
