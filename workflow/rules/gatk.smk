rule PreprocessIntervals:
  input:
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
  output:
    "results/gatk/{ref}/{ref}.preprocessed.interval_list"
  shell:
    "gatk --java-options -Xmx8g PreprocessIntervals -R {input.ref} --bin-length 1000 --interval-merging-rule OVERLAPPING_ONLY -O {output}"

rule AddOrReplaceReadGroups:
  input:
    "results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.bam"
  output:
    "results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.RG.bam"
  shell:
    "gatk --java-options -Xmx8g AddOrReplaceReadGroups -I {input} -O {output} --RGID {wildcards.sample} --RGLB lib{wildcards.sample} --RGPL PACBIO --RGPU unit{wildcards.sample} --RGSM {wildcards.sample}"

rule index_RG_bam:
  input:
    "results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.RG.bam"
  output:
    "results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.RG.bam.bai"
  threads: 32
  shell:
    "samtools index -@ {threads} {input}"

rule CollectReadCounts:
  input:
    bam="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.RG.bam",
    bai="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.RG.bam.bai",
    intervals="results/gatk/{ref}/{ref}.preprocessed.interval_list"
  output:
    "results/gatk/{ref}/{sample}/{ref}.{sample}.counts.hdf5"
  shell:
    "gatk --java-options -Xmx50g CollectReadCounts -I {input.bam} -L {input.intervals} --interval-merging-rule OVERLAPPING_ONLY -O {output}"

rule CreateReadCountPanelOfNormals:
  input:
    normal_count=f"results/gatk/{{ref}}/{normal}/{{ref}}.{normal}.counts.hdf5"
  output:
    f"results/gatk/{{ref}}/{normal}.pon.hdf5"
  shell:
    "gatk --java-options -Xmx50g CreateReadCountPanelOfNormals -I {input.normal_count} --minimum-interval-median-percentile 5.0 -O {output}"

rule DenoiseReadCounts:
  input:
    counts="results/gatk/{ref}/{tumor}/{ref}.{tumor}.counts.hdf5",
    pon=f"results/gatk/{{ref}}/{normal}.pon.hdf5"
  output:
    standardized="results/gatk/{ref}/{tumor}/{ref}.{tumor}.standardizedCR.tsv",
    denoised="results/gatk/{ref}/{tumor}/{ref}.{tumor}.denoisedCR.tsv"
  shell:
    "gatk --java-options -Xmx12g DenoiseReadCounts -I {input.counts} --count-panel-of-normals {input.pon} --standardized-copy-ratios {output.standardized} --denoised-copy-ratios {output.denoised}"

rule PlotDenoisedCopyRatios:
  input:
    standardized="results/gatk/{ref}/{tumor}/{ref}.{tumor}.standardizedCR.tsv",
    denoised="results/gatk/{ref}/{tumor}/{ref}.{tumor}.denoisedCR.tsv",
    dict="/scratch/mkyriakidou/ref/CHM13v2/chm13v2.0.dict",
  params:
    outprefix="{ref}.{tumor}",
    outdir="results/gatk/{ref}/{tumor}",
  output:
    "results/gatk/{ref}/{tumor}/{ref}.{tumor}.denoised.png"
  shell:
    "gatk PlotDenoisedCopyRatios --standardized-copy-ratios {input.standardized} --denoised-copy-ratios {input.denoised} --sequence-dictionary {input.dict} --output-prefix {params.outprefix} -O {params.outdir}"

rule CollectAllelicCounts:
  input:
    bam="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.RG.bam",
    bai="results/BAMS/{ref}/{sample}/genome/long/{ref}.{sample}.genome.long.sorted.RG.bam.bai",
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
    chrom_vcf="/scratch/mkyriakidou/ref/CHM13v2/gatk/{chrom}_hg38_lifted.vcf.gz"
  output:
    "results/gatk/{ref}/{sample}/{ref}.{sample}.{chrom}.allelicCounts.tsv"
  shell:
    "gatk --java-options -Xmx100g CollectAllelicCounts -L {input.chrom_vcf} -I {input.bam} -R {input.ref} -O {output}"

rule combine_allelic_counts:
  input:
    expand("results/gatk/{{ref}}/{{sample}}/{{ref}}.{{sample}}.{chrom}.allelicCounts.tsv", chrom=chroms)
  output:
    "results/gatk/{ref}/{sample}/{ref}.{sample}.ALL.allelicCounts.tsv"
  #shell:
  #  "cat {input} > {output}"
  script:
    "../scripts/combine_allelic_counts.py"

rule ModelSegments:
  input:
    denoised="results/gatk/{ref}/{tumor}/{ref}.{tumor}.denoisedCR.tsv",
    allelic_counts="results/gatk/{ref}/{tumor}/{ref}.{tumor}.ALL.allelicCounts.tsv",
    normal_allelic_counts=f"results/gatk/{{ref}}/{normal}/{{ref}}.{normal}.ALL.allelicCounts.tsv",
  params:
    outdir="results/gatk/{ref}/{tumor}",
    outprefix="{ref}.{tumor}"
  output:
    "results/gatk/{ref}/{tumor}/{ref}.{tumor}.cr.seg"
  shell:
    "gatk --java-options -Xmx300g ModelSegments --denoised-copy-ratios {input.denoised} --allelic-counts {input.allelic_counts} --normal-allelic-counts {input.normal_allelic_counts} --output {params.outdir} --output-prefix {params.outprefix}"

rule CallCopyRatioSegments:
  input:
    "results/gatk/{ref}/{tumor}/{ref}.{tumor}.cr.seg"
  output:
    "results/gatk/{ref}/{tumor}/{ref}.{tumor}.called.seg"
  shell:
    "gatk --java-options -Xmx100g CallCopyRatioSegments --input {input} --output {output}"

rule PlotModeledSegments:
  input:
    denoised="results/gatk/{ref}/{tumor}/{ref}.{tumor}.denoisedCR.tsv",
    allelic_counts="results/gatk/{ref}/{tumor}/{ref}.{tumor}.ALL.allelicCounts.tsv",
    cr="results/gatk/{ref}/{tumor}/{ref}.{tumor}.cr.seg",
    segments="results/gatk/{ref}/{tumor}/{ref}.{tumor}.modelFinal.seg",
    dict="/scratch/mkyriakidou/ref/CHM13v2/chm13v2.0.dict",
  params:
    outdir="results/gatk/{ref}/{tumor}/plots",
    outprefix="{ref}.{tumor}"
  output:
    "results/gatk/{ref}/{tumor}/plots/{ref}.{tumor}_PlotModeledSegments.png"
  shell:
    "gatk --java-options -Xmx100g PlotModeledSegments --denoised-copy-ratios {input.denoised} --allelic-counts {input.allelic_counts} --segments {input.segments} --sequence-dictionary {input.dict} --output {params.outdir} --output-prefix {params.outprefix}"
