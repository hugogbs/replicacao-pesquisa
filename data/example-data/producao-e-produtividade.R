library(tidyverse)
library(broom)
library(modelr)
source(here::here("code/lib.R"))
theme_set(theme_bw())

knitr::opts_chunk$set(tidy = FALSE,
                      fig.width = 6,
                      fig.height = 5)

paleta = c("#404E4D",
           "#92DCE5",
           "#938BA1",
           "#2D3142",
           "#F4743B")

cacc_tudo = read_projectdata()

glimpse(cacc_tudo)

cacc = cacc_tudo %>%
  transmute(
    docentes = `Docentes permanentes`,
    producao = (periodicos_A1 + periodicos_A2 + periodicos_B1),
    produtividade = producao / docentes,
    mestrados = Dissertacoes,
    doutorados = Teses,
    tem_doutorado = tolower(`Tem doutorado`) == "sim",
    mestrados_pprof = mestrados / docentes,
    doutorados_pprof = doutorados / docentes
  )

cacc_md = cacc %>% 
  filter(tem_doutorado)

skimr::skim(cacc)

cacc %>% 
  ggplot(aes(x = docentes)) + 
  geom_histogram(bins = 15, fill = paleta[1])

cacc %>% 
  ggplot(aes(x = producao)) + 
  geom_histogram(bins = 15, fill = paleta[2])

cacc %>% 
  ggplot(aes(x = produtividade)) + 
  geom_histogram(bins = 15, fill = paleta[3])

cacc %>% 
  ggplot(aes(x = docentes, y = producao)) + 
  geom_point()

modelo1 = lm(producao ~ docentes, data = cacc)

tidy(modelo1, conf.int = TRUE, conf.level = 0.95)
glance(modelo1)

cacc_augmented = cacc %>% 
  add_predictions(modelo1) 

cacc_augmented %>% 
  ggplot(aes(x = docentes)) + 
  geom_line(aes(y = pred), colour = "brown") + 
  geom_point(aes(y = producao)) + 
  labs(y = "Produção do programa")

modelo2 = lm(producao ~ docentes + mestrados_pprof + doutorados_pprof + tem_doutorado, 
             data = cacc_md)

tidy(modelo2, conf.int = TRUE, conf.level = 0.95)
glance(modelo2)

modelo2 = lm(producao ~ docentes + mestrados + doutorados, data = cacc)

tidy(modelo2, conf.int = TRUE, conf.level = 0.95)
glance(modelo2)

para_plotar_modelo = cacc %>% 
  data_grid(producao = seq_range(producao, 10), # Crie um vetor de 10 valores no range
            docentes = seq_range(docentes, 4),  
            # mestrados = seq_range(mestrados, 3),
            mestrados = median(mestrados),
            doutorados = seq_range(doutorados, 3)) %>% 
  add_predictions(modelo2)

glimpse(para_plotar_modelo)


para_plotar_modelo %>% 
  ggplot(aes(x = docentes, y = pred)) + 
  geom_line(aes(group = doutorados, colour = doutorados)) + 
  geom_point(data = cacc, aes(y = producao, colour = doutorados))

library(GGally)

ggpairs(cacc %>% select(produtividade, mestrados, doutorados, mestrados_pprof, doutorados_pprof)) 

cacc_aug_prod %>% 
  ggplot(aes(x = produtividade, y = mestrados)) + 
  geom_point() 

cacc_aug_prod %>% 
  ggplot(aes(x = produtividade, y = doutorados)) + 
  geom_point()


cacc_aug_prod %>% 
  ggplot(aes(x = produtividade, y = mestrados_pprof)) + 
  geom_point()


cacc_aug_prod %>% 
  ggplot(aes(x = produtividade, y = doutorados_pprof)) + 
  geom_point() 

modelo_prod = lm(produtividade ~ mestrados + doutorados  + tem_doutorado, 
                 data = cacc)

tidy(modelo_prod, conf.int = TRUE, conf.level = 0.95)

glance(modelo_prod)

cacc_aug_prod <- cacc %>% 
  add_predictions(modelo_prod) 

cacc_aug_prod %>% 
  ggplot(aes(x = produtividade, y = pred)) + 
  geom_point() +
  geom_abline(intercept = 0)
