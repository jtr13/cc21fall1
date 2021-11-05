# R cheatsheet on data transforamtion and exploration

Sai Krupa Jangala



Few Pointers:

* The purpose of this cheatsheet is to describe all the basic data operations that we do when we start a new project. This also includes different types of data transformations, explorations and management.
* We use only data frames throughtout the cheatsheet.
* We use packages that are most commonly used in R. We will be using these packages for different purposes. 
* Different datasets are used to best illustrate the transformation, management and exploration.
* The data sets used are ```openintro::fastfood``` , ```openintro::seatlepets```, ```cars```, ```openintro::ames``` and ```mtcars```.
* Every chunk of code loads its own data, if it's not, it means that we have used the data from the previous chunk.

#### Required packages
These packages are most commonly in R and are used in the following cheatsheet. We will be using these packages for different purposes. 

```r
#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("reshape")
library(dplyr)
library(tidyverse)
library(reshape)
```

#### Output the head, tail and sample of the dataframe.
Head - will get the first 5 rows of the dataframe.

```r
data <- cars
head(data, n=5)
```

```
##   speed dist
## 1     4    2
## 2     4   10
## 3     7    4
## 4     7   22
## 5     8   16
```
Tail - will get the last 5 rows of the dataframe

```r
tail(data, n=5)
```

```
##    speed dist
## 46    24   70
## 47    24   92
## 48    24   93
## 49    24  120
## 50    25   85
```

#### Selection of only a few columns from a dataframe.
Select only restaurant, item and calorie columns from the fastfood dataset. Two variations are shown below.

```r
data <- openintro::fastfood
# Variation 1
data <- data[, c("restaurant","item","calories")]
# Variation 2
data_1 <- select(data, c(restaurant, item, calories))
```

As we can see below, both the transformations produce the same result.

```r
head(data)
```

```
## # A tibble: 6 × 3
##   restaurant item                                      calories
##   <chr>      <chr>                                        <dbl>
## 1 Mcdonalds  Artisan Grilled Chicken Sandwich               380
## 2 Mcdonalds  Single Bacon Smokehouse Burger                 840
## 3 Mcdonalds  Double Bacon Smokehouse Burger                1130
## 4 Mcdonalds  Grilled Bacon Smokehouse Chicken Sandwich      750
## 5 Mcdonalds  Crispy Bacon Smokehouse Chicken Sandwich       920
## 6 Mcdonalds  Big Mac                                        540
```

```r
head(data_1)
```

```
## # A tibble: 6 × 3
##   restaurant item                                      calories
##   <chr>      <chr>                                        <dbl>
## 1 Mcdonalds  Artisan Grilled Chicken Sandwich               380
## 2 Mcdonalds  Single Bacon Smokehouse Burger                 840
## 3 Mcdonalds  Double Bacon Smokehouse Burger                1130
## 4 Mcdonalds  Grilled Bacon Smokehouse Chicken Sandwich      750
## 5 Mcdonalds  Crispy Bacon Smokehouse Chicken Sandwich       920
## 6 Mcdonalds  Big Mac                                        540
```
#### Get the column names
Generate all the column names in the data frame

```r
data <- openintro::fastfood
names(data)
```

```
##  [1] "restaurant"  "item"        "calories"    "cal_fat"     "total_fat"  
##  [6] "sat_fat"     "trans_fat"   "cholesterol" "sodium"      "total_carb" 
## [11] "fiber"       "sugar"       "protein"     "vit_a"       "vit_c"      
## [16] "calcium"     "salad"
```

#### Drop one or more columns.
Drop columns ```restaurant```, ```item```, ```calories``` from the data. As we can observe, the above column names have been dropped.

```r
data <- openintro::fastfood
data <- select(data, -c(restaurant, item, calories))
names(data)
```

