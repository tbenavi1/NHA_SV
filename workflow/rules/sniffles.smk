rule sniffles:
  input:
    repeats=config["repeats"],
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    bam="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam",
    bai="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam.bai",
  output:
    "results/sniffles/{ref}/{sample}/{ref}.{sample}.svs.snf"
  threads: 32
  shell:
    "sniffles -i {input.bam} --snf {output} --tandem-repeats {input.repeats} --reference {input.ref} --threads {threads}"

#rule sniffles_multi:
#  input:
#    expand("results/sniffles/{{ref}}/{sample}/{{ref}}.{sample}.svs.snf", sample=long_samples)
#  output:
#    "results/sniffles/{ref}/{ref}.multisample.vcf"
#  threads: 32
#  shell:
#    "sniffles --input {input} --vcf {output} --threads {threads}"

rule sniffles_multi:
  input:
    normal=f"results/sniffles/{{ref}}/{normal}/{{ref}}.{normal}.svs.snf",
    tumor="results/sniffles/{ref}/{tumor}/{ref}.{tumor}.svs.snf",
  output:
    "results/sniffles/{ref}/{tumor}/{ref}.{tumor}.multisample.vcf"
  threads: 32
  shell:
    "sniffles --input {input.normal} {input.tumor} --vcf {output} --threads {threads}"

rule parse_sniffles:
  input:
    "results/sniffles/{ref}/{tumor}/{ref}.{tumor}.multisample.vcf"
  output:
    "results/sniffles/{ref}/{tumor}/{ref}.{tumor}.somatic.vcf"
  script:
    "../scripts/parse_sniffles.py"

rule bcftools_private_sniffles:
  input:
    "results/sniffles/{ref}/{ref}.multisample.vcf"
  output:
    "results/sniffles/{ref}/{ref}.somatic.vcf"
  params:
    tumors=get_tumor_samples_sniffles,
  shell:
    "bcftools view --samples {params.tumors} -x {input} > {output}"
