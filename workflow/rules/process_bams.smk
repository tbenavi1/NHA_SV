rule sam_to_bam_long:
  input:
    f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sam"
  output:
    f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.bam"
  threads: 32
  shell:
    "samtools view -F 4 -@ {threads} -b -o {output} {input}"

rule sort_bam_long:
  input:
    f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.bam"
  output:
    f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam"
  threads: 32
  shell:
    "samtools sort -@ {threads} -o {output} {input}"

rule index_bam_long:
  input:
    f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam"
  output:
    f"results/BAMS/{ref}/{{sample}}/{ref}.{{sample}}.sorted.bam.bai"
  threads: 32
  shell:
    "samtools index -@ {threads} {input}"
