#https://www.guru99.com/r-generalized-linear-model.html#8

source("functions.R")

treatInput = function(input) {
  #Monta mapa de nomes de cidade - estados
  MAPPINGS = buildCitiesMap()
  #monta mapa de estado-estado
  distinctMappings = distinct_at(MAPPINGS, "uf_code")
  
  #tenta normalizar estado da pessoa, baseado nas siglas de estados
  for(i in 1:nrow(distinctMappings)) {
    input = standardiseLocationNames(input, "q1_4", distinctMappings[[i,1]], distinctMappings[[i,1]], newCol = "estado")
    input = standardiseLocationNames(input, "q1_5", distinctMappings[[i,1]], distinctMappings[[i,1]], newCol = "estado2")
  }
  
  #tenta normalizar estado da pessoa baseado na lista de cidades
  for(i in 1:nrow(MAPPINGS)) {
    input = standardiseLocationNames(input, "q1_4", MAPPINGS[[i,1]], MAPPINGS[[i,2]], newCol = "estado")
    input = standardiseLocationNames(input, "q1_5", MAPPINGS[[i,1]], MAPPINGS[[i,2]], newCol = "estado2")
  }
  input = fillNaEstates(input)
  input
}

input = data.frame(read.csv(INPUT_FILE,dec = ",", sep = ";", encoding = "UTF-8"))
input = replace(input, input=='', NA)
input = treatInput(input)


input = select(input,-contains("timestamp")) %>% #remove colunas que tem timestamp no nome
         select(-contains("complete")) %>% #remove colunas q tem "complete" no nome
         filter(!is.na(q1_1)) #remove rows de quem não respondeu q1_1 (q1_1 = NA)

#df_independentes = select(input, starts_with(independentes))
df_independentes = select(input, starts_with("q1_"))
df_dependentes = select(input, starts_with(dependentes))


#selectiona colunas importantes e apenas numericas
important = select(input, important_cols) %>% select(where(is.numeric)) %>% setToZeroAndOne

first = as_tibble(important$dmt_1)
first[2,]=0
first[6,]=0

levels(first) = c("usou","nao-usou")
#first = relevel(first, ref="nao-usou")
ind = df_independentes %>% select(where(is.numeric))
completeData = data.frame(ind, first)

index = getIndexForTrainTest(completeData)
dados_treino = completeData[-index,]
dados_teste = completeData[index,]

options(na.action = "na.fail") 
train.control <- glm.control(epsilon = 1e-8, maxit =25 , trace = FALSE)

model=glm(value ~ .,data = dados_treino,family = binomial(link = "logit"), control = train.control)
summary(model)

predicted = predict(model, dados_teste, type = 'response')
table_mat <- table(dados_teste$value, predicted > 0.5)
#remove colunas NA
#is.na = input[,colSums(is.na(input))<nrow(input)]




