library(tidyverse)
library(tidyverse)
library(janitor)
library(readxl)

siopbruto <- read_excel("siopbruto.xlsx") %>% 
  clean_names() %>% 
  filter(!row_number() %in% c(1))


separador <- function(data, var, nomecol1, nomecol2, delimitador){
  data|>
    tidyr::separate({{var}}, c(nomecol1, nomecol2), delimitador )
  
}

siopbruto <- separador(siopbruto, orgao_orcamentario, "codigo_orgao", "orgao_orcamentario", " - " )
siopbruto <- separador(siopbruto, funcao, "co_funcao", "funcao", " - ")
siopbruto <- siopbruto|>
  mutate(across(projeto_de_lei:pago, ~round(.x/1000000000, digits = 2)))

# siop por funcao do gasto

funcaoano <- siopbruto|>
  group_by(funcao,ano) |>
  summarise(across(projeto_de_lei: pago, ~sum(.x)))|>
  pivot_longer(projeto_de_lei:pago, names_to = "dotacoes", values_to = "valores") |>
  na.omit()


orgaoano <- siopbruto|>
  group_by(orgao_orcamentario,ano) |>
  summarise(across(projeto_de_lei: pago, ~sum(.x)))|>
  pivot_longer(projeto_de_lei:pago, names_to = "dotacoes", values_to = "valores") |>
  na.omit()


write_csv(funcaoano, "siop.csv")
write_csv(orgaoano, "siop2.csv")
write_csv(siopbruto, "sioptable.csv")
write_rds(funcaoano, "siop.rds")
write_rds(orgaoano, "siop2.rds")
write_rds(siopbruto, "sioptable.rds")


rm(funcaoano)
rm (orgaoano)


names(siopbruto)
