###############################################
#### WoodPecker-Tonic - Let's beat the market #
###############################################

#Required Libraries - if you don't have them, please run install.packages("library")
library(quantmod)
library(RJSONIO)
library(xts)
library(reshape)
library(readr)

#Getting all stocks traded in last two months - using json file created using Python webscrap (~/Woodpecker-tonic/Fumdamentus/HomeIndicators)
file<-"https://raw.githubusercontent.com/leomartinsjf/woodpecker-tonic/master/Fundamentus/FirstPageData/download.json"
#Pay attention - in case you want updated data, please run Python Webscrap again


#Open Json in R
stocklist<- t(as.data.frame(fromJSON(file, default.size = 1000, depth=500L))) #hybrid function to read json, make a dataframe and transpose it as a matrix
stocklist<-as.data.frame(stocklist) #getting a data frame again 

##Adding created data - just as a referer for futher analysis 
stocklist$dateCreated<-Sys.Date()

#Tronsforming rownames into stock names variables
stocklist$names<-rownames(stocklist)

#Write CSV File
write.csv(stocklist, "stocklist.csv")


#Subset stocks based on fundamental criteria - available variables - optional use

#[1] "Cresc.5a"         "DY"               "Div.Brut/Pat."    "EBITDA"          
#[5] "EV/EBIT"          "Liq.2m."          "Liq.Corr."        "Mrg.Liq."        
#[9] "P/Ativ.Circ.Liq." "P/Ativo"          "P/Cap.Giro"       "P/EBIT"          
#[13] "P/L"              "P/VP"             "PSR"              "Pat.Liq"         
#[17] "ROE"              "ROIC"             "cotacao"         

# stocksubset<-subset(stocklist, as.numeric(PSR)>1) #Here we can subset wich kind of stock will be analysed

#####################################
## Fetching data from Yahoo Finance #
#####################################

#Pay atention - this need to be improved, as the best case cenario is to get all data from complete historical serie from BVMF/Bovespa


#Adding .SA string in order to transform BVMF tick into Yahoo Finance tick
stocklist$yahoooTick<-paste(stocklist$names,".SA",sep="")

#Adding BVMF: string in order to transform BVMF tick into Google Finance tick
stocklist$googleTick<-paste("BVMF:",stocklist$names,sep="") # just in case - not sure but it can be useful 

#Looping through stock names array using getSymbol function
for(i in 1:nrow(stocklist)){
# Using tryCatch to skip errors during the loop
  tryCatch({getSymbols(stocklist$yahoooTick[i],src="yahoo", warnings =F, verbose = F, from="1929-01-01")},error=function(e)
  #Cat erro message in order to check wich Symbols were not included 
    {cat("ERROR :",conditionMessage(e),"\n")}
  )}

#Creating a txt file with Symbols that are out 
outSymbols<-warnings()
write.csv(outSymbols,"outSymbols.txt") #Need to be implemented  - try to scrap those symbols using google finance

#Removing unwanted object
rm(list=c("file","stocklist","outSymbols", "i"))

#Merge Merge Merge
retrivedStocks<-as.data.frame(ls())
names(retrivedStocks)<-c("names")
retrivedStocks$names<-as.character(retrivedStocks$names)
retrivedStocks$symb<-gsub(".SA","",retrivedStocks$names)

#Adding a key for all historical serie
for(i in 1:nrow(retrivedStocks)){
  {object<-get(retrivedStocks$names[i])}
  {object$syb<-paste(retrivedStocks$symb[i])}
  {assign(paste0(retrivedStocks$names[i]), object)}  
}

#Merge
xts_objects<- paste(c, collapse=",")
xts_objects<-as.character(xts_objects)

#Merge Data - This code need to be improved in order to pass symbols through function 
CotationAll<-merge.xts(c(ABCB4.SA,ABEV3.SA,AELP3.SA,AFLT3.SA,AFLU3.SA,AGRO3.SA,
                         AHEB5.SA,AHEB6.SA,ALPA3.SA,ALPA4.SA,
                         ALSC3.SA,ALUP3.SA,ALUP4.SA,AMAR3.SA,ANIM3.SA,ARZZ3.SA,
                         ATOM3.SA,AZEV4.SA,BAHI3.SA,BALM4.SA,BAUH4.SA,BAZA3.SA,
                         BBAS3.SA,BBDC3.SA,BBDC4.SA,BBRK3.SA,BBSE3.SA,BDLL4.SA,
                         BEEF3.SA,BEES3.SA,BEES4.SA,BGIP3.SA,BGIP4.SA,BIOM3.SA,
                         BMEB3.SA,BMEB4.SA,BMIN3.SA,BMIN4.SA))

#Remaming 
names(CotationAll)<-c("Open","High","Low","Close","Volume","Adjusted","names")

####################################
#Merge Data with basic fundamentals#
####################################
dfCotation<-as.data.frame(CotationAll)

#Date - timestamp
dfCotation$time<-rownames(dfCotation)

#Read fundamental data
stocklist <- read_csv("~/Desktop/woodpecker-tonic/StockPrices/stocklist.csv")

#######################
#Needed to be improved #
#######################

#We need to improve Python Scrap code to get all first page information including sector, subsector, etc)

#Merge data using Fudamentus homepage information
StockPrices<- merge(dfCotation,stocklist, all.y=TRUE)

#Write CSV
write.csv(StockPrices, "StockPrices.csv")

################
#Just for FUN #
###############

# display a simple bar chart
getSymbols(c("BVMF3.SA"))
barChart(BVMF3.SA,theme='white.mono',bar.type='hlc')

# display a complex chart
getSymbols(c("BVMF3.SA"))
chartSeries(BVMF3.SA, subset='last 3 months')
addBBands(n = 20, sd = 2, ma = "SMA", draw = 'bands', on = -1)

