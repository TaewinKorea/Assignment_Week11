########## Creating a new directory and download from Web ########################
if(!file.exists("data")){
  dir.create("data")
}
fileUrl <- "https://www.stats.govt.nz/assets/Uploads/Rental-price-indexes/Rental-price-indexes-February-2021/Download-data/rental-price-indexes-february-2021-csv.csv"
destfile <- "./data/price_index_Feb2021.csv"
download.file(fileUrl, destfile)
list.files("./data")
list.files("/Users/upgra/Documents/인하대 대학원/2021-2학기/1. Logistics data analysis using R programming/Assignment_Week11/data")
read.csv(destfile)
summary(destfile)

######### Conversion to Data table #############
library(data.table)
data1 <- read.table("./data/price_index_Feb2021.csv", sep=",", header=T)
head(data1)
DT <- data.table(data1)
summary(DT)
str(DT)

######### Adding new columns ################
DT[,X:=DATA_VAL*2]
DT[,Y:=0]
DT[,M:= {tmp <- (X+Y); log2(tmp+5)}]
DT[,A:= X>1000]
DT[, B:= mean(X+Y), by=A]
DT[,.N,by=Series_title_1]
setkey(DT,Series_title_1)
DT$C <- rnorm(1203)
DT2 <- cbind(DT, rnorm(1203))
DT2

############# Ordering with plyr #################
library(plyr)
arrange(DT, DATA_VAL)

############ Subsetting variables ################
DT$RICH <- DT$DATA_VAL > 1000
DT
table(DT$RICH)

############# Creating Binary/Categorical variables ################
DT$NotAvailable <- ifelse(DT$TIME_REF <0, TRUE, F)
table(DT$NotAvailable, DT$TIME_REF <0)
DT$CLASS <- cut(DT$DATA_VAL, breaks = quantile(DT$DATA_VAL))
table(DT$Series_title_1,DT$CLASS)

########### Easier cutting ####################
library(Hmisc)
DT$D <- cut2(DT$DATA_VAL, g=5)
table(DT$D)


############# Creating factor variables ############
DT$FACTOR <- factor(DT$Series_title_1)
DT
head(DT)
DT$FACTOR[1:10]
class(DT$FACTOR)


############# Price value average for each product#############3
AA <- split(DT$DATA_VAL, DT$Series_title_1)
sapply(AA, mean)
