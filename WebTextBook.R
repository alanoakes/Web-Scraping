#!/bin/bash

# load sites and package
library(rvest)
test1<-read_html("https://www.amazon.com/Best-Sellers-Books-Textbooks/zgbs/books/465600")
test2<-read_html("https://www.amazon.com/Best-Sellers-Books-Textbooks/zgbs/books/465600/ref=zg_bs_pg_2?_encoding=UTF8&pg=2")

# pull html tags from page 1
Price<-test1 %>% html_nodes('.a-size-base.a-color-price') %>% html_text()
Position<-test1 %>% html_nodes('.zg-badge-text') %>% html_text()
BookName<-test1 %>% html_nodes('.p13n-sc-truncate') %>% html_text()
Location<-test1 %>% html_nodes('.a-link-normal.a-text-normal')

# pull html tags from page 2
Price10<-test2 %>% html_nodes('.a-size-base.a-color-price') %>% html_text()
Position10<-test2 %>% html_nodes('.zg-badge-text') %>% html_text()
BookName10<-test2 %>% html_nodes('.p13n-sc-truncate') %>% html_text()
Location10<-test2 %>% html_nodes('.a-link-normal.a-text-normal')

# format data from page 1
Name1<-gsub("\n            ","",BookName)
Name2<-gsub("\n","",Name1)
Name3<-gsub("        ","",Name2)
Position1<-as.numeric(gsub("#","",Position))
Price1<-as.numeric(gsub("[\\$,]", "",Price))
Location1<-gsub('<a class="a-link-normal a-text-normal" href="/','',Location)
Location2<-gsub("ref.*","",Location1)
Location3<-paste("https://www.amazon.com/",Location2)
Location4<-gsub(" ","",Location3)

# format data from page 2
Name10<-gsub("\n            ","",BookName10)
Name20<-gsub("\n","",Name10)
Name30<-gsub("        ","",Name20)
Position20<-as.numeric(gsub("#","",Position10))
Price20<-as.numeric(gsub("[\\$,]", "",Price10))
Location20<-gsub('<a class="a-link-normal a-text-normal" href="/','',Location10)
Location30<-gsub("ref.*","",Location20)
Location40<-paste("https://www.amazon.com/",Location30)
Location50<-gsub(" ","",Location40)

# create data set and write file
Top50<-data.frame(Position1,Price1,Name3,Location4)
names(Top50)<-c("Rank","Price","BookName","Location")
Bot50<-data.frame(Position20,Price20,Name30,Location50)
names(Bot50)<-c("Rank","Price","BookName","Location")
Top100<-rbind(Top50,Bot50)
Top100$Time<-Sys.time()
Order<-c("Time","Rank","Price","BookName","Location")
Top101<-Top100[,Order]

Previous<-read.csv("/home/alanoakes/Documents/WebTest/Top100TextBk.csv")
Top102<-rbind(Top101,Previous)
write.csv(Top102,"/home/alanoakes/Documents/WebTest/Top100TextBk.csv",row.names=F)