```
##  [1] "cal_fat"     "total_fat"   "sat_fat"     "trans_fat"   "cholesterol"
##  [6] "sodium"      "total_carb"  "fiber"       "sugar"       "protein"    
## [11] "vit_a"       "vit_c"       "calcium"     "salad"
```

#### Transformation using the transform() function in R

Here we are creating a new dataframe by changing the speed column. We transformed it by multiplying with 100

```r
data <- cars
data_1 <- transform(data, speed=speed*100)
head(data_1)
```

```
##   speed dist
## 1   400    2
## 2   400   10
## 3   700    4
## 4   700   22
## 5   800   16
## 6   900   10
```
Here we transformed the original dataframe by creating a new column.

```r
data <- transform(data, time=speed*dist)
head(data)
```

```
##   speed dist time
## 1     4    2    8
## 2     4   10   40
## 3     7    4   28
## 4     7   22  154
## 5     8   16  128
## 6     9   10   90
```
#### Conditional Transformation in R

Transformation based on a condition.  Here we are creating a new column called Grilled, which is assigned to Grilled if the item contains Grilled in it's name else it is classified as Not Grilled.

```r
#Check if it contains the word grilled.
data <- openintro::fastfood
data <- transform(data, Grilled=ifelse(str_detect(item, "Grilled"), "Grilled", "Not Grilled"))
head(data[,c("item","Grilled")])
```

```
##                                        item     Grilled
## 1          Artisan Grilled Chicken Sandwich     Grilled
## 2            Single Bacon Smokehouse Burger Not Grilled
## 3            Double Bacon Smokehouse Burger Not Grilled
## 4 Grilled Bacon Smokehouse Chicken Sandwich     Grilled
## 5  Crispy Bacon Smokehouse Chicken Sandwich Not Grilled
## 6                                   Big Mac Not Grilled
```
#### Add a new column to the dataframe without ```transform()``` function.

Here we added a new column called time.

```r
data <- cars
data$time <- data$speed * data$dist
head(data)
```

```
##   speed dist time
## 1     4    2    8
## 2     4   10   40
## 3     7    4   28
## 4     7   22  154
## 5     8   16  128
## 6     9   10   90
```

#### Get all the unique values of a column in a dataframe.

```r
data <- openintro::fastfood
unique(data$restaurant)
```

```
## [1] "Mcdonalds"   "Chick Fil-A" "Sonic"       "Arbys"       "Burger King"
## [6] "Dairy Queen" "Subway"      "Taco Bell"
```

#### Using the filter function in R. Different logical operators can be used to filter the data.

Filter all the rows where mpg column value is 21.0

```r
data <- mtcars
data_filtered <- filter(data, mpg==21.0)
unique(data_filtered$mpg)
```

```
## [1] 21
```

Filter all the rows where mpg column value is less than 21.0

```r
data_filtered_1 <- filter(data, mpg<21.0)
unique(data_filtered_1$mpg)
```

```
##  [1] 18.7 18.1 14.3 19.2 17.8 16.4 17.3 15.2 10.4 14.7 15.5 13.3 15.8 19.7 15.0
```
Filter all the rows where mpg column value is greater than 21.0

```r
data_filtered_2 <- filter(data, mpg>21.0)
unique(data_filtered_2$mpg)
```

```
## [1] 22.8 21.4 24.4 32.4 30.4 33.9 21.5 27.3 26.0
```
Filter all the rows where cyl column is 4 and carb column is greater than 1.

```r
data_filtered_logical <- filter(data, cyl == 4 & carb > 1)
unique(data_filtered_logical$mpg)
```

```
## [1] 24.4 22.8 30.4 26.0 21.4
```

#### Select only few rows in a column based on a condition without using the ```filter()``` function.

Here we are selecting only those rows where the restuarant name is subway

```r
data <- openintro::fastfood
# Select the rows where the item contains the word "Grilled
data <- data[data$restaurant == "Subway", ] 
unique(data$restaurant)
```

