rule delly_lr:
  input:
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    tumor="results/BAMS/{ref}/{tumor}/genome/long/{ref}.{tumor}.genome.long.sorted.bam",
    control=f"results/BAMS/{{ref}}/{normal}/genome/long/{{ref}}.{normal}.genome.long.sorted.bam",
  output:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.sv.bcf"
  shell:
    "/home/rranallo-benavidez/software/delly_v1.1.6_linux_x86_64bit lr -o {output} -g {input.ref} {input.tumor} {input.control}"

rule delly_samples:
  output:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.samples.tsv"
  params:
    normal=normal
  script:
    "../scripts/delly_samples.py"

rule delly_filter:
  input:
    bcf="results/delly/{ref}/{tumor}/{ref}.{tumor}.sv.bcf",
    samples="results/delly/{ref}/{tumor}/{ref}.{tumor}.samples.tsv",
  output:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.somatic.bcf"
  shell:
    "/home/rranallo-benavidez/software/delly_v1.1.6_linux_x86_64bit filter -f somatic -o {output} -s {input.samples} {input.bcf}"

rule delly_vcf:
  input:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.somatic.bcf"
  output:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.somatic.vcf"
  shell:
    "bcftools view {input} > {output}"
