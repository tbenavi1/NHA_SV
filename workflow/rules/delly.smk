rule delly_lr:
  input:
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    tumor="results/BAMS/{ref}/{tumor}/genome/long/{ref}.{tumor}.genome.long.sorted.bam",
    control=f"results/BAMS/{{ref}}/{normal}/genome/long/{{ref}}.{normal}.genome.long.sorted.bam",
  output:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.sv.bcf"
  shell:
    "delly lr -o {output} -g {input.ref} {input.tumor} {input.control}"

rule delly_lr_single:
  input:
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    sample="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam"
  output:
    "results/delly/{ref}/{sample}/{ref}.{sample}.single.sv.bcf"
  shell:
    "delly lr -o {output} -g {input.ref} {input.sample}"

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
    "delly filter -f somatic -o {output} -s {input.samples} {input.bcf}"

rule delly_vcf:
  input:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.somatic.bcf"
  output:
    "results/delly/{ref}/{tumor}/{ref}.{tumor}.somatic.vcf"
  shell:
    "bcftools view {input} > {output}"
