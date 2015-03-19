# main.R
setwd("~/scripts/R/text_predict")

## Source libraries
library(stringi)
library(tm)
library(RWeka)
library(dplyr)
library(magrittr)

## Source scripts
required.scripts <- c('get.R','load.R','clean.R','sample.R')
sapply(required.scripts, source, .GlobalEnv)

## Get and extract data from source
url <- 'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip'
download(url)

## Load each data file into environment
files <- c(list.files('./final/en_US'))

for (i in files) {
  name <- strsplit(i,"\\.")[[1]]
  assign(name[[2]],loader(i))
}

## Clean data
clean()

## Sample data
sampler()