```
## [1] "Subway"
```

#### Merge two dataframes

Merging two dataframes based on column names. Authors dataframe and books dataframe have been merged by surname and name.


```r
authors <- data.frame(
    surname = c("Tukey", "Venables", "Tierney", "Ripley", "McNeil"),
    nationality = c("US", "Australia", "US", "UK", "Australia"),
    retired = c("yes", rep("no", 4)))
books <- data.frame(
    name = c("Tukey", "Venables", "Tierney", "Ripley", "Ripley", "McNeil"),
    title = c("Exploratory Data Analysis",
              "Probability and Statistics",
              "Finance and Structuring for Data Science",
              "Algorithms for Data Science",
               "Interactive Data Analysis",
              "Deep Learning"))
    #other.author = c(NA, "Ripley", NA, NA, NA, NA))
merged <- merge(authors, books, by.x="surname", by.y="name")
head(merged)
```

```
##    surname nationality retired                                    title
## 1   McNeil   Australia      no                            Deep Learning
## 2   Ripley          UK      no              Algorithms for Data Science
## 3   Ripley          UK      no                Interactive Data Analysis
## 4  Tierney          US      no Finance and Structuring for Data Science
## 5    Tukey          US     yes                Exploratory Data Analysis
## 6 Venables   Australia      no               Probability and Statistics
```


#### Arrange the data in ascending order based on a column

```r
data <- openintro::fastfood
# Arranging the data in ascending order
data <- data[order(data$total_fat),] 
head(data[, c("restaurant","total_fat")])
```

```
## # A tibble: 6 × 2
##   restaurant  total_fat
##   <chr>           <dbl>
## 1 Dairy Queen         0
## 2 Subway              1
## 3 Chick Fil-A         2
## 4 Dairy Queen         2
## 5 Subway              2
## 6 Subway              2
```

#### Arrange the data in descending order based on a column

```r
# Arranging the data in descending order
data <- data[order(data$total_fat, decreasing = TRUE),]
head(data[, c("restaurant","total_fat")])
```

```
## # A tibble: 6 × 2
##   restaurant  total_fat
##   <chr>           <dbl>
## 1 Mcdonalds         141
## 2 Burger King       126
## 3 Mcdonalds         107
## 4 Sonic             100
## 5 Sonic              92
## 6 Mcdonalds          88
```

#### Get the summary of a column -> mean, median, var, SD etc

This function gives us the Minimum value, 1st Quartile value, Median, Mean, 3rd Quartile value, Maximum value from a column in a data frame. 

```r
summary(data$total_fat)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    0.00   14.00   23.00   26.59   35.00  141.00
```

#### Convert all the values in the column to upper case.


```r
data$item <- tolower(data$item)
head(data$item)
```

```
## [1] "20 piece buttermilk crispy chicken tenders"      
## [2] "american brewhouse king"                         
## [3] "40 piece chicken mcnuggets"                      
## [4] "garlic parmesan dunked ultimate chicken sandwich"
## [5] "super sonic bacon double cheeseburger (w/mayo)"  
## [6] "12 piece buttermilk crispy chicken tenders"
```

#### Convert all the values in the column to lower case.

```r
data$item <- toupper(data$item)
head(data$item)
```

```
## [1] "20 PIECE BUTTERMILK CRISPY CHICKEN TENDERS"      
## [2] "AMERICAN BREWHOUSE KING"                         
## [3] "40 PIECE CHICKEN MCNUGGETS"                      
## [4] "GARLIC PARMESAN DUNKED ULTIMATE CHICKEN SANDWICH"
## [5] "SUPER SONIC BACON DOUBLE CHEESEBURGER (W/MAYO)"  
## [6] "12 PIECE BUTTERMILK CRISPY CHICKEN TENDERS"
```

#### Dropping NAs

Dropping out all the rows with one or more columns as NA

