# Introduction to Data Manipulation

Yuhe Wang



```r
library(tidyverse)
library(fueleconomy)
library(tidyverse)
library(lubridate)
```

## Data Wrangling with dplyr

### Pipe:
Here we use %>% as pipeline. a %>% operation(...) == operation(a, ....)

### Tibble
Tibble is a type of data structure that is similar to data frame in base R.Compared to normal dataframee, tibble never changes the type of the input, or the names of the variables, or the row names.

```r
tibble(x=1:5, y=1,z=x^2+y)
```

```
## # A tibble: 5 × 3
##       x     y     z
##   <int> <dbl> <dbl>
## 1     1     1     2
## 2     2     1     5
## 3     3     1    10
## 4     4     1    17
## 5     5     1    26
```

### Pick observations with filter()
R provides standard suites: <, >=, <=, !=, ==, %in% for you to apply conditions on rows

```r
vehicles %>% filter(year>1999)
```

```
## # A tibble: 16,649 × 12
##       id make  model  year class       trans drive   cyl displ fuel    hwy   cty
##    <dbl> <chr> <chr> <dbl> <chr>       <chr> <chr> <dbl> <dbl> <chr> <dbl> <dbl>
##  1 16573 Acura 3.2CL  2001 Compact Ca… Auto… Fron…     6   3.2 Prem…    27    17
##  2 17489 Acura 3.2CL  2002 Compact Ca… Auto… Fron…     6   3.2 Prem…    27    17
##  3 18458 Acura 3.2CL  2003 Compact Ca… Manu… Fron…     6   3.2 Prem…    26    17
##  4 18459 Acura 3.2CL  2003 Compact Ca… Auto… Fron…     6   3.2 Prem…    27    17
##  5 15871 Acura 3.2TL  2000 Midsize Ca… Auto… Fron…     6   3.2 Prem…    27    17
##  6 16734 Acura 3.2TL  2001 Midsize Ca… Auto… Fron…     6   3.2 Prem…    27    17
##  7 17664 Acura 3.2TL  2002 Midsize Ca… Auto… Fron…     6   3.2 Prem…    27    17
##  8 18629 Acura 3.2TL  2003 Midsize Ca… Auto… Fron…     6   3.2 Prem…    27    17
##  9 15872 Acura 3.5RL  2000 Midsize Ca… Auto… Fron…     6   3.5 Prem…    22    16
## 10 16735 Acura 3.5RL  2001 Midsize Ca… Auto… Fron…     6   3.5 Prem…    22    16
## # … with 16,639 more rows
```
### Reorder rows with arrange()

```r
vehicles %>% arrange(year,class,trans)
```

```
## # A tibble: 33,442 × 12
##       id make      model    year class trans drive   cyl displ fuel    hwy   cty
##    <dbl> <chr>     <chr>   <dbl> <chr> <chr> <chr> <dbl> <dbl> <chr> <dbl> <dbl>
##  1 27049 Buick     Electr…  1984 Larg… Auto… 2-Wh…     6   4.1 Regu…    19    14
##  2 27050 Buick     Electr…  1984 Larg… Auto… 2-Wh…     8   5   Regu…    20    14
##  3 27051 Buick     Electr…  1984 Larg… Auto… 2-Wh…     8   5.7 Dies…    26    18
##  4 27057 Cadillac  Brough…  1984 Larg… Auto… Rear…     8   4.1 Regu…    19    14
##  5 27058 Cadillac  Brough…  1984 Larg… Auto… Rear…     8   5.7 Dies…    26    18
##  6 28105 Cadillac  Brough…  1984 Larg… Auto… Rear…     8   4.1 Regu…    19    14
##  7 28106 Cadillac  Fleetw…  1984 Larg… Auto… Rear…     6   4.3 Dies…    31    21
##  8 28225 Chevrolet S10 Pi…  1984 Smal… Auto… 2-Wh…     4   2   Regu…    24    18
##  9 27219 Dodge     Ram 50…  1984 Smal… Auto… 2-Wh…     4   2   Regu…    21    20
## 10 27220 Dodge     Ram 50…  1984 Smal… Auto… 2-Wh…     4   2   Regu…    20    18
## # … with 33,432 more rows
```
### Create new variables using mutate()

```r
vehicles %>% mutate(cyl_2 = cyl*2)
```

