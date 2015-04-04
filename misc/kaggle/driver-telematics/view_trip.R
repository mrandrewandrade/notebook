library(ggplot2)

read_trips <- function(driver) {
  
  print(paste("Driver:",driver))
  driver_files <- list.files(path = paste("./drivers/",driver,sep=""))
  for (file in driver_files){
    
    # if the merged dataset doesn't exist, create it
    if (!exists("dataset")){
      dataset <- read.csv(paste("./drivers/",driver,"/",file,sep=""))
      
      dataset$trip <- strsplit(file,"[.]")[[1]][1]
    }
    
    # if the merged dataset does exist, append to it
    if (exists("dataset")){
      temp_dataset <-read.csv(paste("./drivers/",driver,"/",file,sep=""))
      temp_dataset$trip <- strsplit(file,"[.]")[[1]][1]
      dataset<-rbind(dataset, temp_dataset)
      rm(temp_dataset)
    }
    
  }
  dataset$driver <- driver
  return(dataset)
  
  
}


df <- read_trips("1")

qplot(x,y,data=df,geom="path",group=trip,color=trip)

qplot(x,y,data=df,geom="path") + facet_wrap(~trip)