```r
data <- openintro::seattlepets
data <- data[complete.cases(data), ]
# Removes the rows with one or more columns having a NA
```


#### groupby( ) and summarize( ) functions usage 
We use ames data to demonstrate these functions. If we want to find the minimum, maximum area of all the houses in a particular neighborhood, we group by on the Neighborhood and compute the minimum and maximum area columns using the summarise function.

```r
data <- openintro::ames
data <- data %>% group_by(Neighborhood) %>% summarise(max_area= max(area), min_area=min(area))
head(data, n=10)
```

```
## # A tibble: 10 × 3
##    Neighborhood max_area min_area
##    <fct>           <int>    <int>
##  1 Blmngtn          1589     1142
##  2 Blueste          1556     1020
##  3 BrDale           1365      948
##  4 BrkSide          2134      334
##  5 ClearCr          3086      988
##  6 CollgCr          2828      768
##  7 Crawfor          3447      694
##  8 Edwards          5642      498
##  9 Gilbert          2462      864
## 10 Greens           1295      788
```

#### Get the shape of the dataframe in R.

To know the number of rows and columns in a dataframe.

```r
data <- openintro::ames
dim(data)
```

```
## [1] 2930   82
```
First number in the list is the number of rows and the second number in the list is the number of columns in the dataframe


#### Select only top 30 rows or 90 rows, bottom 30 rows

```r
data <- openintro::ames
# Selecting the top 30 rows
data <- data[1:30,]
# Selecting the top 90 rows
data <- data[1:90,]
data <- openintro::ames
data <- data[2900:2930,] 
# Select the last 30 rows if your dataframe consists of 2930 rows
```

#### Get the data type of each column in a dataframe.

```r
data <- openintro::seattlepets
map(data, class)
```

```
## $license_issue_date
## [1] "Date"
## 
## $license_number
## [1] "character"
## 
## $animal_name
## [1] "character"
## 
## $species
## [1] "character"
## 
## $primary_breed
## [1] "character"
## 
## $secondary_breed
## [1] "character"
## 
## $zip_code
## [1] "character"
```

#### Changing the type of data -> int to char

Change the values in the column from character to integer for all valid values.

Note: Few rows may be marked as NA because of coercion.

```r
data <- openintro::seattlepets
head(data$zip_code)
```

```
## [1] "98108" "98117" "98136" "98117" "98144" "98103"
```

```r
data$zip_code <- as.numeric(data$zip_code)
head(data$zip_code)
```

```
## [1] 98108 98117 98136 98117 98144 98103
```

#### Rename column names in R

Here we are renaming column name zip_code to zip_code_modified

```r
names(data)[names(data) == 'zip_code'] <- 'zip_code_modified'
names(data)
```

```
## [1] "license_issue_date" "license_number"     "animal_name"       
## [4] "species"            "primary_breed"      "secondary_breed"   
## [7] "zip_code_modified"
```

```r
# Zip code has been modified to zip_code_modified
```

#### Find minimum and maximum values in a column in R

```r
data <- openintro::ames
min <- min(data$area)
max <- max(data$area)
```
Minimum value of area column

```r
min
```

```
## [1] 334
```
Maximum value of area column

```r
max
```

```
## [1] 5642
```

#### Number of unique values in every column in the data frame
In this dataset, we have 13930 unique animal names, 4 different species etc.

```r
data <- openintro::seattlepets
data %>% summarize_all(n_distinct)
```

```
## # A tibble: 1 × 7
##   license_issue_date license_number animal_name species primary_breed
##                <int>          <int>       <int>   <int>         <int>
## 1               1064          52497       13930       4           336
## # … with 2 more variables: secondary_breed <int>, zip_code <int>
```

#### Reorder columns in R by column name.

```r
authors <- data.frame(
    surname = c("Tukey", "Venables", "Tierney", "Ripley", "McNeil"),
    nationality = c("US", "Australia", "US", "UK", "Australia"),
    retired = c("yes", rep("no", 4)))
authors
```

