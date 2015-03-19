##  clean.R
clean <- function() {
  twitter <- iconv(twitter, from = "latin1", to = "UTF-8", sub="")
  twitter <- stri_replace_all_regex(twitter, "\u2019|`","'")
  twitter <- stri_replace_all_regex(twitter, "\u201c|\u201d|u201f|``",'"')

  # save the data to .RData files
  save(blogs, file="blogs.RData")
  save(news, file="news.RData")
  save(twitter, file="twitter.RData")
}