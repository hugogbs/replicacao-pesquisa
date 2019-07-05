base_path <- paste(getwd(), "/data/example-data/", sep="")

rmd_path <- paste(base_path, "producao-e-produtividade.Rmd", sep='')
r_path <- paste(base_path, "producao-e-produtividade.R", sep='')

knitr::purl(rmd_path, r_path, documentation = 0)



paths_list = "path dos arquivos .Rmd para serem transformados em R.Rmd"

for (path in paths_list) {
  r_file_path = substr(path, 1, nchar(path)-2)
  knitr::purl(path, r_path, documentation = 0)
}

