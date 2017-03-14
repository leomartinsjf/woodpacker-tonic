###########################################
#Script to passtrough Fundamentus Captcha #
###########################################
library(readr)
library(timeSeries)
library(lubridate)

Sys.setlocale(category = "LC_ALL", locale = "")

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
    #As some companies don't have a balance we need to rename files
    Sys.sleep(2)
    rename<-paste("mv ~/Desktop/woodpecker-tonic/Fundamentus/HistoricalSeries/FundamentosBalance/balanco.xls ~/Desktop/woodpecker-tonic/Fundamentus/HistoricalSeries/FundamentosBalance/balanco-",i,".xls",sep="")
    system(print(rename))
    #1 - It's a good idea to set your download folder to /woodpecker-tonic/Fundamentus/HistoricalSeries/FundamentosBalance
    #2 - Set your browser to open the downloaded file automatically as all of them are named as "balanço" a numbered list will be created
} 

#Removing from list data that was not availible - check for error on terminal
library("xlsx")
read.xlsx("test.xlsx",1,header=F,colClasses=c("character"),encoding="UTF-8")

#Cleaning Data - Patrimonal balance
for(i in c(1:114,117:nrow(stocklist))){
object<- read.xlsx(paste("~/Desktop/woodpecker-tonic/Fundamentus/HistoricalSeries/FundamentosBalance/balanco-",1,".xls", sep=""), sheetName= "Bal. Patrim.",encoding="UTF-8")
object[1,1]<-"Tempo" 
varnames<-object$X1
object<-as.data.frame(t(object))
names(object)<-varnames
object<-object[-c(1),]
assign(paste("Bal.Patrim_", i, sep=""),object)
}

#Cleaning Data - Patrimonal balance
for(i in c(1:114,117:nrow(stocklist))){
  object<- read_excel(paste("~/Desktop/woodpecker-tonic/Fundamentus/HistoricalSeries/FundamentosBalance/balanco-",i,".xls", sep=""), sheet = "Dem. Result.", na = "NA", col_names=F, skip=1)
  object[1,1]<-"Tempo" 
  varnames<-object$X1
  object<-as.data.frame(t(object))
  names(object)<-varnames
  object<-object[-c(1),]
  assign(paste("Dem.Result_", i, sep=""),object)
}

#Merging Data
for(i in c(1)){
object_bal<-get(paste("Bal.Patrim_",1,sep=""))
object_dem<-get(paste("Dem.Result_",1,sep=""))
object<-merge(object_bal,object_dem, by="Tempo", all.x=T, all.y=T)
object$names<-stocklist$names[1]
object$Time <- dmy(object$Tempo, locale="en_US.UTF-8")
object$Time<-as.POSIXct(object$Time)
object<-as.xts(object, object$Time)
assign(paste("Balance_",1, sep=""),object)
write.csv(get(paste("Balance_",i, sep="")),paste("~/Desktop/woodpecker-tonic/Fundamentus/HistoricalSeries/FundamentosBalance/FinalBalance/Balance_",i,".csv",sep=""))
}

z<-zoo(Balance_3)
,Balance_2,Balance_3

#Merging TimeSerie
library(zoo)
balances<- sprintf("Balance_%d",c(1:28,30:114,117:nrow(stocklist)))
t<-do.call(merge,list(x,y,z))

BalanceAll<-merge.xts(Balance_  b1,Balance_2)
as.data.frame(mget(balances))
                      




