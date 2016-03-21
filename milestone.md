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
Since the data is so large, I sample 10000 lines from each set of text and I save the file for later.

```r
sample_blogs   <- sample(blogs, 10000)
sample_news    <- sample(news, 10000)
sample_twitter <- sample(twitter, 10000)

sample <- c(sample_twitter,sample_news,sample_blogs)

writeLines(sample, "./sample.txt")
```

### Data Set Summary tatistical Table
Below is a table that gives a quick look at the data files compared with the sample data.



```r
knitr::kable(head(fileSummaryDF, 10))
```



File Name            File Size (Mbs)   Line Count   Word Count
------------------  ----------------  -----------  -----------
Blogs                         200.42       899288     37334441
News                          196.28      1010242     34372598
Twitter                       159.36      2360148     30373832
Aggregated Sample               4.96        30000        30000

### Tokenization
Now that the data is in a more workable form, I utilize the 'tm' package to transform the text, remove punctuation and stop words, and stem the document before loading the text into a matrix. This matrix is used to construct a word cloud.

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


```r
c_tdm    = TermDocumentMatrix(s.corpus)
c_tdm    = rollup(c_tdm, 2, na.rm=TRUE, FUN = sum)
c_tdm.m  = as.matrix(c_tdm)
c_tdm.v  = sort(rowSums(c_tdm.m),decreasing=TRUE)
c_tdm.d  = data.frame(word = names(c_tdm.v),freq=c_tdm.v)
table(c_tdm.d$freq)
```

```
## 
##     1     2     3     4     5     6     7     8     9    10    11    12 
## 23039  4968  2428  1390  1019   729   572   436   382   306   275   238 
##    13    14    15    16    17    18    19    20    21    22    23    24 
##   178   181   168   142   143   126   116   109   101    91    75    85 
##    25    26    27    28    29    30    31    32    33    34    35    36 
##    82    65    48    69    55    69    48    52    53    57    45    38 
##    37    38    39    40    41    42    43    44    45    46    47    48 
##    38    31    39    35    37    31    31    36    37    25    23    33 
##    49    50    51    52    53    54    55    56    57    58    59    60 
##    26    20    28    26    24    24    25    31    16    18    20    26 
##    61    62    63    64    65    66    67    68    69    70    71    72 
##    17    19    18    22    18    16    12    16    19    17    11    13 
##    73    74    75    76    77    78    79    80    81    82    83    84 
##    15    10    15    15    15    14    16    10    16    14    11    10 
##    85    86    87    88    89    90    91    92    93    94    95    96 
##    15    16    11    13    10    12     9     8    14     7    14    11 
##    97    98    99   100   101   102   103   104   105   106   107   108 
##    10     8    13    13     7    12     7    12     6     7    11     8 
##   109   110   111   112   113   114   115   116   117   118   119   120 
##     8     7     7     7     5     3     3     5    10     6     4     7 
##   121   122   123   124   125   126   127   128   129   130   131   132 
##     2     4     8     8    12     4     5     9    12     4     5     5 
##   133   134   135   136   137   138   139   140   141   142   143   144 
##     5     7     7     7     5     5     5     5     3     6     8     7 
##   145   146   147   148   149   150   151   152   153   154   155   157 
##    10     3     5     5     3     8     2     3    11     1     9     3 
##   158   159   160   161   162   163   164   165   166   167   168   169 
##     2     4     2     4     3     4     3     2     5     2     7     6 
##   170   171   172   173   174   175   176   177   178   179   180   181 
##     6     1     3     7     5     7     3     2     2     1     5     3 
##   182   183   184   185   186   187   188   189   190   191   192   193 
##     5     3     1     4     1     3     2     2     2     5     3     2 
##   194   195   196   197   198   199   200   201   202   203   204   205 
##     3     2     9     2     2     1     3     3     6     2     5     5 
##   206   207   208   209   210   211   212   213   214   215   216   217 
##     1     2     5     1     3     1     4     2     4     2     5     4 
##   218   219   220   221   222   223   224   225   227   228   229   231 
##     2     2     1     3     4     1     1     2     2     1     1     2 
##   232   233   234   235   236   237   238   239   240   241   242   243 
##     3     1     6     2     3     3     3     4     4     1     1     4 
##   245   246   247   249   250   252   253   254   255   256   258   259 
##     1     6     1     3     1     1     3     3     2     4     1     1 
##   260   261   263   264   265   266   267   268   271   272   273   275 
##     1     4     2     4     1     1     2     3     3     3     3     3 
##   276   277   278   279   280   282   283   284   287   289   290   291 
##     2     2     1     1     6     4     3     2     3     1     1     1 
##   292   293   294   295   296   297   298   300   302   303   306   307 
##     1     2     1     2     2     2     2     2     2     1     2     3 
##   308   309   310   311   312   313   314   315   316   318   319   320 
##     1     2     2     1     2     2     1     1     1     3     4     2 
##   322   323   324   326   328   329   330   332   339   340   341   342 
##     1     1     1     1     1     3     1     2     1     1     2     2 
##   343   344   346   347   351   352   354   357   359   361   362   363 
##     2     1     2     1     1     1     2     2     1     2     3     2 
##   366   367   369   370   374   375   377   378   380   381   382   383 
##     2     2     1     3     1     3     1     1     1     1     1     1 
##   387   388   389   391   392   400   403   404   406   407   408   417 
##     2     1     1     1     1     1     1     1     1     1     2     2 
##   422   423   426   427   432   435   437   438   439   440   442   443 
##     2     1     1     1     1     1     1     1     1     2     1     1 
##   444   445   454   455   457   458   460   462   463   469   473   484 
##     1     1     1     1     1     2     1     1     1     1     1     1 
##   494   495   500   501   503   506   509   510   515   516   519   522 
##     2     1     1     1     1     1     1     1     1     1     2     1 
##   527   535   546   547   548   552   565   570   572   579   580   589 
##     1     1     1     1     1     1     1     3     1     1     1     1 
##   590   593   595   596   612   613   620   622   625   627   633   637 
##     1     1     1     1     1     2     1     1     1     2     1     1 
##   644   648   664   669   706   708   718   733   740   744   747   749 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##   752   766   783   786   788   801   808   811   825   826   829   848 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##   854   888   890   901   902   906   928   958   961  1028  1047  1050 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##  1100  1105  1114  1119  1139  1165  1182  1188  1200  1220  1229  1246 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##  1250  1259  1264  1377  1388  1389  1403  1411  1504  1621  1641  1716 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##  1938  1990  2279  2285  2293  2349  2630  2723  2986 
##     1     1     1     1     1     1     1     1     1
```

```r
pal2 = brewer.pal(8,"Dark2")
wordcloud(c_tdm.d$word,c_tdm.d$freq, scale=c(5,.3),min.freq=1000,
          max.words=Inf, random.order=FALSE, rot.per=.15, colors=pal2)
```

![](milestone_files/figure-html/unnamed-chunk-11-1.png)<!-- -->



