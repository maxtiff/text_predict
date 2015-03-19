# get.R
download <- function(url) {

  temp <- tempfile(pattern="data",fileext=".zip")

  if(!file.exists(temp)) {
    download.file(url, temp)
  }

  unzip(temp)
  unlink(temp)

}




