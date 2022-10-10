source("constants.R")
source("functions.R")
input = data.frame(read.csv(INPUT_FILE,dec = ",", sep = ";"))


input = select(input,-contains("timestamp")) %>% #remove colunas que tem timestamp no nome
         select(-contains("complete")) %>% #remove colunas q tem "complete" no nome
         filter(!is.na(q1_1)) #remove rows de quem não respondeu q1_1 (q1_1 = NA)

df_independentes = select(input, starts_with(independentes))
df_dependentes = select(input, starts_with(dependentes))


#selectiona colunas importantes e apenas numericas
important = select(input, important_cols) %>% select(where(is.numeric))

for(i in 1:ncol(important)) {
  print(i)
  important[,i] %>% filter(i == 2)
}
important$q3_1[1]=1
setToZeroAndOne(important)

important = setToZeroAndOne(important)

important$dmt_0 = as.factor(important$dmt_0)

ind = df_independentes %>% select(where(is.numeric))

#remove colunas NA
#is.na = input[,colSums(is.na(input))<nrow(input)]


