###########################################
#Script to passtrough Fundamentus Captcha #
###########################################
library(readr)
library(timeSeries)
library(lubridate)

#Get stock list
stocklist <- read_csv("~/Desktop/woodpecker-tonic/StockPrices/stocklist.csv")

#Set directory
setwd("~/Desktop/woodpecker-tonic/Fundamentus/HistoricalSeries")

#1 - Open your favourite browser and get the captcha for today
#2 - Set your download directory to Historical Series
#3 - Change the captcha 

#Let's get some data - cheating a isi captcha 
for(i in 1:nrow(stocklist)){
  {browseURL(paste("http://fundamentus.com.br/balancos.php?papel=",stocklist$names[i],"&tipo=1",sep =""))}
  Sys.sleep(5)
    #Change here your hash that you get afater solve your first captcha 
    {browseURL("http://fundamentus.com.br/planilhas.php?SID=9gcuaieik1r1cea6flbeun0mt5")}
    Sys.sleep(15)
    #Apple script to close tabs in order to save some memory - safari is too greedy 
    system("osascript ~/Desktop/woodpecker-tonic/Fundamentus/HistoricalSeries/closetabs.scpt")
    #1 - It's a good idea to set your download folder to /woodpecker-tonic/Fundamentus/HistoricalSeries/FundamentosBalance
    #2 - Set your browser to open the downloaded file automatically as all of them are named as "balanço" a numbered list will be created
  } 

#Cleaning Data - Patrimonal balance
for(i in 1:(nrow(stocklist))){
object<- read_excel(paste("~/Desktop/woodpecker-tonic/Fundamentus/HistoricalSeries/FundamentosBalance/balanco-",i,".xls", sep=""), sheet = "Bal. Patrim.", na = "NA", col_names=F, skip=1)
object[1,1]<-"Tempo" 
varnames<-object$X1
object<-as.data.frame(t(object))
names(object)<-varnames
object<-object[-c(1),]
assign(paste("Bal.Patrim_", i, sep=""),object)
}

#Cleaning Data - Patrimonal balance
for(i in 1:(nrow(stocklist))){
  object<- read_excel(paste("~/Desktop/woodpecker-tonic/Fundamentus/HistoricalSeries/FundamentosBalance/balanco-",i,".xls", sep=""), sheet = "Dem. Result.", na = "NA", col_names=F, skip=1)
  object[1,1]<-"Tempo" 
  varnames<-object$X1
  object<-as.data.frame(t(object))
  names(object)<-varnames
  object<-object[-c(1),]
  assign(paste("Dem.Result_", i, sep=""),object)
}

#Merging Data
for(i in 1:nrow(stocklist)){
object_bal<-get(paste("Bal.Patrim_",i,sep=""))
object_dem<-get(paste("Dem.Result_",i,sep=""))
object<-merge(object_bal,object_dem, by="Tempo", all.x=T, all.y=T) 
object$names<-stocklist$names[i]
object$Time <- dmy(object$Tempo, locale="en_US.UTF-8")
assign(paste("Balance_",i, sep=""),object)
write.csv(paste("Balance_",i, sep=""),paste("Balance_",i,".csv",sep=""))
}


