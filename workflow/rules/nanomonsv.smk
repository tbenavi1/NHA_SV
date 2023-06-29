rule nanomonsv_parse:
  input:
    bam=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam",
    bai=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam.bai",
  output:
    f"results/nanomonsv/{ref}/{{sample}}/{ref}.{{sample}}.bp_info.sorted.bed.gz"
  params:
    out=f"results/nanomonsv/{ref}/{{sample}}/{ref}.{{sample}}"
  shell:
    "nanomonsv parse {input.bam} {params.out}"

rule nanomonsv_get:
  input:
    prev_result=f"results/nanomonsv/{ref}/{{sample}}/{ref}.{{sample}}.bp_info.sorted.bed.gz",
    sample_bam=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam",
    ref=config["ref"][ref],
  output:
    f"results/nanomonsv/{ref}/{{sample}}/{ref}.{{sample}}.nanomonsv.result.vcf"
  params:
    sample_prefix=f"results/nanomonsv/{ref}/{{sample}}/{ref}.{{sample}}",
  threads: 32
  shell:
    "nanomonsv get {params.sample_prefix} {input.sample_bam} {input.ref} --processes {threads} --max_memory_minimap2 50"
