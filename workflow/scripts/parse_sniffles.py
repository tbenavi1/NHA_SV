with open(snakemake.input[0], "r") as input_file, open(snakemake.output[0], "w") as output_file:
  for line in input_file:
    if line.startswith("#"):
      output_file.write(line)
    else:
      info = line.strip().split()[7]
      supp_vec = info.split(";")[-1]
      assert "SUPP_VEC=" in supp_vec, line
      normal, tumor = supp_vec[-2:]
      if normal == "0" and tumor == "1":
        output_file.write(line)
