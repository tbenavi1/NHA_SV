rule dysgu_run:
  input:
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    bam="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam",
    bai="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam.bai",
  output:
    "results/dysgu/{ref}/{sample}/{ref}.{sample}.svs.vcf"
  threads: 32
  shell:
    "dysgu run -v2 -p {threads} {input.ref} tmp_{wildcards.sample} {input.bam} > {output}"

rule dysgu_filter_normal:
  input:
    normal_vcf=f"results/dysgu/{{ref}}/{normal}/{{ref}}.{normal}.svs.vcf",
    tumor_vcf="results/dysgu/{ref}/{tumor}/{ref}.{tumor}.svs.vcf",
    normal_bam=f"results/BAMS/{{ref}}/{normal}/genome/long/{{ref}}.{normal}.genome.long.sorted.bam",
  output:
    "results/dysgu/{ref}/{tumor}/{ref}.{tumor}.somatic.vcf"
  threads: 16
  shell:
    "dysgu filter-normal --normal-vcf {input.normal_vcf} -p {threads} {input.tumor_vcf} {input.normal_bam} > {output}"

rule dysgu_merge:
  input:
    expand("results/dysgu/{{ref}}/{sample}/{{ref}}.{sample}.svs.vcf", sample=samples),
  output:
    "results/dysgu/{ref}/{ref}.merged.svs.vcf"
  shell:
    "dysgu merge {input} > {output}"

rule dysgu_regenotype:
  input:
   bam="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam",
   vcf="results/dysgu/{ref}/{ref}.merged.svs.vcf",
   ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
  output:
    "results/dysgu/{ref}/{sample}/{ref}.{sample}.re_geno.vcf"
  threads: 28 #apparently 28 is the max
  shell:
    "dysgu call -p {threads} --ibam {input.bam} --sites {input.vcf} {input.ref} tmp_{wildcards.sample} tmp_{wildcards.sample}/{wildcards.ref}.{wildcards.sample}.genome.long.sorted.dysgu_reads.bam > {output}"

rule dysgu_merge2:
  input:
    expand("results/dysgu/{{ref}}/{sample}/{{ref}}.{sample}.re_geno.vcf", sample=samples),
  output:
    "results/dysgu/{ref}/{ref}.merged.re_geno.vcf"
  shell:
    "dysgu merge {input} > {output}"

rule bcftools_private:
  input:
    "results/dysgu/{ref}/{ref}.merged.re_geno.vcf"
  output:
    "results/dysgu/{ref}/{ref}.somatic.re_geno.vcf"
  params:
    tumors=get_tumor_samples,
  shell:
    "bcftools view --samples {params.tumors} -x {input} > {output}"

rule bcftools_split:
  input:
    "results/dysgu/{ref}/{ref}.somatic.re_geno.vcf"
  output:
    "results/dysgu/{ref}/{sample}/{ref}.{sample}.somatic.re_geno.vcf"
  params:
    tumor=get_tumor_sample,
  shell:
    "bcftools view --samples {params.tumor} -c1 {input} > {output}"
