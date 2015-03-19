## load.R
# Read text files into R environment

loader <- function(item) {

    if(tools::file_ext(item)=='txt') {

      # Import 'News' data in binary mode
      if(grepl('news',item)) {
        con <- file(paste('./final/en_US/',item,sep = '/'),open='rb')
        l <- readLines(con, encoding='UTF-8')
        close(con)
        rm(con)
      }
      # Import 'Twitter' and 'Blog' data in text mode
      else {
        l <- readLines(paste('./final/en_US/',item,sep = '/'),skipNul = TRUE,warn = FALSE, encoding = 'UTF-8')
      }
    }

    return(l)
}