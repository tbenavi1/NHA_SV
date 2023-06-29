rule delly_lr:
  input:
    ref=config["ref"][ref],
    sample=f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam"
  output:
    f"results/delly/{ref}/{{sample}}/{ref}.{{sample}}.sv.bcf"
  shell:
    "delly lr -o {output} -g {input.ref} {input.sample}"

rule delly_vcf:
  input:
    f"results/delly/{ref}/{{sample}}/{ref}.{{sample}}.sv.bcf"
  output:
    f"results/delly/{ref}/{{sample}}/{ref}.{{sample}}.sv.vcf"
  shell:
    "bcftools view {input} > {output}"