```
##    surname nationality retired
## 1    Tukey          US     yes
## 2 Venables   Australia      no
## 3  Tierney          US      no
## 4   Ripley          UK      no
## 5   McNeil   Australia      no
```

```r
#reorder by column name
authors <- authors[, c("retired", "nationality", "surname")]
authors
```

```
##   retired nationality  surname
## 1     yes          US    Tukey
## 2      no   Australia Venables
## 3      no          US  Tierney
## 4      no          UK   Ripley
## 5      no   Australia   McNeil
```

#### Reorder columns by column index.

```r
authors <- authors[, c(1,3,2)]
authors
```

```
##   retired  surname nationality
## 1     yes    Tukey          US
## 2      no Venables   Australia
## 3      no  Tierney          US
## 4      no   Ripley          UK
## 5      no   McNeil   Australia
```

#### Remove Duplicates from the dataframe based on one column or multiple columns.


```r
# Remove the duplicate rows based on one variable
data <- mtcars
# Have the rows with distinct carb
data_one_var <- distinct(data, carb, .keep_all= TRUE)
# Keep the distinct data based on multiple variables
data_multi <- distinct(data, cyl, vs, .keep_all= TRUE)
```

#### Calculate Mean, Median of a column in the Data Frame

```r
mean <- mean(data$carb)
median <- median(data$carb)
```
Mean

```r
mean
```

```
## [1] 2.8125
```
Median

```r
median
```

```
## [1] 2
```


#### Value counts in R. Check how many times a unique variable occurs in like Male - 5, Female -10 in the column name Gender.

Number of rows where cyl = 4 is 11, cyl=6 is 7 etc

```r
data %>% count(cyl)
```

```
##   cyl  n
## 1   4 11
## 2   6  7
## 3   8 14
```

Number of rows where carb = 4 is 10, carb=6 is 1 etc

```r
data %>% count(carb)
```

```
##   carb  n
## 1    1  7
## 2    2 10
## 3    3  3
## 4    4 10
## 5    6  1
## 6    8  1
```

#### Convert the index column to a new column

Here we created a new column using the index of the dataframe.

```r
data <- cbind(car_name = rownames(data), data)
head(data)
```

```
##                            car_name  mpg cyl disp  hp drat    wt  qsec vs am
## Mazda RX4                 Mazda RX4 21.0   6  160 110 3.90 2.620 16.46  0  1
## Mazda RX4 Wag         Mazda RX4 Wag 21.0   6  160 110 3.90 2.875 17.02  0  1
## Datsun 710               Datsun 710 22.8   4  108  93 3.85 2.320 18.61  1  1
## Hornet 4 Drive       Hornet 4 Drive 21.4   6  258 110 3.08 3.215 19.44  1  0
## Hornet Sportabout Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0
## Valiant                     Valiant 18.1   6  225 105 2.76 3.460 20.22  1  0
##                   gear carb
## Mazda RX4            4    4
## Mazda RX4 Wag        4    4
## Datsun 710           4    1
## Hornet 4 Drive       3    1
## Hornet Sportabout    3    2
## Valiant              3    1
```

#### Add a new row to the dataframe
We can new rows to the dataframe by using ```rbind```

```r
new_row_to_add <- data.frame("Volvo 125",22.5,3,120.2,108,2.23,2.89,19.08,1,0,4,3)
names(new_row_to_add) <- c("car_name", "mpg", "cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb")
data <- rbind(data,new_row_to_add)
tail(data)
```

```
##                      car_name  mpg cyl  disp  hp drat    wt  qsec vs am gear
## Lotus Europa     Lotus Europa 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5
## Ford Pantera L Ford Pantera L 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5
## Ferrari Dino     Ferrari Dino 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5
## Maserati Bora   Maserati Bora 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5
## Volvo 142E         Volvo 142E 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4
## 1                   Volvo 125 22.5   3 120.2 108 2.23 2.890 19.08  1  0    4
##                carb
## Lotus Europa      2
## Ford Pantera L    4
## Ferrari Dino      6
## Maserati Bora     8
## Volvo 142E        2
## 1                 3
```

