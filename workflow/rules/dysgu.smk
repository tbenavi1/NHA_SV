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

rule dysgu_genotype_sample:
  input:
    ref=config["ref"][ref],
    bam=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam",
    sites=f"results/jasmine/{ref}/{{sample}}/{ref}.{{sample}}.jasmine.merged.sv.vcf",
  output:
    f"results/dysgu/{ref}/{{sample}}/{ref}.{{sample}}.geno.vcf",
  params:
    tmp=f"results/dysgu/{ref}/{{sample}}/tmp_{ref}_{{sample}}",
    dysgu_bam=f"results/dysgu/{ref}/{{sample}}/tmp_{ref}_{{sample}}/{ref}.{{sample}}.sorted.dysgu_reads.bam"
  threads: 32
  shell:
    "dysgu call -p {threads} --ibam {input.bam} --sites {input.sites} {input.ref} {params.tmp} {params.dysgu_bam} > {output}"
