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
    "dysgu run -v2 --mode pacbio --min-support 3 -p {threads} {input.ref} {params.tmp} {input.bam} > {output}"

rule dysgu_convert2bnd:
  input:
    ref=config["ref"][ref],
    vcf=f"results/dysgu/{ref}/{{sample}}/{ref}.{{sample}}.sv.vcf"
  output:
    f"results/dysgu/{ref}/{{sample}}/{ref}.{{sample}}.converted.sv.vcf"
  shell:
    "python ~/software/convert2bnd.py -t TRA {input.ref} {input.vcf} > {output}"

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
    "dysgu call --mode pacbio --min-support 3 -p {threads} --ibam {input.bam} --sites {input.sites} {input.ref} {params.tmp} {params.dysgu_bam} > {output}"

rule dysgu_genotype_convert2bnd:
  input:
    ref=config["ref"][ref],
    vcf=f"results/dysgu/{ref}/{{sample}}/{ref}.{{sample}}.geno.vcf"
  output:
    f"results/dysgu/{ref}/{{sample}}/{ref}.{{sample}}.converted.geno.vcf"
  shell:
    "python ~/software/convert2bnd.py -t TRA {input.ref} {input.vcf} > {output}"
