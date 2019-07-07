library(tidycode)
library(tidyverse)

files_camara <- read.delim("data/all-camara-files.txt", header = FALSE)
files_tse <- read.delim("data/all-tse-files.txt", header = FALSE)

files_camara_vec <- files_camara %>% unlist() %>% as.vector()
files_tse_vec <- files_tse %>% unlist() %>% as.vector()


camara_data = read_rfiles(files_camara_vec)

tse_data <- read_rfiles(files_tse_vec)

# for (i in 1:nrow(tse_data)) {
#   print(i)
#   tse_data %>% 
#     filter(row_number() == i) %>%
#     unnest_calls(expr)
# }

tse_data_clean <- tse_data %>%
  filter(!(row_number() %in% c(1529, 1536, 1544, 1545, 4893, 10224, 11149, 11151, 11154, 11165)))

tse_unnested <- tse_data_clean %>% unnest_calls(expr)


# for (i in 1:nrow(camara_data)) {
#   print(i)
#   camara_data %>% 
#     filter(row_number() == i) %>%
#     unnest_calls(expr)
# }

camara_data_clean <- camara_data %>%
  filter(!(row_number() %in% c(136, 392, 469, 3800)))

camara_unnested <- camara_data_clean %>% unnest_calls(expr)

tse_classified <- tse_unnested  %>%
  select(func, args) %>%
  inner_join(get_classifications("crowdsource", include_duplicates=FALSE))

camara_classified <- camara_unnested  %>%
  select(func, args) %>%
  inner_join(get_classifications("crowdsource", include_duplicates=FALSE))


camara_classified_clean <- camara_classified %>% anti_join(get_stopfuncs())
tse_classified_clean <- tse_classified %>% anti_join(get_stopfuncs())

