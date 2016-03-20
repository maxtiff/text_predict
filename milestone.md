# Coursera: Johns Hopkins Data Science Capstone - Milestone Report
Travis May  



# Introduction:
The purpose of this milestone report is to indicate that I am sufficiently capable of handling large data sets within the R framework. The data set that I will use is a corpora of curated text from various blogs, news sites, and twitter posts, or 'tweets'. I will apply this data set to a text prediction algorithim which will be compiled into a Shiny application in the second half of the course.

The remaining sections of this report will first explain how I extract and clean the data, and then present the analysis of data required for successful implementation of the text prediction app.

# The Data:
The HC Corpora is sourced as provided by the course instructors. The data is located at http://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip. More detailed information about the corpora at http://www.corpora.heliohost.org/aboutcorpus.html.


## Data Processing
The corpora is available in multiple languages, but for the purposes of this project I will only use the files in US English.

### Download 

```r
fileURL <- "http://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(fileURL, destfile = "Dataset.zip", method = "curl")
unlink(fileURL)
unzip("Dataset.zip")
```

### Read into Environment
I use a custom function to read in the data iteratively.The function also converts the data from 'latin1' encoding to 'UTF-8'.

#### The function:

```r
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
```

#### Using the function on the downloaded files: 

```r
files = c(list.files('./final/en_US'))

for (i in files) {
  name = strsplit(i,"\\.")[[1]]
  assign(name[[2]],loader(i))
}
```

### Data Set Statistical Table

### Clean the data
Next, I use regular expressions to clean out any unusual characters that may affect my analysis.

```r
blogs <- iconv(blogs,from="latin1", to = "UTF-8", sub="")
blogs <- stri_replace_all_regex(blogs, "\u2019|`","'")
blogs <- stri_replace_all_regex(blogs, "\u201c|\u201d|u201f|``",'"')
news <- iconv(news,from="latin1", to = "UTF-8", sub="")
news <- stri_replace_all_regex(news, "\u2019|`","'")
news <- stri_replace_all_regex(news, "\u201c|\u201d|u201f|``",'"')
twitter <- iconv(twitter, from = "latin1", to = "UTF-8", sub="")
twitter <- stri_replace_all_regex(twitter, "\u2019|`","'")
twitter <- stri_replace_all_regex(twitter, "\u201c|\u201d|u201f|``",'"')
```

### Sample the data
I samples 10000 lines from each set of text. I save the file for later.

```r
sample_blogs   <- sample(blogs, 10000)
sample_news    <- sample(news, 10000)
sample_twitter <- sample(twitter, 10000)

sample <- c(sample_twitter,sample_news,sample_blogs)

writeLines(sample, "./sample.txt")
```


### Tokenization
I utilize the 'tm' package to transform the text, remove punctuation and stop words, and stem the document before loading the text into a matrix. This matrix is used to construct a word cloud.

```r
vs.s = VectorSource(sample)
s.corpus = VCorpus(vs.s)
s.corpus = tm_map(s.corpus, content_transformer(tolower))
s.corpus = tm_map(s.corpus, removePunctuation)
s.corpus = tm_map(s.corpus, removeNumbers)
s.corpus = tm_map(s.corpus, function(x) removeWords(x, stopwords("english")))
s.corpus = tm_map(s.corpus, stemDocument)

c_tdm    = TermDocumentMatrix(s.corpus)
c_tdm    = rollup(c_tdm, 2, na.rm=TRUE, FUN = sum)
c_tdm.m  = as.matrix(c_tdm)
c_tdm.v  = sort(rowSums(c_tdm.m),decreasing=TRUE)
c_tdm.d  = data.frame(word = names(c_tdm.v),freq=c_tdm.v)
```

#### Text Word Cloud

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : just could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : get could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : year could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : make could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : know could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : work could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : want could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : good could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : think could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : back could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : look could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : see could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : two could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : come could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : need could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : way could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : thing could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : last could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : even could not be fit on page. It will not be plotted.
```

```
## Warning in wordcloud(c_tdm.d$word, c_tdm.d$freq, scale = c(8, 0.7),
## min.freq = 1000, : much could not be fit on page. It will not be plotted.
```

![](milestone_files/figure-html/unnamed-chunk-9-1.png)<!-- -->
