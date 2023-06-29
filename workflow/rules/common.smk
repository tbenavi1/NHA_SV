normal = config["normal"]
tumors = config["tumors"]
samples = [normal] + tumors

ref = next(iter(config["ref"]))

repeats = config["repeats"]
chroms = config["chroms"]

def get_jasmine_input(wildcards):
  return ",".join(f"results/jasmine/{ref}/{tumor}/{ref}.{tumor}.somatic.jasmine.merged.sv.vcf" for tumor in tumors)
