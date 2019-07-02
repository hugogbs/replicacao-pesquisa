#install.packages("tidycode")

library(tidycode)
library(tidyverse)

base_path <- paste(getwd(), "/data/example-data/", sep="")

data_path <- c(paste(base_path, "import_data.R", sep=""), 
               paste(base_path, "lib.R", sep=""))

test_data <- read_rfiles(data_path)

unnested_data <- test_data %>% unnest_calls('expr')

classified_data <- unnested_data %>%
  select(func, args) %>%
  inner_join(get_classifications("crowdsource", include_duplicates=FALSE))

clean_data <- classified_data %>% anti_join(get_stopfuncs())


clean_data %>%
  group_by(classification, func) %>% 
  summarise(n = n()) %>%
  mutate(func = reorder(func, n)) %>%
  ggplot(aes(func, n, fill = classification)) +
  theme_bw() +
  geom_col(show.legend = FALSE) +
  facet_wrap(~classification, scales = "free_y") +
  scale_x_discrete(element_blank()) +
  scale_y_continuous("Number of function calls in each classification") +
  coord_flip()
