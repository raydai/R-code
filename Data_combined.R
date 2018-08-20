
#creata testing files
n=20
# creat 40 files
for (i in 1:40) {
  data.temp<-data.frame("ID"=seq(1:n),
                        "V2"=sample(letters,n,replace = F),
                        "V3"=runif(n = n,min = 0,100))
  write.csv(x = data.temp,file = paste("datatemp",i,".csv",sep = ""),row.names = F)
}


# find the files you want to import
files <- list.files(pattern = ".csv")

# read your first file
all.data<-read.csv(files[1])
colnames(all.data)[3]<-gsub(replacement = "",pattern =".csv",x = files[1])

# append rest of the files
for (i in files[-1]) {
  assign("temp.import",read.csv(i))
  subject.name<-gsub(replacement = "",pattern =".csv",x = i)
  colnames(temp.import)<-c("ID","V2",subject.name)
  all.data<-merge(all.data,temp.import[,c(1,3)],by = "ID",all = TRUE)
}

write.csv(x =all.data,file = "all.csv",row.names = F)

