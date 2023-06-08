message('Loading Packages')
library(rvest)
library(tidyverse)
library(mongolite)

message('Scraping Data')
jenis_konten1<-c("cover","mukbang","olahraga","kesehatan","motivasi","kuliah","coding","gaming","film","challenge","anime","bisnis",
                 "fashion","komedi","wisata","petualangan","viral","dance","cosplay","politik","dakwah","guitar","make up","live",
                 "berbagi","fotografi","traveling","podcast","ometv","daily","edukasi","tips","trick","sketsa","lifehack","masak")
konten<-sample(jenis_konten1,1)
url<-paste0("https://tiktokhashtags.com/hashtag/",konten,"/")
link<-read_html(url)
tabel<- link%>% html_nodes("table") %>% html_table()
tabel<-as.data.frame(tabel)
jenis_konten<-konten
tabel2<-tabel[sample(1:nrow(tabel),5),-1]
tabel2$Hashtag<-gsub("\\W","",tabel2$Hashtag)
tabel2$Posts<-as.numeric(gsub("\\D","",tabel2$Posts))
tabel2$Views<-as.numeric(gsub("\\D","",tabel2$Views))
tabel2$Post.Views<-as.numeric(gsub("\\D","",tabel2$Post.Views))
tabel3<-data.frame(jenis_konten,tabel2)
colnames(tabel3)<-c("jenis_konten","hashtag","jumlah_video","total_views","rata2_view_video")
rownames(tabel3)<-NULL
tabel3$time<-Sys.Date()

#MONGODB
message('Input Data to MongoDB Atlas')
atlas_conn <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas_conn$insert(tabel3)
rm(atlas_conn)
