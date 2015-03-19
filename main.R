# main.R
setwd("~/scripts/R/text_predict")

## Source all required scripts
required.scripts <- c('get.R')
sapply(required.scripts, source, .GlobalEnv)

## Load required Libraries
# Nothing here yet

## Get and extract data from source
url <- 'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip'
download(url)



