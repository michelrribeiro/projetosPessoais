# Carregando bibliotecas:
library(dplyr, quietly = T)
library(readxl, quietly = T)
library(sqldf, quietly = T)

# Os dados de outros jogos foram retirados de uma base encontrada na internet.
# https://asloterias.com.br/download-todos-resultados-lotofacil

# Criando o dataframe com os resultados anteriores:
df <- read_xlsx("~/Desktop/DSA/big-Data-R-Azure/loto_facil_asloterias_ate_concurso_2575_sorteio.xlsx")
colnames(df) <- df[6, ]
df <- df[7:nrow(df), ]
df$Data <- df$Data %>% as.Date(format = "%d/%m/%Y")

jogo_original <- c(2, 4, 5, 6, 8, 10, 11, 12, 14, 16, 19, 20, 21, 22, 24)

dim(df); colnames(df)

# Função para contar os acertos a cada jogo:
conta_acertos <- function (df, vector){
  results = c()
  for (n in 1:nrow(df)){results = append(results, sum(vector %in% df[n, ]))}
  return(results)
}

# Criando coluna com o número total de acertos:
df$Acertos <- conta_acertos(df[ , 3:17], jogo_original)

# chamada SQL para mostrar o número de vezes que cada quantidade de acertos aparece:
query1 <- "SELECT Acertos, count(Acertos) as Qtde FROM df GROUP BY Acertos ORDER BY Acertos DESC"
sqldf(query1)

# chamada SQL para mostrar em quais sorteios o jogo atual acertaria 13 ou mais números:
query2 <- "SELECT Acertos, Concurso, Data FROM df WHERE Acertos >= 13 ORDER BY Data DESC"
sqldf(query2)
