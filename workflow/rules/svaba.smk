rule svaba:
  input:
    normal_bam=f"results/BAMS/{{ref}}/{normal}/genome/long/{{ref}}.{normal}.genome.long.sorted.bam",
    tumor_bam="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam",
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
  output:
    "results/svaba/{ref}/{sample}/{ref}.{sample}.somatic.vcf"
  params:
    id="results/svaba/{ref}/{sample}/{ref}.{sample}.somatic"
  threads: 32
  shell:
    "svaba run -n {input.normal_bam} -t {input.tumor_bam} -p {threads} -a {params.id} -G {input.ref}"
