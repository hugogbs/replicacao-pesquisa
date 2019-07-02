base_path <- paste(getwd(), "/data/example-data/", sep="")

rmd_path <- paste(base_path, "producao-e-produtividade.Rmd", sep='')
r_path <- paste(base_path, "producao-e-produtividade.R", sep='')

knitr::purl(rmd_path, r_path, documentation = 0)

