#install.packages("tidycode")

library(tidycode)
library(tidyverse)

example_paths <- tidycode_example(c("example_analysis.R", "example_plot.R"))

data <- read_rfiles(example_paths)

unnested_data <- data %>% unnest_calls('expr')

classified_data <- unnested_data %>%
  select(func, args) %>%
  inner_join(get_classifications("crowdsource", include_duplicates=FALSE))

clean_data <- classified_data %>% anti_join(get_stopfuncs())

