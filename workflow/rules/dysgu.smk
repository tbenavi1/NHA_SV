rule dysgu_run:
  input:
    ref=config["ref"][ref],
    bam=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam",
    bai=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam.bai",
  output:
    f"results/dysgu/{ref}/{{sample}}/{ref}.{{sample}}.sv.vcf"
  params:
    tmp=f"results/dysgu/{ref}/{{sample}}/tmp_{ref}_{{sample}}"
  threads: 32
  shell:
    "dysgu run -v2 -p {threads} {input.ref} {params.tmp} {input.bam} > {output}"
