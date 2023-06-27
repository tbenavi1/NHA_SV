rule cutesv:
  input:
    bam="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam",
    bai="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam.bai",
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
  output:
    "results/cutesv/{ref}/{sample}/{ref}.{sample}.svs.vcf"
  params:
    dir="tmp_{ref}_{sample}",
  threads: 32
  shell:
    """
    mkdir -p {params.dir}
    cuteSV {input.bam} {input.ref} {output} {params.dir} --threads {threads} --max_cluster_bias_INS 1000 --diff_ratio_merging_INS 0.9 --max_cluster_bias_DEL 1000 --diff_ratio_merging_DEL 0.5
    """
