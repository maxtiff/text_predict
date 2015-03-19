## load.R
# Read text files into R environment

loader <- function(item) {

    if(tools::file_ext(item)=='txt') {
      l <- readLines(paste('./final/en_US/',item,sep = '/'),skipNul = TRUE,warn = FALSE)
    }

    return(l)
}