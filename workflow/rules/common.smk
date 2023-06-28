normal = config["normal"]
tumors = config["tumors"]
samples = [normal] + tumors

ref = next(iter(config["ref"]))

repeats = config["repeats"]
chroms = config["chroms"]

def get_jasmine_input(wildcards):
  delly = f"results/delly/{wildcards.ref}/{wildcards.tumor}/{wildcards.ref}.{wildcards.tumor}.somatic.vcf"
  dysgu = f"results/dysgu/{wildcards.ref}/{wildcards.tumor}/{wildcards.ref}.{wildcards.tumor}.somatic.vcf"
  nanomonsv = f"results/nanomonsv/{wildcards.ref}/{wildcards.tumor}/{wildcards.ref}.{wildcards.tumor}.nanomonsv.result.vcf"
  sniffles = f"results/sniffles/{wildcards.ref}/{wildcards.tumor}/{wildcards.ref}.{wildcards.tumor}.somatic.vcf"
  return ",".join([delly, dysgu, nanomonsv, sniffles])

def get_jasmine_samples_input(wildcards):
  return ",".join(expand(f"results/jasmine/{wildcards.ref}/{{tumor}}/{wildcards.ref}.{{tumor}}.jasmine.merged.vcf", tumor=tumor_list))
