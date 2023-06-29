rule jasmine_intra_sample:
  input:
    delly=f"results/delly/{ref}/{{sample}}/{ref}.{{sample}}.sv.vcf",
    dysgu=f"results/dysgu/{ref}/{{sample}}/{ref}.{{sample}}.sv.vcf",
    #nanomonsv=f"results/nanomonsv/{ref}/{{sample}}/{ref}.{{sample}}.nanomonsv.result.vcf",
    sniffles=f"results/sniffles/{ref}/{{sample}}/{ref}.{{sample}}.sv.vcf",
    ref=config["ref"][ref],
  output:
    f"results/jasmine/{ref}/{{sample}}/{ref}.{{sample}}.jasmine.merged.sv.vcf"
  params:
    out=f"results/jasmine/{ref}/{{sample}}/tmp_intra"
  threads: 32
  shell:
    "jasmine --comma_filelist file_list={input.delly},{input.dysgu},{input.sniffles} out_file={output} --ignore_strand --dup_to_ins genome_file={input.ref} --normalize_type out_dir={params.out}"

rule jasmine_tumor_normal:
  input:
    normal=f"results/jasmine/{ref}/{normal}/{ref}.{normal}.jasmine.merged.sv.vcf",
    tumor=f"results/jasmine/{ref}/{{tumor}}/{ref}.{{tumor}}.jasmine.merged.sv.vcf",
    ref=config["ref"][ref]
  output:
    f"results/jasmine/{ref}/{{tumor}}/{ref}.{{tumor}}.tumornormal.jasmine.merged.sv.vcf"
  params:
    out=f"results/jasmine/{ref}/{{tumor}}/tmp_tumornormal"
  threads: 32
  shell:
    "jasmine --comma_filelist file_list={input.normal},{input.tumor} out_file={output} --ignore_strand --dup_to_ins genome_file={input.ref} --normalize_type out_dir={params.out}"

rule filter_somatic:
  input:
    f"results/jasmine/{ref}/{{tumor}}/{ref}.{{tumor}}.tumornormal.jasmine.merged.sv.vcf"
  output:
    f"results/jasmine/{ref}/{{tumor}}/{ref}.{{tumor}}.somatic.jasmine.merged.sv.vcf"
  script:
    "../scripts/filter_somatic.py"

rule jasmine_somatics:
  input:
    expand(f"results/jasmine/{ref}/{{tumor}}/{ref}.{{tumor}}.somatic.jasmine.merged.sv.vcf", tumor=tumors),
    ref=config["ref"][ref],
  output:
    f"results/jasmine/{ref}/{ref}.ALL.somatic.jasmine.merged.sv.vcf"
  params:
    files=get_jasmine_input,
    out=f"results/jasmine/{ref}/tmp"
  threads: 32
  shell:
    "jasmine --comma_filelist file_list={params.files} out_file={output} --ignore_strand --dup_to_ins genome_file={input.ref} --normalize_type out_dir={params.out}"
