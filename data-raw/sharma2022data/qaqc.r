## Libraries
library(tidyverse)
library(broom)

## Data
data <- read.csv("data//78_lakes_ts_minimal.csv", stringsAsFactors = F)


### Check dates
convertDate <- function(x){
  dates <- as.Date(x, "%Y-%m-%d") ## YYYY/mm/dd
  return(dates)
}

## Convert dates to date values
dateCol <- names(data)[11:22]
for(i in dateCol){
  data[,i] <- convertDate(data[,i])
}

## Compare ice on to ice off dates
ggplot(data %>% filter(lake == "suwa") %>% filter(!is.na(ice_off_1)), aes(x=ice_on_1, y=ice_off_1))  + geom_point()

m1 <- lm(as.numeric(ice_off_1) ~ as.numeric(ice_on_1), data= data %>% filter(lake == "suwa") %>% filter(!is.na(ice_off_1)))
summary(m1)


## calculate regressions for each lake
fits <- data %>% filter(!is.na(ice_off_1))%>% filter(!is.na(ice_on_1)) %>%   ## Drop NAs
  group_by(lake) %>%  ## group by each lake
  do(glance(lm(as.numeric(ice_off_1) ~ as.numeric(ice_on_1), data=.))) ## run linear models on each
sort(fits$adj.r.squared)

## Repeat for second ice off
fits <- data %>% filter(!is.na(ice_off_2))%>% filter(!is.na(ice_on_2)) %>%   ## Drop NAs
  group_by(lake) %>%  ## group byh each lake
  do(glance(lm(as.numeric(ice_off_1) ~ as.numeric(ice_on_1), data=.))) ## run linear models on each
sort(fits$adj.r.squared)

## Repeat for third ice off
fits <- data %>% filter(!is.na(ice_off_3))%>% filter(!is.na(ice_on_3)) %>%   ## Drop NAs
  group_by(lakecode) %>%  ## group byh each lake
  do(glance(lm(as.numeric(ice_off_1) ~ as.numeric(ice_on_1), data=.))) ## run linear models on each
sort(fits$adj.r.squared)


### Check min and max date to next closest date
nextMin <- function(x){
  nextMinDate <- min(x, na.rm=T) - min(x[x != min(x, na.rm=T)], na.rm=T)
  nextYear <- abs(as.numeric(nextMinDate)/365) ## returns in # days, needs to be converted to years
  return(round(nextYear,0))
}

nextMax <- function(x){
  nextMaxDate <- max(x, na.rm=T) - max(x[x != max(x, na.rm=T)], na.rm=T)
  nextYear <- abs(as.numeric(nextMaxDate)/365) ## returns in # days, needs to be converted to years
  return(round(nextYear,0))
}


## Examine for each lake
data %>% group_by(lakecode) %>% summarize(min2iceOn = nextMin(ice_on_1), max2iceOn = nextMax(ice_on_1), 
                                          min2iceOff = nextMin(ice_off_1), max2iceOff = nextMax(ice_off_1)) %>%   data.frame()

### Check the characters associated with each lake

## Convert multiple freeze dates to long format
data["ID"] <- row.names(data)

### convert each metric into long format
freezeYN <- data %>% select(ID, lakecode:froze_6, orig_duration:other_lakenames) %>%  ## select columns to gather
            gather(freezeEvent, froze, froze_1:froze_6)
iceOnwide <- data %>% select(ID, froze_1 = ice_on_1, froze_2 = ice_on_2,froze_3 = ice_on_3,froze_4 = ice_on_4,froze_5 = ice_on_5,froze_6 = ice_on_6 ) %>%  ## select columns to gather
  gather(freezeEvent, iceOn, froze_1:froze_6)
iceOffwide <- data %>% select(ID, froze_1 = ice_off_1, froze_2 = ice_off_2,froze_3 = ice_off_3, froze_4 = ice_off_4,froze_5 = ice_off_5,froze_6 = ice_off_6) %>%  ## select columns to gather
  gather(freezeEvent, iceOff, froze_1:froze_6)

## Join together datasets
longData <- plyr::join(freezeYN, iceOnwide)
longData <- plyr::join(longData, iceOffwide)

## Replace blanks with NA
longData$froze <- ifelse(longData$froze == "", NA,longData$froze )


simplified <- longData[!apply(longData[,c("froze","iceOn","iceOff")], 1 ,FUN= function(x) sum(is.na(x)))==3,]

write.csv(simplified[,-1], "data/PhenologyData.csv", row.names=FALSE)


### Extract the number of observations for the tables in manuscript
lengthNA <- function(x) { length(x[!is.na(x)])}
summaryOut <- simplified %>% summarize_all(lengthNA)/nrow(simplified)*100 %>% round(., 2)

# write.csv(summaryOut, "Table2.csv", row.names=F)