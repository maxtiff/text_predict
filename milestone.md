# Coursera: Johns Hopkins Data Science Capstone - Milestone Report
Travis May  



```
##         get.R load.R clean.R sample.R
## value   ?     ?      ?       ?       
## visible FALSE FALSE  FALSE   FALSE
```
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

### Clean the data
 Next, I use regular expressions to clean out any unusual characters that may affect my analysis.

```r
blogs <- stri_replace_all_regex(blogs, "\u2019|`","'")
blogs <- stri_replace_all_regex(blogs, "\u201c|\u201d|u201f|``",'"')
news <- stri_replace_all_regex(news, "\u2019|`","'")
news <- stri_replace_all_regex(news, "\u201c|\u201d|u201f|``",'"')
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

