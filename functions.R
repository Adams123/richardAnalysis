source("constants.R")

setToZeroAndOne = function(dataframe) {
  for(j in 1:ncol(dataframe)) {
    flag = 0
    for(i in 1:nrow(dataframe)) {
      if(!is.na(dataframe[i,j]) && dataframe[i,j] == 2){
        flag = 1
        break
      }
    }
    if(flag == 1){
      dataframe[,j]=dataframe[,j]-1
      next
    }
  }
  
  dataframe
}


getIndexForTrainTest = function(dataframe, partitionSize = 0.75) {
  ## 75% of the sample size
  smp_size <- floor(partitionSize * nrow(dataframe))
  
  set.seed(123)
  sample(seq_len(nrow(dataframe)), size = smp_size)
}


standardiseLocationNames = function(dataframe, pos, regex, replace, newCol = NULL) { 
  indexes = subset(dataframe, grepl(regex, dataframe[[pos]], ignore.case = TRUE))[1]
  if(is.null(indexes) || nrow(indexes) == 0) return(dataframe)
  if(is.null(newCol)){
    for(i in 1:nrow(indexes)) {
      dataframe[indexes[[1]][i],pos] = replace
    }
  } else {
    for(i in 1:nrow(indexes)) {
      dataframe[indexes[[1]][i],newCol] = replace
    }
  }
  
  dataframe
}

fillNaEstates = function(dataframe) {
  #tenta preencher o resto dos estados que preencheram mas não foi identificado, procurando pelo país
  paises = read.csv("paises.csv", sep = ",")[[2]]
  
  estadosNA = rownames(dataframe[is.na(dataframe$estado),])
  estados2NA = rownames(dataframe[is.na(dataframe$estado2),])
  
  estadosAPreencher = as.numeric(estadosNA[!(estadosNA %in% rownames(dataframe[is.na(dataframe$q1_4),]))])
  estados2APreencher = as.numeric(estados2NA[!(estados2NA %in% rownames(dataframe[is.na(dataframe$q1_5),]))])
  
  for(i in 1:length(estadosAPreencher)) {
    index = grep(dataframe$q1_4[estadosAPreencher[i]], paises)
    if(!is.null(index) && length(index) > 0){
      dataframe$estado[estadosAPreencher[i]] = paises[index]
    }
  }
  
  for(i in 1:length(estados2APreencher)) {
    index = grep(dataframe$q1_4[estados2APreencher[i]], paises)
    if(!is.null(index) && length(index) > 0){
      dataframe$estado2[estados2APreencher[i]] = paises[index]
    }
  }
  dataframe
}

buildCitiesMap = function() {
  library(readr)
  municipios = read_delim("https://raw.githubusercontent.com/mapaslivres/municipios-br/main/tabelas/municipios.csv", delim = ",")
  municipios["regex"] = sprintf("%s|%s|%s|%s", 
                                municipios$name, municipios$slug_name, 
                                municipios$no_accents, municipios$wikipedia_pt)
  municipios %>% subset(., select = c("regex", "uf_code"))
}

