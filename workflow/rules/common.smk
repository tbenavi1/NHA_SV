samples = config["samples"]
normal = config["normal"]
refs = config["refs"]
chroms = config["chroms"]

#def get_fastq(wildcards):
#  return config["fastqs"][wildcards.sample]

long_samples = []
for sample in samples:
  techs = config["fastqs"][sample]
  if "pacbio_hifi" in techs or "pacbio_clr" in techs or "ont" in techs:
    long_samples.append(sample)

tumor_list = []
for sample in samples:
  if sample != normal:
    tumor_list.append(sample)

def get_tumor_samples(wildcards):
  tumor_samples = ""
  for sample in samples:
    if sample != normal:
      if tumor_samples:
        tumor_samples += ","
      tumor_samples += f"{wildcards.ref}.{sample}.genome.long.sorted.dysgu_reads"
  return tumor_samples

def get_tumor_sample(wildcards):
  return f"{wildcards.ref}.{wildcards.sample}.genome.long.sorted.dysgu_reads"

def get_tumor_samples_sniffles(wildcards):
  tumor_samples = ""
  for sample in samples:
    if sample != normal:
      if tumor_samples:
        tumor_samples += ","
      tumor_samples += f"{wildcards.ref}.{sample}.svs"
  return tumor_samples

def get_minimap_preset(wildcards):
  if wildcards.tech == "pacbio_hifi":
    return "map-hifi"
  elif wildcards.tech == "pacbio_clr":
    return "map-pb"
  else:
    assert wildcards.tech == "ont"
    return "map-ont"

def get_sorted_bam_genome_long(wildcards):
  files = []
  techs = ["pacbio_hifi", "pacbio_clr", "ont"]
  sample_techs = config["fastqs"][wildcards.sample]
  for tech in techs:
    if tech in sample_techs:
      i_s = sample_techs[tech]
      for i in i_s:
        file = f"results/BAMS/{wildcards.ref}/{wildcards.sample}/genome/{tech}/{wildcards.ref}.{wildcards.sample}.genome.{tech}.{i}.sorted.bam"
        files.append(file)
  return files

def get_jasmine_input(wildcards):
  delly = f"results/delly/{wildcards.ref}/{wildcards.tumor}/{wildcards.ref}.{wildcards.tumor}.somatic.vcf"
  dysgu = f"results/dysgu/{wildcards.ref}/{wildcards.tumor}/{wildcards.ref}.{wildcards.tumor}.somatic.vcf"
  nanomonsv = f"results/nanomonsv/{wildcards.ref}/{wildcards.tumor}/{wildcards.ref}.{wildcards.tumor}.nanomonsv.result.vcf"
  sniffles = f"results/sniffles/{wildcards.ref}/{wildcards.tumor}/{wildcards.ref}.{wildcards.tumor}.somatic.vcf"
  return ",".join([delly, dysgu, nanomonsv, sniffles])

def get_jasmine_samples_input(wildcards):
  return ",".join(expand(f"results/jasmine/{wildcards.ref}/{{tumor}}/{wildcards.ref}.{{tumor}}.jasmine.merged.vcf", tumor=tumor_list))
