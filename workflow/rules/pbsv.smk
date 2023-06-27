rule pbsv_discover:
  input:
    repeats=config["repeats"],
    bam="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam",
    bai="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam.bai",
  output:
    "results/pbsv/{ref}/{sample}/{ref}.{sample}.svsig.gz"
  shell:
    "pbsv discover {input.bam} {output} --tandem-repeats {input.repeats}"

rule pbsv_call:
  input:
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    svsigs=expand("results/pbsv/{{ref}}/{sample}/{{ref}}.{sample}.svsig.gz", sample=samples),
  output:
    "results/pbsv/{ref}/{ref}.var.vcf"
  threads: 32
  shell:
    "pbsv call {input.ref} {input.svsigs} {output} -j {threads}"
