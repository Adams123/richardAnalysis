setToZeroAndOne = function(dataframe) {
  for(i in 1:ncol(dataframe)) {
    if(any(dataframe[ , i]==2)){
      dataframe[ , i] = dataframe[ , i]-1
    }
  }
  dataframe
}
