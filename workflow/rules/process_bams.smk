rule sam_to_bam_genome_long:
  input:
    "results/BAMS/{ref}/{sample}/genome/{tech}/{ref}.{sample}.genome.{tech}.{i}.sam",
  output:
    "results/BAMS/{ref}/{sample}/genome/{tech}/{ref}.{sample}.genome.{tech}.{i,[0-9]+}.bam"
  threads: 32
  shell:
    "samtools view -F 4 -@ {threads} -b -o {output} {input}"

rule sort_bam_genome_long:
  input:
    "results/BAMS/{ref}/{sample}/genome/{tech}/{ref}.{sample}.genome.{tech}.{i}.bam",
  output:
    "results/BAMS/{ref}/{sample}/genome/{tech}/{ref}.{sample}.genome.{tech}.{i,[0-9]+}.sorted.bam"
  threads: 32
  shell:
    "samtools sort -@ {threads} -o {output} {input}"

#rule merge_bam_genome_long:
#  input:
#    get_sorted_bam_genome_long,
#  output:
#    "results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam",
#  threads: 32
#  shell:
#    "samtools merge -@ {threads} -o {output} {input}"

#rule index_bam_genome_long:
#  input:
#    "results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam",
#  output:
#    "results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam.bai",
#  threads: 32
#  shell:
#    "samtools index -@ {threads} {input}"

rule sam_to_bam_long:
  input:
    "results/BAMS/{ref}/{sample}/{ref}.{sample}.sam"
  output:
    "results/BAMS/{ref}/{sample}/{ref}.{sample}.bam"
  threads: 32
  shell:
    "samtools view -F 4 -@ {threads} -b -o {output} {input}"

rule sort_bam_long:
  input:
    "results/BAMS/{ref}/{sample}/{ref}.{sample}.bam"
  output:
    "results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam"
  threads: 32
  shell:
    "samtools sort -@ {threads} -o {output} {input}"

rule index_bam_long:
  input:
    "results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam"
  output:
    "results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam.bai"
  threads: 32
  shell:
    "samtools index -@ {threads} {input}"
