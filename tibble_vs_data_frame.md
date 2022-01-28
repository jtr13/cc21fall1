# Tibble vs. DataFrame

Jingfei Fang




```r
library(tidyverse)
library(tibble)
```

### Introduction
A tibble is often considered a neater format of a data frame, and it is often used in the tidyverse and ggplot2 packages. It contains the same information as a data frame, but the manipulation and representation of tibbles is different from data frames in some aspects.

### 1. Getting started with tibbles

You can do it with tidyverse:

```r
#install.packages("tidyverse")
library(tidyverse)
```

Or you can do it by installing tibble package directly:

```r
#install.packages("tibble")
library(tibble)
```


### 2. Creating a tibble

You can create a tibble directly:

```r
tib <- tibble(a = c(1,2,3), b = c(4,5,6), c = c(7,8,9))
tib
```

```
## # A tibble: 3 × 3
##       a     b     c
##   <dbl> <dbl> <dbl>
## 1     1     4     7
## 2     2     5     8
## 3     3     6     9
```

Or you can create a tibble from an existing data frame by using as_tibble(). We will use 'iris' dataset as an example:

```r
df <- iris
class(df)
```

```
## [1] "data.frame"
```

```r
tib <- as_tibble(df)
tib
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1          5.1         3.5          1.4         0.2 setosa 
##  2          4.9         3            1.4         0.2 setosa 
##  3          4.7         3.2          1.3         0.2 setosa 
##  4          4.6         3.1          1.5         0.2 setosa 
##  5          5           3.6          1.4         0.2 setosa 
##  6          5.4         3.9          1.7         0.4 setosa 
##  7          4.6         3.4          1.4         0.3 setosa 
##  8          5           3.4          1.5         0.2 setosa 
##  9          4.4         2.9          1.4         0.2 setosa 
## 10          4.9         3.1          1.5         0.1 setosa 
## # … with 140 more rows
```


### 3. Unlike data frames, tibbles don't show the entire dataset when you print it.

```r
tib
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1          5.1         3.5          1.4         0.2 setosa 
##  2          4.9         3            1.4         0.2 setosa 
##  3          4.7         3.2          1.3         0.2 setosa 
##  4          4.6         3.1          1.5         0.2 setosa 
##  5          5           3.6          1.4         0.2 setosa 
##  6          5.4         3.9          1.7         0.4 setosa 
##  7          4.6         3.4          1.4         0.3 setosa 
##  8          5           3.4          1.5         0.2 setosa 
##  9          4.4         2.9          1.4         0.2 setosa 
## 10          4.9         3.1          1.5         0.1 setosa 
## # … with 140 more rows
```

### 4. Tibbles cannot access a column when you provide a partial name of the column, but data frames can.
#### Tibble
If you try to match the column name with only a partial name, it will not work.

```r
tib <- tibble(str = c("a","b","c","d"), int = c(1,2,3,4))
tib$st
```

```
## NULL
```

Only when you provide the entire column name, it will work.

```r
tib$str
```

```
## [1] "a" "b" "c" "d"
```

#### Data Frame
However, you can access the "str" column by only providing a partial column name "st" (as long as this partial name is unique).

```r
df <- data.frame(str = c("a","b","c","d"), int = c(1,2,3,4))
df$st
```

```
## [1] "a" "b" "c" "d"
```


### 5. When you access only one column of a tibble, it will keep the tibble structure. But when you access one column of a data frame, it will become a vector.
#### Tibble

```r
tib[,"str"]
```

```
## # A tibble: 4 × 1
##   str  
##   <chr>
## 1 a    
## 2 b    
## 3 c    
## 4 d
```
Checking if it's still a tibble:

```r
is_tibble(tib[,"str"])
```

```
## [1] TRUE
```
We can see the tibble structure is preserved.

#### Data Frame

```r
df[,"str"]
```

```
## [1] "a" "b" "c" "d"
```
Checking if it's still a data frame:

```r
is.data.frame(df[,"str"])
```

```
## [1] FALSE
```
It's no longer a data frame.


#### However, other forms of subsetting, including [[ ]] and $, work the same for tibbles and data frames.

```r
tib[["str"]]
```

```
## [1] "a" "b" "c" "d"
```

```r
df[["str"]]
```

```
## [1] "a" "b" "c" "d"
```

```r
tib$str
```

```
## [1] "a" "b" "c" "d"
```

```r
df$str
```

```
## [1] "a" "b" "c" "d"
```

We can see that subsetting with [[ ]] and $ also don't preserve the tibble structure.

### 6. When assigning a new column to a tibble, the input will not be recycled, which means you have to provide an input of the same length of the other columns. But a data frame will recycle the input.
#### Tibble

