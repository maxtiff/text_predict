# main.R
setwd("~/scripts/R/text_predict")

## Source all required scripts
required.scripts <- c('get.R','load.R')
sapply(required.scripts, source, .GlobalEnv)

## Load required Libraries
# Nothing here yet

## Get and extract data from source
url <- 'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip'
download(url)

## Load data into environment
files <- c(list.files('./final/en_US'))

for (i in files) {
  name <- strsplit(i,"\\.")[[1]]
  assign(name[[2]],loader(i))
}

## Clean data