```
## # A tibble: 33,442 × 13
##       id make  model  year class trans drive   cyl displ fuel    hwy   cty cyl_2
##    <dbl> <chr> <chr> <dbl> <chr> <chr> <chr> <dbl> <dbl> <chr> <dbl> <dbl> <dbl>
##  1 13309 Acura 2.2C…  1997 Subc… Auto… Fron…     4   2.2 Regu…    26    20     8
##  2 13310 Acura 2.2C…  1997 Subc… Manu… Fron…     4   2.2 Regu…    28    22     8
##  3 13311 Acura 2.2C…  1997 Subc… Auto… Fron…     6   3   Regu…    26    18    12
##  4 14038 Acura 2.3C…  1998 Subc… Auto… Fron…     4   2.3 Regu…    27    19     8
##  5 14039 Acura 2.3C…  1998 Subc… Manu… Fron…     4   2.3 Regu…    29    21     8
##  6 14040 Acura 2.3C…  1998 Subc… Auto… Fron…     6   3   Regu…    26    17    12
##  7 14834 Acura 2.3C…  1999 Subc… Auto… Fron…     4   2.3 Regu…    27    20     8
##  8 14835 Acura 2.3C…  1999 Subc… Manu… Fron…     4   2.3 Regu…    29    21     8
##  9 14836 Acura 2.3C…  1999 Subc… Auto… Fron…     6   3   Regu…    26    17    12
## 10 11789 Acura 2.5TL  1995 Comp… Auto… Fron…     5   2.5 Prem…    23    18    10
## # … with 33,432 more rows
```

### Create new calculations by catgories using summarize()
We can use summarize to get some statistics for different groups. In the following example, we are getting average of difference between air time and scheduled air time, grouped by different carriers. Note that we have to add "na.rm" inside a functio to remove NA, else we will see a lot of NAs. \
Common operation functions:\
sd(x): standard deviation \
mean(x): mean \
IQR(x): interquartile range \
mad(x): median absolute deviation\
min(x): min\
quantile(x, 0.5): ith quartile\
max(x): max\
first(x): the first row \
nth(x,1): the nth row\
last(): the last row\
n(): count \
n_distinct(x): count distinct \
sum(): sum\

```r
vehicles %>% group_by(class, fuel) %>% summarize(mean_cty =mean(cty, na.rm = TRUE))
```

```
## # A tibble: 151 × 3
## # Groups:   class [34]
##    class        fuel                       mean_cty
##    <chr>        <chr>                         <dbl>
##  1 Compact Cars CNG                            24.5
##  2 Compact Cars Diesel                         29.2
##  3 Compact Cars Electricity                   110  
##  4 Compact Cars Gasoline or E85                21.9
##  5 Compact Cars Midgrade                       16  
##  6 Compact Cars Premium                        17.6
##  7 Compact Cars Premium Gas or Electricity     35  
##  8 Compact Cars Premium or E85                 17.2
##  9 Compact Cars Regular                        21.1
## 10 Large Cars   CNG                            13.6
## # … with 141 more rows
```
## Tidy Data with dplyr

### Gather/Spread
We can reshape table from wide format into long format using Gather. We can reshape table from wide format into long format using Sprea vice versa. (The following example is untrue data)

```r
t1 <- tibble(country=c('China', 'US', 'Korea'), `1999` = c(123,323,4245),`2000` = c(12,32,424))
t1
```

```
## # A tibble: 3 × 3
##   country `1999` `2000`
##   <chr>    <dbl>  <dbl>
## 1 China      123     12
## 2 US         323     32
## 3 Korea     4245    424
```

```r
t1 %>% gather(`1999`, `2000`,key='year',value = 'GDP')
```

```
## # A tibble: 6 × 3
##   country year    GDP
##   <chr>   <chr> <dbl>
## 1 China   1999    123
## 2 US      1999    323
## 3 Korea   1999   4245
## 4 China   2000     12
## 5 US      2000     32
## 6 Korea   2000    424
```

### Seperate/Unite 
We can combine/separate values in one column into two, or two into one(using some special characters). We can add a parameter of "convert=TRUE" to convert chars to integer directly.

```r
t2 <- tibble(country=c('China', 'US', 'Korea'), rate=c('12/232','123/20384','2328/2301823'))
t2 %>% separate(rate,into=c("numerator", "denominator"),convert=TRUE)
```

```
## # A tibble: 3 × 3
##   country numerator denominator
##   <chr>       <int>       <int>
## 1 China          12         232
## 2 US            123       20384
## 3 Korea        2328     2301823
```
## Relational Data with dplyr

### prerequisites
KEYS in DBMS is an attribute or set of attributes which helps you to identify a row or a relation. A primary key uniquely identifies an observation. A foreign key uniquely identify an observation in another table. Join between two table usually takes place between two keys within different tables to ensure single join. 