```r
tib
```

```
## # A tibble: 4 × 2
##   str     int
##   <chr> <dbl>
## 1 a         1
## 2 b         2
## 3 c         3
## 4 d         4
```

```r
tib$newcol <- c(5,6)
```

```
## Error:
## ! Assigned data `c(5, 6)` must be compatible with existing data.
## ✖ Existing data has 4 rows.
## ✖ Assigned data has 2 rows.
## ℹ Only vectors of size 1 are recycled.
```
It gives an error because the tibble has columns of length 4, but the input (5,6) only has length 2 and is not recycled. 
You have to provide an input of same length:

```r
tib$newcol <- rep(c(5,6),2)
tib
```

```
## # A tibble: 4 × 3
##   str     int newcol
##   <chr> <dbl>  <dbl>
## 1 a         1      5
## 2 b         2      6
## 3 c         3      5
## 4 d         4      6
```

#### Data Frame
Data frames will recycle the input.

```r
df
```

```
##   str int
## 1   a   1
## 2   b   2
## 3   c   3
## 4   d   4
```

```r
df$newcol <- c(5,6)
df
```

```
##   str int newcol
## 1   a   1      5
## 2   b   2      6
## 3   c   3      5
## 4   d   4      6
```


### 7. Reading with builtin read.csv() function will output data frames, while reading with read_csv() in "readr" package inside tidyverse will output tibbles.
#### Reading csv file with read.csv()

```r
data <- read.csv("https://people.sc.fsu.edu/~jburkardt/data/csv/addresses.csv")
class(data)
```

```
## [1] "data.frame"
```

#### Reading csv file with read_csv()

```r
data <- read_csv("https://people.sc.fsu.edu/~jburkardt/data/csv/addresses.csv")
class(data)
```

```
## [1] "spec_tbl_df" "tbl_df"      "tbl"         "data.frame"
```


### 8. Tibbles don't support support arithmetic operations on all columns well, the result will be converted into a data frame without any notice. 
#### Tibble
We can see that when we try to multiply all the elements of the tibble by 2, the result is correct but it is turned into a data frame without notifications.

```r
tib <- tibble(a = c(1,2,3), b = c(4,5,6), c = c(7,8,9))
class(tib*2)
```

```
## [1] "data.frame"
```

#### Data Frame
But data frames have no issue with it, they will not be converted into any other type.

```r
df <- data.frame(a = c(1,2,3), b = c(4,5,6), c = c(7,8,9))
class(df*2)
```

```
## [1] "data.frame"
```

### 9. Tibbles preserve all the variable types, while data frames have the option to convert string into factor. (In older versions of R, data frames will convert string into factor by default)
#### Tibble
We can see that the original data types of variables are preserved in a tibble.

```r
tib <- tibble(str = c("a","b","c","d"), int = c(1,2,3,4))
str(tib)
```

```
## tibble [4 × 2] (S3: tbl_df/tbl/data.frame)
##  $ str: chr [1:4] "a" "b" "c" "d"
##  $ int: num [1:4] 1 2 3 4
```

#### Data Frame
If we use data frame, it will also preserve the original types, because "stringAsFactors = FALSE" by default in the new versions of R.

```r
df <- data.frame(str = c("a","b","c","d"), int = c(1,2,3,4))
str(df)
```

```
## 'data.frame':	4 obs. of  2 variables:
##  $ str: chr  "a" "b" "c" "d"
##  $ int: num  1 2 3 4
```
However, we also have the option to convert string into factor when creating the data frame by setting "stringAsFactors = TRUE".

```r
df <- data.frame(str = c("a","b","c","d"), int = c(1,2,3,4), stringsAsFactors = TRUE)
class(df$str)
```

```
## [1] "factor"
```
We can see that the "str" column has been converted into factor.

### 10. Tibbles work well with ggplot2, just like data frames.
#### Tibble:

```r
ggplot(data = tib, mapping = aes(x=str, y=int)) +
  geom_col(width = 0.3)
```

<img src="tibble_vs_data_frame_files/figure-html/unnamed-chunk-27-1.png" width="672" style="display: block; margin: auto;" />

#### Data Frame:

```r
ggplot(data = df, mapping = aes(x=str, y=int)) +
  geom_col(width = 0.3)
```

<img src="tibble_vs_data_frame_files/figure-html/unnamed-chunk-28-1.png" width="672" style="display: block; margin: auto;" />

## Works Cited
https://tibble.tidyverse.org/  
https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html  
https://www.youtube.com/watch?v=_qHdqWx-vsQ&ab_channel=JoshuaFrench

