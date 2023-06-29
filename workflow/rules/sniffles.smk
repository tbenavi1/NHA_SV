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
    "sniffles -i {input.bam} --vcf {output} --tandem-repeats {input.repeats} --reference {input.ref} --threads {threads}"
