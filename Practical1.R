install.packages("tidyverse")
install.packages("data.table")
data <-read.csv("flights_data.csv")
summary(flights_data)
print(data)
data$TimeOfDay <-ifelse(data$hour >=6 & data$hour <12, "Morning",
ifelse(data$hour >= 12 & data$hour <18, "Afternoon","Night"))
print(data)
head(data)

View(data)
dim(data)
data_sorted <-
data[order(data$year,data$month,data$day,data$hour,data$minute),]
print(data_sorted)

numeric_columns <-
c("dep_time","sched_dep_time","dep_delay","arr_time","sched_arr_time","arr_de
lay","air_time","distance")
data[numeric_columns] <- lapply(data[numeric_columns],function(x){(xmin(x))/(max(x)-min(x))})
print(data)

content <- na.omit(data)
print(content)
data_clean <-data[,colSums(is.na(data))==0]
print(data_clean)
install.packages("dplyr") # if not already installed
library(dplyr)
time_of_day_counts <- data_clean %>%
 group_by(TimeOfDay) %>%
 summarise(flights_count = n())
library("ggplot2")
ggplot(time_of_day_counts,aes(x="",y=flights_count,fill = TimeOfDay))+
 geom_bar(stat="identity",width=1)+
 coord_polar(theta="y")+
 labs(title = "Proportion of flights by time")+
 theme_minimal()+
 theme(axis.text.x = element_blank())
