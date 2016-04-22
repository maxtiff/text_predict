suppressPackageStartupMessages(c(
        library(shinythemes),
        library(shiny),
        library(tm),
        library(stringr),
        library(markdown),
        library(stylo)))

source("./inputCleaner.R")

final4Data <- readRDS(file="./data/final4Data.RData")
final3Data <- readRDS(file="./data/final3Data.RData")
final2Data <- readRDS(file="./data/final2Data.RData")