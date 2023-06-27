inputs = snakemake.input

with open(snakemake.output[0], "w") as output_file:
  for i, input_filename in enumerate(inputs):
    with open(input_filename, "r") as input_file:
      for line in input_file:
        if line.startswith("@") or line.startswith("CONTIG"):
          if i == 0:
            output_file.write(line)
        else:
          output_file.write(line)
