rule delly_lr:
  input:
    ref=config["ref"][ref],
    sample=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam",
    index=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam.bai"
  output:
    f"results/delly/{ref}/{{sample}}/{ref}.{{sample}}.sv.vcf"
  shell:
    "delly lr -o {output} -g {input.ref} {input.sample}"

rule delly_genotype_sample:
  input:
    ref=config["ref"][ref],
    sites=f"results/jasmine/{ref}/{{sample}}/{ref}.{{sample}}.jasmine.merged.sv.vcf",
    sample=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam"
  output:
    f"results/delly/{ref}/{{sample}}/{ref}.{{sample}}.geno.vcf"
  shell:
    "delly lr -o {output} -g {input.ref} -v {input.sites} {input.sample}"
