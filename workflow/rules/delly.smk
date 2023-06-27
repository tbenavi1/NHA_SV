rule delly_lr:
  input:
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    tumor="results/BAMS/{ref}/{tumor}/genome/long/{ref}.{tumor}.genome.long.sorted.bam",
    control=f"results/BAMS/{{ref}}/{normal}/genome/long/{{ref}}.{normal}.genome.long.sorted.bam",
  output:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.somatic.sv.bcf"
  shell:
    "/home/rranallo-benavidez/software/delly_v1.1.6_linux_x86_64bit lr -o {output} -g {input.ref} {input.tumor} {input.control}"

rule delly_vcf:
  input:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.somatic.sv.bcf"
  output:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.somatic.sv.vcf"
  shell:
    "bcftools view {input} > {output}"
