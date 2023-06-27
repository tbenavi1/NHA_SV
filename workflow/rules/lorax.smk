rule lorax_tithreads:
  input:
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    tumor="results/BAMS/{ref}/{tumor}/genome/long/{ref}.{tumor}.genome.long.sorted.bam",
    control=f"results/BAMS/{{ref}}/{normal}/genome/long/{{ref}}.{normal}.genome.long.sorted.bam",
  output:
    "results/lorax/tithreads/{ref}/{tumor}/{ref}.{tumor}.tithreads.bed"
  params:
    out="results/lorax/tithreads/{ref}/{tumor}/{ref}.{tumor}.tithreads"
  shell:
    "/home/rranallo-benavidez/software/lorax_v0.3.7_linux_x86_64bit tithreads -g {input.ref} -o {params.out} -m {input.control} {input.tumor}"

rule lorax_dot:
  input:
    "results/lorax/tithreads/{ref}/{tumor}/{ref}.{tumor}.tithreads.bed"
  output:
    "results/lorax/tithreads/{ref}/{tumor}/{ref}.{tumor}.tithreads.dot"
  shell:
    """
    cut -f 4,9 {input} | sed -e '1s/^/graph {{\\n/' | sed -e '$a}}' > {output}
    """

rule lorax_pdf:
  input:
   "results/lorax/tithreads/{ref}/{tumor}/{ref}.{tumor}.tithreads.dot"
  output:
    "results/lorax/tithreads/{ref}/{tumor}/{ref}.{tumor}.tithreads.pdf"
  shell:
    "dot -Tpdf {input} -o {output}"

rule lorax_telomere:
  input:
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    bam="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam"
  output:
    "results/lorax/telomere/{ref}/{sample}/{ref}.{sample}.telomere.svs.tsv"
  params:
    out="results/lorax/telomere/{ref}/{sample}/{ref}.{sample}.telomere"
  shell:
    "/home/rranallo-benavidez/software/lorax_v0.3.7_linux_x86_64bit telomere -g {input.ref} -o {params.out} {input.bam}"
