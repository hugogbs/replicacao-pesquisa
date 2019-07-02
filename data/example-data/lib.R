import_data <- function(){
    library(readr)
    library(tidyverse)
    cacc_raw = read_csv("https://raw.githubusercontent.com/nazareno/ciencia-de-dados-1/master/3-Agrupamento-e-PCA/dados/capes-cacc.csv", col_types = "") %>% 
        mutate_all(funs(replace(., is.na(.), 0))) %>% 
        filter(Teses + Dissertacoes > 0)
    
    cacc_raw %>% 
        write_csv(here::here("data/cacc.csv"))
}

read_projectdata <- function(){
    readr::read_csv(here::here("data/cacc.csv"), 
                    col_types = cols(
                        .default = col_integer(),
                        Instituição = col_character(),
                        Programa = col_character(),
                        Sigla = col_character(),
                        `Tem doutorado` = col_character(),
                        `Docentes colaboradores` = col_double(),
                        `Docentes permanentes` = col_double(),
                        `Docentes visitantes` = col_double()
                    ))
}
