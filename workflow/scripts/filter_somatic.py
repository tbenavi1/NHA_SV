with open(snakemake.input[0], "r") as input_file, open(snakemake.output[0], "w") as output_file:
  for line in input_file:
    if line.startswith("#"):
      output_file.write(line)
    else:
      if "SUPP_VEC=01" in line:
        output_file.write(line)
      else:
        assert "SUPP_VEC=10" in line or "SUPP_VEC=11" in line, line