#### Log,Square root, Cube root transformation in R

```r
data <- cars
# Taking the log of the speed column
data$log_transformation <- log10(data$speed)
# Taking the square root of the speed column
data$sqrt_transformation <- sqrt(data$speed)
# Taking the cube root of the speed column
data$cube_transformation <-(data$speed)^1/3
head(data)
```

```
##   speed dist log_transformation sqrt_transformation cube_transformation
## 1     4    2          0.6020600            2.000000            1.333333
## 2     4   10          0.6020600            2.000000            1.333333
## 3     7    4          0.8450980            2.645751            2.333333
## 4     7   22          0.8450980            2.645751            2.333333
## 5     8   16          0.9030900            2.828427            2.666667
## 6     9   10          0.9542425            3.000000            3.000000
```

#### Changing the dataframe dimensions from wide to long
Here are the following types on how we can use the ```melt()``` function in R.

Type 1:
Here we create two columns called variable - which represent the subject and value which represents the grade in that subject.

```r
df_wide <- data.frame(
  student = c("Krupa", "Goutham", "Sailaja", "Murthy"),
  school = c("St. Joseph's", "Timpany", "St.Joseph's", "Timpany"),
  exploratory_data_analysis = c(10, 100, 1000, 10000),  # eng grades
  probability_and_statistics = c(20, 200, 2000, 20000),  # math grades
  algorithms_for_ds = c(30, 300, 3000, 30000)   # physics grades
)
df_long <- melt(data = df_wide, 
                id.vars = c("student", "school"))
df_long
```

```
##    student       school                   variable value
## 1    Krupa St. Joseph's  exploratory_data_analysis    10
## 2  Goutham      Timpany  exploratory_data_analysis   100
## 3  Sailaja  St.Joseph's  exploratory_data_analysis  1000
## 4   Murthy      Timpany  exploratory_data_analysis 10000
## 5    Krupa St. Joseph's probability_and_statistics    20
## 6  Goutham      Timpany probability_and_statistics   200
## 7  Sailaja  St.Joseph's probability_and_statistics  2000
## 8   Murthy      Timpany probability_and_statistics 20000
## 9    Krupa St. Joseph's          algorithms_for_ds    30
## 10 Goutham      Timpany          algorithms_for_ds   300
## 11 Sailaja  St.Joseph's          algorithms_for_ds  3000
## 12  Murthy      Timpany          algorithms_for_ds 30000
```
Type 2:
Here if we are interested in the grade of only english and math, we can pass it in the measure.vars parameter.

```r
df_long <- melt(data = df_wide, 
                id.vars = "student",
                measure.vars = c("exploratory_data_analysis", "algorithms_for_ds"))
df_long
```

```
##   student                  variable value
## 1   Krupa exploratory_data_analysis    10
## 2 Goutham exploratory_data_analysis   100
## 3 Sailaja exploratory_data_analysis  1000
## 4  Murthy exploratory_data_analysis 10000
## 5   Krupa         algorithms_for_ds    30
## 6 Goutham         algorithms_for_ds   300
## 7 Sailaja         algorithms_for_ds  3000
## 8  Murthy         algorithms_for_ds 30000
```


#### Replace NA with a specific value
Here we are replacing NA with None.

```r
data <- openintro::seattlepets
data[is.na(data)] <- "None"
```


References:
* https://towardsdatascience.com/data-cleaning-in-r-made-simple-1b77303b0b17
* https://towardsdatascience.com/data-transformation-in-r-288e95438ff9
* https://bookdown.org/aschmi11/RESMHandbook/data-preparation-and-cleaning-in-r.html

