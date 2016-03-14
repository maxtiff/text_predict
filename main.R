# main.R
setwd("~/text_predict")

## Source libraries
library(stringi)
library(tm)
library(RWeka)
library(dplyr)
library(magrittr)
library(R.utils)
require(jsonlite)
require(RJSONIO)
require(rjson)
require(foreach)
require(doSNOW)
require(wordcloud)
require(RColorBrewer)
require(ggplot2)
require(slam)
require(lda)
require(LDAvis)
require(e1071)
require(caret)
require(ngram)


## Source scripts
required.scripts  = c('get.R','load.R','clean.R','sample.R')
sapply(required.scripts, source, .GlobalEnv)

## Get and extract data from source
# url  = 'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip'
# download(url)

## Load each data file into environment
files = c(list.files('./final/en_US'))

for (i in files) {
  name = strsplit(i,"\\.")[[1]]
  assign(name[[2]],loader(i))
}

## 1st Quiz
	# max(nchar(blogs))
	# max(nchar(news))
	# max(nchar(twitter))
	# countLines(twitter)
	# love_count <- sum(grepl("love", twitter))
	# hate_count <- sum(grepl("hate", twitter))
	# love_count / hate_count
	# biostats <- grep("biostats", twitter)
	# twitter[biostats]
	# sum(grepl("A computer once beat me at chess, but it was no match for me at kickboxing", twitter))

## Clean data
# clean()
blogs <- iconv(blogs,from="latin1", to = "UTF-8", sub="")
blogs <- stri_replace_all_regex(blogs, "\u2019|`","'")
blogs <- stri_replace_all_regex(blogs, "\u201c|\u201d|u201f|``",'"')
news <- iconv(news,from="latin1", to = "UTF-8", sub="")
news <- stri_replace_all_regex(news, "\u2019|`","'")
news <- stri_replace_all_regex(news, "\u201c|\u201d|u201f|``",'"')
twitter <- iconv(twitter, from = "latin1", to = "UTF-8", sub="")
twitter <- stri_replace_all_regex(twitter, "\u2019|`","'")
twitter <- stri_replace_all_regex(twitter, "\u201c|\u201d|u201f|``",'"')

# save the data to .RData files
# save(blogs, file="blogs.RData")
# save(news, file="news.RData")
# save(twitter, file="twitter.RData")

# ## Combine data into sample
# # sampler()
# rdata <- list('blogs.Rdata', 'news.Rdata', 'twitter.Rdata')

# lapply(rdata,load)
#   load("blogs.RData")
#   load("news.RData")
#   load("twitter.RData")

# sample data (100,000 of each)
sample_blogs   <- sample(blogs, 1000)
sample_news    <- sample(news, 1000)
sample_twitter <- sample(twitter, 1000)
# save(sample_blogs, sample_news, sample_twitter, file= "sample_data.RData")

# test = load('sample_data.Rdata')
# test = rbind(sample_twitter,sample_news,sample_blogs)
# test = test[1,]

##### Initial Exploration ######
vs.b     = VectorSource(sample_blogs)
blogs.corpus = VCorpus(vs.b)
blogs.corpus = tm_map(blogs.corpus, content_transformer(tolower))
blogs.corpus = tm_map(blogs.corpus, removePunctuation)
blogs.corpus = tm_map(blogs.corpus, removeNumbers)
blogs.corpus = tm_map(blogs.corpus, function(x) removeWords(x, stopwords("english")))
blogs.corpus = tm_map(blogs.corpus, stemDocument)

vs.n     = VectorSource(sample_news)
news.corpus = VCorpus(vs.n)
news.corpus = tm_map(news.corpus, content_transformer(tolower))
news.corpus = tm_map(news.corpus, removePunctuation)
news.corpus = tm_map(news.corpus, removeNumbers)
news.corpus = tm_map(news.corpus, function(x) removeWords(x, stopwords("english")))
news.corpus = tm_map(news.corpus, stemDocument)

vs.t     = VectorSource(sample_twitter)
twitter.corpus = VCorpus(vs.t)
twitter.corpus = tm_map(twitter.corpus, content_transformer(tolower))
twitter.corpus = tm_map(twitter.corpus, removePunctuation)
twitter.corpus = tm_map(twitter.corpus, removeNumbers)
twitter.corpus = tm_map(twitter.corpus, function(x) removeWords(x, stopwords("english")))
twitter.corpus = tm_map(twitter.corpus, stemDocument)

# Create word cloud
c_tdm    = TermDocumentMatrix(myCorpus)
c_tdm    = rollup(c_tdm, 2, na.rm=TRUE, FUN = sum)
c_tdm.m  = as.matrix(c_tdm)
c_tdm.v  = sort(rowSums(c_tdm.m),decreasing=TRUE)
c_tdm.d  = data.frame(word = names(c_tdm.v),freq=c_tdm.v)
table(c_tdm.d$freq)
pal2 = brewer.pal(8,"Dark2")
png("wordcloud_packages.png", width=1280,height=800)
wordcloud(c_tdm.d$word,c_tdm.d$freq, scale=c(8,.2),min.freq=1000,
          max.words=Inf, random.order=FALSE, rot.per=.15, colors=pal2)
dev.off()

# LDA model test
stop_words <- stopwords("SMART")

reviews <- gsub("'", "", merged$text)  # remove apostrophes
reviews <- gsub("[[:punct:]]", " ", reviews)  # replace punctuation with space
reviews <- gsub("[[:cntrl:]]", " ", reviews)  # replace control characters with space
reviews <- gsub("^[[:space:]]+", "", reviews) # remove whitespace at beginning of documents
reviews <- gsub("[[:space:]]+$", "", reviews) # remove whitespace at end of documents
reviews <- tolower(reviews)  # force to lowercase

# tokenize on space and output as a list:
doc.list <- strsplit(reviews, "[[:space:]]+")

# compute the table of terms:
term.table <- table(unlist(doc.list))
term.table <- sort(term.table, decreasing = TRUE)

# remove terms that are stop words or occur fewer than 5 times:
del <- names(term.table) %in% stop_words | term.table < 5
term.table <- term.table[!del]
vocab <- names(term.table)

# now put the documents into the format required by the lda package:
get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}
documents <- lapply(doc.list, get.terms)

# Compute some statistics related to the data set:
D <- length(documents)  # number of documents (2,000)
W <- length(vocab)  # number of terms in the vocab (14,568)
doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
N <- sum(doc.length)  # total number of tokens in the data (546,827)
term.frequency <- as.integer(term.table)  # frequencies of terms in the corpus [8939, 5544, 2411, 2410, 2143, ...]

# MCMC and model tuning parameters:
K     = 20
G     = 5000
alpha = 0.02
eta   = 0.02

set.seed(46)
t1    = Sys.time()
fit   = lda.collapsed.gibbs.sampler(documents, K=K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, eta = eta, 
                                   initial = NULL, burnin = 0, compute.log.likelihood = T )
t2    = Sys.time()

t2-t1

theta = t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
phi   = t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))

bjr   =  list(phi = phi,
              theta = theta,
              doc.length = doc.length,
              vocab = vocab,
              term.frequency = term.frequency)

json <- createJSON(phi = bjr$phi, 
                   theta = bjr$theta, 
                   doc.length = bjr$doc.length, 
                   vocab = bjr$vocab, 
                   term.frequency = bjr$term.frequency)
