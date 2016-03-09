# main.R
setwd("~/scripts/R/text_predict")

## Source libraries
library(stringi)
library(tm)
library(RWeka)
library(dplyr)
library(magrittr)

## Source scripts
required.scripts  = c('get.R','load.R','clean.R','sample.R')
sapply(required.scripts, source, .GlobalEnv)

## Get and extract data from source
url  = 'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip'
download(url)

## Load each data file into environment
files = c(list.files('./final/en_US'))

for (i in files) {
  name = strsplit(i,"\\.")[[1]]
  assign(name[[2]],loader(i))
}

## 1st Quiz
max(nchar(blogs))
max(nchar(news))
max(nchar(twitter))
love_count <- sum(grepl("love", twitter))
hate_count <- sum(grepl("hate", twitter))
love_count / hate_count
biostats <- grep("biostats", twitter)
twitter[biostats]
sum(grepl("A computer once beat me at chess, but it was no match for me at kickboxing", twitter))

## Clean data
clean()

## Combine data into sample
sampler()

