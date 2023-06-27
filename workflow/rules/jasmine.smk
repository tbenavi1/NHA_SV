rule jasmine:
  input:
    files=get_jasmine_input,
    ref=
  output:
    "results/jasmine/{ref}/{tumor}/{ref}.{tumor}.jasmine.merged.vcf"
  shell:
    "jasmine --comma_filelist {input.files} out_file={output} --ignore_strand --dup_to_ins genome_file={input.ref}"
