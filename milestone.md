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
I samples 10000 lines from each set of text. I save the file for later.

```r
sample_blogs   <- sample(blogs, 10000)
sample_news    <- sample(news, 10000)
sample_twitter <- sample(twitter, 10000)

sample <- c(sample_twitter,sample_news,sample_blogs)

writeLines(sample, "./sample.txt")
```



### Word Cloud

```r
table(c_tdm.d$freq)
```

```
## 
##     1     2     3     4     5     6     7     8     9    10    11    12 
## 23394  4974  2440  1452   988   726   581   467   373   301   284   222 
##    13    14    15    16    17    18    19    20    21    22    23    24 
##   218   189   173   163   126   101   104   115   106    93    72    68 
##    25    26    27    28    29    30    31    32    33    34    35    36 
##    79    73    56    74    76    58    67    44    39    54    53    45 
##    37    38    39    40    41    42    43    44    45    46    47    48 
##    49    42    33    41    35    30    37    23    28    23    33    31 
##    49    50    51    52    53    54    55    56    57    58    59    60 
##    22    23    32    21    19    28    36    24    19    13    18    24 
##    61    62    63    64    65    66    67    68    69    70    71    72 
##    13    26    21    16    18    16    20    19    15    16    11    17 
##    73    74    75    76    77    78    79    80    81    82    83    84 
##    12    11    18     8    14    15    20    12    12    13     8    13 
##    85    86    87    88    89    90    91    92    93    94    95    96 
##    11    11    15    11    15    13    11    17     9    11    11     9 
##    97    98    99   100   101   102   103   104   105   106   107   108 
##     9     5    12    10     7     5     4     9    10    11     9     8 
##   109   110   111   112   113   114   115   116   117   118   119   120 
##     8     7     4    13     7    11     6     3    11     7    10     8 
##   121   122   123   124   125   126   127   128   129   130   131   132 
##     7     9    10     6     5    10     9     4     3     5     6     5 
##   133   134   135   136   137   138   139   140   141   142   143   144 
##     5     9     6     5     5     2     6     5     4     3     7     4 
##   145   146   147   148   149   150   151   152   153   154   155   156 
##     8     8     4     8     4     3     5     7     4     2     5     4 
##   157   158   159   160   161   162   163   164   165   166   167   168 
##     3     5     2     4     3     5     5     1     4     4     7     4 
##   169   170   171   172   173   174   175   176   177   178   179   180 
##     7     4     5     4     4     2     7     5     3     5     2     1 
##   181   182   183   184   185   186   187   188   189   190   191   192 
##     3     5     2     8     1     2     3     1     2     2     6     4 
##   193   195   196   197   198   199   200   201   202   203   204   205 
##     4     1     1     5     5     3     2     1     3     3     1     5 
##   206   207   208   209   210   211   212   213   214   215   216   218 
##     1     5     3     1     5     3     5     3     5     1     2     2 
##   219   220   221   222   223   224   225   226   227   229   231   232 
##     4     1     1     2     2     3     2     1     4     1     3     1 
##   233   234   235   236   237   238   242   243   244   245   246   248 
##     3     2     2     1     5     2     1     1     2     3     2     4 
##   249   250   251   252   253   254   255   257   258   259   260   261 
##     3     3     3     2     2     4     4     5     2     2     5     3 
##   262   264   265   266   267   268   269   270   271   272   273   274 
##     1     1     2     3     3     2     3     1     4     1     1     4 
##   275   276   277   282   283   284   287   290   291   292   293   294 
##     1     2     1     1     2     1     2     4     1     2     2     1 
##   296   297   298   300   301   302   303   304   305   306   307   308 
##     1     2     1     1     2     2     3     2     2     3     3     1 
##   309   310   311   312   314   315   316   318   319   320   321   322 
##     2     2     1     2     1     5     1     1     2     2     2     2 
##   323   324   325   326   327   328   329   330   332   333   334   335 
##     2     3     1     2     2     3     1     1     1     1     1     1 
##   338   339   340   341   344   346   348   349   351   352   353   354 
##     2     1     1     1     2     2     1     1     2     1     2     2 
##   355   356   358   360   361   362   363   365   369   370   371   372 
##     1     2     1     1     1     2     1     2     1     1     1     1 
##   374   375   377   378   379   384   387   388   391   393   394   395 
##     2     1     1     2     1     1     1     3     1     1     1     1 
##   397   399   402   405   407   411   416   419   421   422   423   440 
##     1     1     1     1     3     1     1     1     2     1     1     1 
##   441   444   446   447   448   458   459   460   461   465   467   470 
##     1     1     1     1     1     1     1     1     2     2     1     2 
##   478   488   489   493   497   498   499   507   513   515   516   520 
##     3     2     1     1     1     1     1     1     1     1     1     1 
##   521   531   543   545   546   548   552   560   566   567   570   571 
##     1     1     1     1     1     2     3     1     1     1     1     1 
##   578   581   588   589   591   599   605   606   611   612   616   618 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##   620   625   630   635   640   645   667   672   685   686   696   709 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##   712   732   738   740   743   750   761   764   783   793   798   800 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##   805   812   822   841   859   872   875   877   879   895   954   994 
##     1     1     2     1     1     1     1     1     1     1     1     1 
##  1009  1028  1058  1073  1076  1104  1105  1118  1132  1156  1157  1169 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##  1211  1218  1231  1243  1260  1311  1333  1343  1354  1400  1417  1437 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##  1443  1537  1671  1735  1971  2087  2227  2230  2259  2448  2772  2820 
##     1     1     1     1     1     1     1     1     1     1     1     1 
##  2903 
##     1
```

```r
pal2 = brewer.pal(8,"Dark2")
png("wordcloud_packages.png", width=1280,height=800)
wordcloud(c_tdm.d$word,c_tdm.d$freq, scale=c(8,.2),min.freq=1000,
          max.words=Inf, random.order=FALSE, rot.per=.15, colors=pal2)
dev.off()
```

```
## png 
##   2
```
