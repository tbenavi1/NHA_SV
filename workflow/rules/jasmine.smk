rule jasmine:
  input:
    delly="results/delly/{ref}/{tumor}/{ref}.{tumor}.somatic.vcf",
    dysgu="results/dysgu/{ref}/{tumor}/{ref}.{tumor}.somatic.vcf",
    nanomonsv="results/nanomonsv/{ref}/{tumor}/{ref}.{tumor}.nanomonsv.result.vcf",
    sniffles="results/sniffles/{ref}/{tumor}/{ref}.{tumor}.somatic.vcf",
    ref=lambda wildcards: config["refs"][wildcards.ref]["genome"],
  output:
    "results/jasmine/{ref}/{tumor}/{ref}.{tumor}.jasmine.merged.vcf"
  params:
    files=get_jasmine_input,
    out="results/jasmine/{ref}/{tumor}/tmp"
  threads: 32
  shell:
    "jasmine --comma_filelist file_list={params.files} out_file={output} --ignore_strand --dup_to_ins genome_file={input.ref} threads={threads} --normalize_type out_dir={params.out}"