### Understanding different types of joins
x () y
inner join: only return the matching pairs existing in both tables
left join: only keep all observations in x
right join: only keep all observations in y 
full join:keep all observations in x and y
Note that only one of the tables can have duplicate keys. If both of the tables have duplicate keys, this will cause error. Usually, having duplicate key in one table can produce unexpected result. So, the best practice is to investigate both tables firstly before joining.

```r
# These data are frictional 
x <- tibble(Country = c('China','US','Japan','Canada'), population=c(100,200,300,400))
y <- tibble(Country = c('China','US','Japan','Mexico'), GDP=c(100,23,2142,234))
```


```r
left_join(x, y, by='Country')
```

```
## # A tibble: 4 × 3
##   Country population   GDP
##   <chr>        <dbl> <dbl>
## 1 China          100   100
## 2 US             200    23
## 3 Japan          300  2142
## 4 Canada         400    NA
```


```r
right_join(x, y, by='Country')
```

```
## # A tibble: 4 × 3
##   Country population   GDP
##   <chr>        <dbl> <dbl>
## 1 China          100   100
## 2 US             200    23
## 3 Japan          300  2142
## 4 Mexico          NA   234
```


```r
inner_join(x, y, by='Country')
```

```
## # A tibble: 3 × 3
##   Country population   GDP
##   <chr>        <dbl> <dbl>
## 1 China          100   100
## 2 US             200    23
## 3 Japan          300  2142
```


```r
full_join(x, y, by='Country')
```

```
## # A tibble: 5 × 3
##   Country population   GDP
##   <chr>        <dbl> <dbl>
## 1 China          100   100
## 2 US             200    23
## 3 Japan          300  2142
## 4 Canada         400    NA
## 5 Mexico          NA   234
```
In the case that two tables have different names of their keys, we can use by=c("a"="b")

## Datetime with Lubridate

```r
library(tidyverse)
library(lubridate)
```
### Datetime from strings
Lubridate is able to parse different format of datetime strings

```r
ymd('2020-01-01')
```

```
## [1] "2020-01-01"
```

```r
mdy('March 1 2021')
```

```
## [1] "2021-03-01"
```

```r
dmy('02/01/2020')
```

```
## [1] "2020-01-02"
```

Getting components from datetime

```r
t <- ymd_hms('2020-01-01 12:00:00')
year(t)
```

```
## [1] 2020
```

```r
month(t)
```

```
## [1] 1
```

```r
# day of the month
mday(t)
```

```
## [1] 1
```

```r
# day of the year
yday(t)
```

```
## [1] 1
```

```r
# day of the week
wday(t)
```

```
## [1] 4
```

```r
hour(t)
```

```
## [1] 12
```

```r
minute(t)
```

```
## [1] 0
```

```r
second(t)
```

```
## [1] 0
```

### Timespan
Duration: exact number of seconds\
Periods: human units (week and months)\
Intervals: starting and ending point\

Duration

```r
dminutes(10)
```

```
## [1] "600s (~10 minutes)"
```

```r
dweeks(3)
```

```
## [1] "1814400s (~3 weeks)"
```

```r
dyears(1)
```

```
## [1] "31557600s (~1 years)"
```

Periods

```r
seconds(15)
```

```
## [1] "15S"
```

```r
days(7)
```

```
## [1] "7d 0H 0M 0S"
```

```r
months(1:6)
```

```
## [1] "1m 0d 0H 0M 0S" "2m 0d 0H 0M 0S" "3m 0d 0H 0M 0S" "4m 0d 0H 0M 0S"
## [5] "5m 0d 0H 0M 0S" "6m 0d 0H 0M 0S"
```


```r
years(1)/days(1)
```

```
## [1] 365.25
```

```r
today() + years(1)
```

```
## [1] "2023-01-28"
```

## String manipulations with stringr

### Matching Patterns 
We can do regular expression matching in R easily too.
string_view() is a very useful function that showcase string patterns. The first input will be input variable, the second input will be the string that we are trying to match. The following regular expression matches will be introduced using this method. \

We can match a substring directly easily. 

```r
a <-c('root', 'create','time','death')
str_view(a, "ea")
```

```{=html}
<div id="htmlwidget-62bb33c7819d06cfc942" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-62bb33c7819d06cfc942">{"x":{"html":"<ul>\n  <li>root<\/li>\n  <li>cr<span class='match'>ea<\/span>te<\/li>\n  <li>time<\/li>\n  <li>d<span class='match'>ea<\/span>th<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
```
We can use '.' as a wildcard to match any character

