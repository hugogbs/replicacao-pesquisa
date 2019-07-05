library(tidyverse)

rmds_camara = read.delim("data-extract/data/camara-rmd-files.txt", header = FALSE) %>%
  unlist()

for (path in rmds_camara) {
  r_file_path = substr(path, 1, nchar(path)-2)
  knitr::purl(path, r_file_path, documentation = 0)
}


rmds_tse = read.delim("data-extract/data/tse-rmd-files.txt", header = FALSE) %>%
  unlist()

for (path in rmds_tse) {
  r_file_path = substr(path, 1, nchar(path)-2)
  knitr::purl(path, r_file_path, documentation = 0)
}

