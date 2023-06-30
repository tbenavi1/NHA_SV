rule sniffles:
  input:
    repeats=repeats,
    ref=config["ref"][ref],
    bam=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam",
    bai=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam.bai",
  output:
    f"results/sniffles/{ref}/{{sample}}/{ref}.{{sample}}.sv.vcf"
  threads: 32
  shell:
    "sniffles --minsvlen 30 --mapq 20 -i {input.bam} --vcf {output} --tandem-repeats {input.repeats} --reference {input.ref} --threads {threads}"

rule sniffles_genotype_sample:
  input:
    bam=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam",
    sites=f"results/jasmine/{ref}/{{sample}}/{ref}.{{sample}}.jasmine.merged.sv.vcf",
    repeats=repeats,
    ref=config["ref"][ref]
  output:
    f"results/sniffles/{ref}.{{sample}}/{ref}.{{sample}}.geno.vcf"
  threads: 32
  shell:
    "sniffles --minsvlen 30 --mapq 20 --input {input.bam} --genotype-vcf {input.sites} --vcf {output} --tandem-repeats {input.repeats} --reference {input.ref} --threads {threads}"