```r
a <-c('root', 'create','time','death')
str_view(a, "im.")
```

```{=html}
<div id="htmlwidget-dc561d590e4131297e1d" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-dc561d590e4131297e1d">{"x":{"html":"<ul>\n  <li>root<\/li>\n  <li>create<\/li>\n  <li>t<span class='match'>ime<\/span><\/li>\n  <li>death<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
```
We can use '^a' to match any string starting with an "a", and "a\$" to find any string that ending with "a". We can also use '^' at the beginning and "$" in the end to make sure that it's an exact match. 

```r
a <-c('root', 'create','time','death','eath')
str_view(a, "^c")
```

```{=html}
<div id="htmlwidget-6d67ce7f51b83daef174" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-6d67ce7f51b83daef174">{"x":{"html":"<ul>\n  <li>root<\/li>\n  <li><span class='match'>c<\/span>reate<\/li>\n  <li>time<\/li>\n  <li>death<\/li>\n  <li>eath<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
```

```r
str_view(a, "^death$")
```

```{=html}
<div id="htmlwidget-69020130bb1c8c33e0a9" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-69020130bb1c8c33e0a9">{"x":{"html":"<ul>\n  <li>root<\/li>\n  <li>create<\/li>\n  <li>time<\/li>\n  <li><span class='match'>death<\/span><\/li>\n  <li>eath<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
```

```r
str_view(a, "e$")
```

```{=html}
<div id="htmlwidget-686dfb7be7b5ef8e578e" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-686dfb7be7b5ef8e578e">{"x":{"html":"<ul>\n  <li>root<\/li>\n  <li>creat<span class='match'>e<\/span><\/li>\n  <li>tim<span class='match'>e<\/span><\/li>\n  <li>death<\/li>\n  <li>eath<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
```
We can also specify how many times a character repeats itself. {n} represents we have exactly n times of repetition,{n,}: n or more, {,n}: at most n, {n,m}: between n and m

```r
a <-'CCccoljenlq'
str_view(a, 'C{2}')
```

```{=html}
<div id="htmlwidget-16b3c96e89c1096a2a22" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-16b3c96e89c1096a2a22">{"x":{"html":"<ul>\n  <li><span class='match'>CC<\/span>ccoljenlq<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
```

There are also extra type of strings we can match other than characters we mentioned. '\\d' matches any digit,'\\s' matches any white space, [xyz] matches x, y or z, [^xyz] matches anything other than x, y and z. Here noticing that because we want to match a substring starting with one backlash, we have to specify two backlashes in the string matching.

```r
a <- 'xeqowhe22'
str_view(a, '\\d{2}')
```

```{=html}
<div id="htmlwidget-f9fee6f0db90aa7a3282" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-f9fee6f0db90aa7a3282">{"x":{"html":"<ul>\n  <li>xeqowhe<span class='match'>22<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
```

```r
str_view(a, '[xyz]')
```

```{=html}
<div id="htmlwidget-21dff4500fa3067232ba" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-21dff4500fa3067232ba">{"x":{"html":"<ul>\n  <li><span class='match'>x<\/span>eqowhe22<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
```
Then we will introduce a couple of methods that are useful in conjunction to use with these regular expression.\
1.str_detect(): to see if we detect certain substring, return TRUE or FALSE\
2.str_extract(): to extract the actual substring from the string\
3.str_subset(): return a group of strings that matches certain pattern\
4.str_count(): count the number of substring appearances in a string\
5.str_replace(): replace substrings with certain patterns\
6.str_split(): split string according to patterns\

```r
str_detect(c('case','happy','sad'), '[ey]$')
```

```
## [1]  TRUE  TRUE FALSE
```


```r
str_extract_all(c('case','happy','sad'), '[ey]$')
```

```
## [[1]]
## [1] "e"
## 
## [[2]]
## [1] "y"
## 
## [[3]]
## character(0)
```


```r
str_subset(c('case','happy','sad'), '[ey]$')
```

```
## [1] "case"  "happy"
```

```r
a <- 'laaalk3kr23'
str_count(a,'[al]{3}')
```

```
## [1] 1
```

```r
a <- 'laaalk3kr23'
str_replace(a,'[al]{3}','happy')
```

```
## [1] "happyalk3kr23"
```

```r
str_split('abc def',' ')
```

```
## [[1]]
## [1] "abc" "def"
```


Source: R for Data Science
