rule nanomonsv_parse:
  input:
    bam="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam",
    bai="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam.bai",
  output:
    "results/nanomonsv/{ref}/{sample}/{ref}.{sample}.bp_info.sorted.bed.gz"
  params:
    out="results/nanomonsv/{ref}/{sample}/{ref}.{sample}"
  shell:
    "nanomonsv parse {input.bam} {params.out}"

rule nanomonsv_get:
  input:
    control_result=f"results/nanomonsv/{{ref}}/{normal}/{{ref}}.{normal}.bp_info.sorted.bed.gz",
    prev_result="results/nanomonsv/{ref}/{tumor}/{ref}.{tumor}.bp_info.sorted.bed.gz",
    tumor_bam="results/BAMS/{ref}/{tumor}/genome/long/{ref}.{tumor}.genome.long.sorted.bam",
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    control_bam=f"results/BAMS/{{ref}}/{normal}/genome/long/{{ref}}.{normal}.genome.long.sorted.bam"
  output:
    "results/nanomonsv/{ref}/{tumor}/{ref}.{tumor}.nanomonsv.result.txt"
  params:
    tumor_prefix="results/nanomonsv/{ref}/{tumor}/{ref}.{tumor}",
    control_prefix=f"results/nanomonsv/{{ref}}/{normal}/{{ref}}.{normal}",
  threads: 32
  shell:
    "nanomonsv get {params.tumor_prefix} {input.tumor_bam} {input.ref} --control_prefix {params.control_prefix} --control_bam {input.control_bam} --processes {threads} --max_memory_minimap2 50"
