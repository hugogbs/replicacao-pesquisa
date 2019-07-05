library(tidycode)
library(tidyverse)

files_camara <- read.delim("data/all-camara-files.txt", header = FALSE)
files_tse = read.delim("data/all-tse-files.txt", header = FALSE)

files_camara_vec <- files_camara %>% unlist() %>% as.vector()
files_tse_vec <- files_tse %>% unlist() %>% as.vector()

camara_data <- read_rfiles(files_camara_vec)

tse_data <- read_rfiles(files_tse_vec)

files_camara_vec[40]
