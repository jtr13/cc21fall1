# Parallel coordinates plot cheatsheet

Andrew Schaefer


This cheatsheet goes over different options and coding techniques for displaying parallel coordinate plots.

## Libraries: GGally, ggparallel, and parcoords

In general, GGally is used for continuous data while ggparallel is useful for discrete data. We'll start with some beginning examples below. parcoords introduces interactive parallel coordinate plots, which will be explained further below. First, import the libraries


```r
library(GGally)
library(ggparallel)
library(parcoords)
library(ggplot2)
```

## Package: GGally
## Method: ggparcoord

As discussed in class, ggparcoord is usually your go-to for parallel coordinate plots. Once the dataset is loaded, you can pass it directly into the method and indicate which columns to show.


```r
data(mtcars)
head(mtcars)
```

```
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

```r
ggparcoord(mtcars)
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-2-1.png" width="672" style="display: block; margin: auto;" />

### Parameters

Not a very interesting graph right? Let's slowly add on some useful parameters. Columns can either be a range of column numbers (2:4) or a vector as shown below. groupColumn is for coloring data from a single column (the input will take a column value as a numerical, or the name of the column as a string). If the data is continuous, a gradient will be used.

```r
ggparcoord(mtcars, columns = c(1:6,9,10), groupColumn = 2)
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-3-1.png" width="672" style="display: block; margin: auto;" />
\
\
splineFactors curves the lines, which may make trends more visible depending on the data. alphaLines will make the lines transparent, which is prticularly useful for large datasets. It also prevents the colors of different lines from overlapping each other. These parameters will help with visualizing the data.


```r
ggparcoord(mtcars, columns = c(1:6,9,10), groupColumn = 2, splineFactor = 10, alphaLines=0.6)
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-4-1.png" width="672" style="display: block; margin: auto;" />

### Grouping by features

Discrete data will have their own categorical colors, much like a legend. However discrete data does not fit very well with the rest of the data (see that the scaling is off below). It will be difficult to discern trends between variables.



```r
mtcars$cyl <- as.character(mtcars$cyl)
ggparcoord(mtcars, columns = c(1:6,9,10), groupColumn = 2, splineFactor = 10, alphaLines=0.6)
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-5-1.png" width="672" style="display: block; margin: auto;" />

\
\
Luckily we have the option to exclude the discrete data in the column vector (while still using it to group the data).


```r
ggparcoord(mtcars, columns = c(1,3:6,9,10), groupColumn = 2, splineFactor = 10, alphaLines=0.6)
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-6-1.png" width="672" style="display: block; margin: auto;" />

### Distributions

Boxplots may be used to observe the distribution of the data and identify outliers. shadeBox may be used to color a box between the min and max value behind every column, but a boxplot will achieve the same goal (with more detail and visual appeal too).

Note: the splineFactor parameter may not be used with boxplot or shadeBox


```r
ggparcoord(mtcars, 
           columns = c(1,3:6,9,10), 
           groupColumn = 2, 
           alphaLines=0.7,
           boxplot = TRUE)
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

### ggplot2 commands

The title parameter may be used alongside with themes to make the graph visually appealing. This includes powerful methods such as facet_wrap. This way can observe the distribution or trend of each category. If the x-axis labels of the plots are "squished" together (especially for datasets with many features), the angle of the text may be adjusted to avoid overlap.


```r
ggparcoord(mtcars, 
           columns = c(1,3:6,9,10), 
           groupColumn = 2, 
           alphaLines=0.7,
           boxplot = TRUE
           ) +
  xlab("Car Features") +
  ylab("Count") +
  theme(axis.text.x = element_text(angle=45, vjust = 1, hjust=1)) +
  facet_wrap(~cyl, nrow = 2)
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-8-1.png" width="672" style="display: block; margin: auto;" />


## Package/Method: ggparallel

There are ways to introduce discrete data into ggparcoords. But there is a different library with much more flexibility with discrete values. Let's try out ggparallel


```r
ggparallel(vars = list("cyl", "gear", "carb"), data = mtcars)
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-9-1.png" width="672" style="display: block; margin: auto;" />
\
\
Compared to ggparallel, ggparcoord does not tell us much information regarding the discrete variables. This is the main difference. Let's shift our attention back to ggparallel


```r
ggparcoord(mtcars, columns = c(2,8,9))
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

### Methods

As more columns are added, the columns may get "squished" together and it starts looking very busy. We can adjust the width parameter and change the method to get a better view;
- angle is the default method
- adj.angle is particularly good at dealing with crowded data.
- Hammock is just as cluttered as angle but takes up less space visually so it is good for fewer columns of data
- parset is similar to angle, but has straight rather than curved wedges. May look more visually appealing depending on the dataset

### Parameters
-method: changes view of data (angle, adj.angle, parset, hammock)
-alpha: transparency of wedges
-width: visual width of each column
-ratio: changes the height of the wedges (in conjunction with hammock and adj.angle)
-order: changes the order of the categories in each column (based on size of proportion)


```r
ggparallel(vars = list("cyl", "gear", "carb", "vs", "am"), data = mtcars) + 
  ggtitle("angle")
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />

```r
ggparallel(vars = list("cyl", "gear", "carb", "vs", "am"), data = mtcars, width = 0.15,
           method = "adj.angle") +
  ggtitle("adj.angle")
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-11-2.png" width="672" style="display: block; margin: auto;" />

```r
ggparallel(vars = list("cyl", "gear", "carb", "vs", "am"), data = mtcars, width = 0.15,
           method = "hammock", ratio = 0.3, alpha = 0.3) +
  ggtitle("hammock")
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-11-3.png" width="672" style="display: block; margin: auto;" />

```r
ggparallel(vars = list("cyl", "gear", "carb", "vs", "am"), data = mtcars,
           method = "parset") +
  ggtitle("parset")
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-11-4.png" width="672" style="display: block; margin: auto;" />
\
\
More parameters:
-order: changes the order of the categories in each column based on size of proportion (decreasing, increasing, and unchanged order)
-label.size: changes the size of the text in each column
-text.angle: adjusts angle of text within columns


```r
ggparallel(vars = names(mtcars)[c(2,10,11,8,9)], data = mtcars, width = 0.15, order=0,
           method = "adj.angle", label.size=3.5, text.angle=0)
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-12-1.png" width="672" style="display: block; margin: auto;" />
### With ggplot2 commands


```r
ggparallel(vars = names(mtcars)[c(2,10,11,8,9)], data = mtcars, width = 0.15,
           method = "adj.angle", label.size=3.5, text.angle=0) +
  ggtitle("Car Parts") +
  xlab("Car Feature") +
  ylab("Amount") +
  theme_bw() +
  facet_wrap(~carb, nrow=3)
```

<img src="parallel_coordinate_plots_cheatsheet_files/figure-html/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />



## Package and Method: parcoords

Unlike the previous two packages, parcoords allows for interactive parallel coordinate plots. Default graph is below.


```r
parcoords(mtcars)
```

```{=html}
<div class="parcoords html-widget" height="480" id="htmlwidget-26e4ec90a4771c6f51eb" style="width:672px;height:480px; position:relative; overflow-x:auto; overflow-y:hidden; max-width:100%;" width="672"></div>
<script type="application/json" data-for="htmlwidget-26e4ec90a4771c6f51eb">{"x":{"data":{"names":["Mazda RX4","Mazda RX4 Wag","Datsun 710","Hornet 4 Drive","Hornet Sportabout","Valiant","Duster 360","Merc 240D","Merc 230","Merc 280","Merc 280C","Merc 450SE","Merc 450SL","Merc 450SLC","Cadillac Fleetwood","Lincoln Continental","Chrysler Imperial","Fiat 128","Honda Civic","Toyota Corolla","Toyota Corona","Dodge Challenger","AMC Javelin","Camaro Z28","Pontiac Firebird","Fiat X1-9","Porsche 914-2","Lotus Europa","Ford Pantera L","Ferrari Dino","Maserati Bora","Volvo 142E"],"mpg":[21,21,22.8,21.4,18.7,18.1,14.3,24.4,22.8,19.2,17.8,16.4,17.3,15.2,10.4,10.4,14.7,32.4,30.4,33.9,21.5,15.5,15.2,13.3,19.2,27.3,26,30.4,15.8,19.7,15,21.4],"cyl":["6","6","4","6","8","6","8","4","4","6","6","8","8","8","8","8","8","4","4","4","4","8","8","8","8","4","4","4","8","6","8","4"],"disp":[160,160,108,258,360,225,360,146.7,140.8,167.6,167.6,275.8,275.8,275.8,472,460,440,78.7,75.7,71.1,120.1,318,304,350,400,79,120.3,95.1,351,145,301,121],"hp":[110,110,93,110,175,105,245,62,95,123,123,180,180,180,205,215,230,66,52,65,97,150,150,245,175,66,91,113,264,175,335,109],"drat":[3.9,3.9,3.85,3.08,3.15,2.76,3.21,3.69,3.92,3.92,3.92,3.07,3.07,3.07,2.93,3,3.23,4.08,4.93,4.22,3.7,2.76,3.15,3.73,3.08,4.08,4.43,3.77,4.22,3.62,3.54,4.11],"wt":[2.62,2.875,2.32,3.215,3.44,3.46,3.57,3.19,3.15,3.44,3.44,4.07,3.73,3.78,5.25,5.424,5.345,2.2,1.615,1.835,2.465,3.52,3.435,3.84,3.845,1.935,2.14,1.513,3.17,2.77,3.57,2.78],"qsec":[16.46,17.02,18.61,19.44,17.02,20.22,15.84,20,22.9,18.3,18.9,17.4,17.6,18,17.98,17.82,17.42,19.47,18.52,19.9,20.01,16.87,17.3,15.41,17.05,18.9,16.7,16.9,14.5,15.5,14.6,18.6],"vs":[0,0,1,1,0,1,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,0,1,0,0,0,1],"am":[1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1],"gear":[4,4,4,3,3,3,3,4,4,4,4,3,3,3,3,3,3,4,4,4,3,3,3,3,3,4,5,5,5,5,5,4],"carb":[4,4,1,1,2,1,4,2,2,4,4,3,3,3,4,4,4,1,2,1,1,2,2,4,2,1,2,2,4,6,8,2]},"options":{"rownames":true,"brushPredicate":"AND","reorderable":false,"margin":{"top":50,"bottom":50,"left":100,"right":50},"mode":false,"bundlingStrength":0.5,"smoothness":0},"autoresize":false,"tasks":null},"evals":[],"jsHooks":[]}</script>
```

### Interactive parameters

-reorderable (T or F): allows the columns to be moved around
-brushMode: allows for filtering in each column of the dataset (options include 1D-axes, 1D-axes-multi, or 2D-strums). The main difference between these is 1D axes filters on columns, and 2D strums filters between columns
-alphaOnBrushed: when brushing, makes filtered-out lines visible (useful when looking for lines while brushing)
-brushPredicate: logical "and" or "or" on multiple brush filters (default is "and")


```r
library(d3r)
parcoords(mtcars,
          brushMode = "1D-axes",
          alpha=0.5,
          reorderable = T,
          withD3 = TRUE,
          color = list(
            colorScale = "scaleOrdinal",
            colorBy = "cyl",
            colorScheme = c("blue","green")
            )
          )
```

```{=html}
<div class="parcoords html-widget" height="480" id="htmlwidget-d8f57cf43a0154275c9c" style="width:672px;height:480px; position:relative; overflow-x:auto; overflow-y:hidden; max-width:100%;" width="672"></div>
<script type="application/json" data-for="htmlwidget-d8f57cf43a0154275c9c">{"x":{"data":{"names":["Mazda RX4","Mazda RX4 Wag","Datsun 710","Hornet 4 Drive","Hornet Sportabout","Valiant","Duster 360","Merc 240D","Merc 230","Merc 280","Merc 280C","Merc 450SE","Merc 450SL","Merc 450SLC","Cadillac Fleetwood","Lincoln Continental","Chrysler Imperial","Fiat 128","Honda Civic","Toyota Corolla","Toyota Corona","Dodge Challenger","AMC Javelin","Camaro Z28","Pontiac Firebird","Fiat X1-9","Porsche 914-2","Lotus Europa","Ford Pantera L","Ferrari Dino","Maserati Bora","Volvo 142E"],"mpg":[21,21,22.8,21.4,18.7,18.1,14.3,24.4,22.8,19.2,17.8,16.4,17.3,15.2,10.4,10.4,14.7,32.4,30.4,33.9,21.5,15.5,15.2,13.3,19.2,27.3,26,30.4,15.8,19.7,15,21.4],"cyl":["6","6","4","6","8","6","8","4","4","6","6","8","8","8","8","8","8","4","4","4","4","8","8","8","8","4","4","4","8","6","8","4"],"disp":[160,160,108,258,360,225,360,146.7,140.8,167.6,167.6,275.8,275.8,275.8,472,460,440,78.7,75.7,71.1,120.1,318,304,350,400,79,120.3,95.1,351,145,301,121],"hp":[110,110,93,110,175,105,245,62,95,123,123,180,180,180,205,215,230,66,52,65,97,150,150,245,175,66,91,113,264,175,335,109],"drat":[3.9,3.9,3.85,3.08,3.15,2.76,3.21,3.69,3.92,3.92,3.92,3.07,3.07,3.07,2.93,3,3.23,4.08,4.93,4.22,3.7,2.76,3.15,3.73,3.08,4.08,4.43,3.77,4.22,3.62,3.54,4.11],"wt":[2.62,2.875,2.32,3.215,3.44,3.46,3.57,3.19,3.15,3.44,3.44,4.07,3.73,3.78,5.25,5.424,5.345,2.2,1.615,1.835,2.465,3.52,3.435,3.84,3.845,1.935,2.14,1.513,3.17,2.77,3.57,2.78],"qsec":[16.46,17.02,18.61,19.44,17.02,20.22,15.84,20,22.9,18.3,18.9,17.4,17.6,18,17.98,17.82,17.42,19.47,18.52,19.9,20.01,16.87,17.3,15.41,17.05,18.9,16.7,16.9,14.5,15.5,14.6,18.6],"vs":[0,0,1,1,0,1,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,0,1,0,0,0,1],"am":[1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1],"gear":[4,4,4,3,3,3,3,4,4,4,4,3,3,3,3,3,3,4,4,4,3,3,3,3,3,4,5,5,5,5,5,4],"carb":[4,4,1,1,2,1,4,2,2,4,4,3,3,3,4,4,4,1,2,1,1,2,2,4,2,1,2,2,4,6,8,2]},"options":{"rownames":true,"color":{"colorScale":"scaleOrdinal","colorBy":"cyl","colorScheme":["blue","green"]},"brushMode":"1D-axes","brushPredicate":"AND","reorderable":true,"margin":{"top":50,"bottom":50,"left":100,"right":50},"alpha":0.5,"mode":false,"bundlingStrength":0.5,"smoothness":0},"autoresize":false,"tasks":null},"evals":[],"jsHooks":[]}</script>
```



```r
parcoords(mtcars,
          reorderable = T,
          brushMode = "2D-strums",
          alphaOnBrushed = 0.15,
          brushPredicate = "or"
          )
```

```{=html}
<div class="parcoords html-widget" height="480" id="htmlwidget-a7724c2cde4bc1bd3b57" style="width:672px;height:480px; position:relative; overflow-x:auto; overflow-y:hidden; max-width:100%;" width="672"></div>
<script type="application/json" data-for="htmlwidget-a7724c2cde4bc1bd3b57">{"x":{"data":{"names":["Mazda RX4","Mazda RX4 Wag","Datsun 710","Hornet 4 Drive","Hornet Sportabout","Valiant","Duster 360","Merc 240D","Merc 230","Merc 280","Merc 280C","Merc 450SE","Merc 450SL","Merc 450SLC","Cadillac Fleetwood","Lincoln Continental","Chrysler Imperial","Fiat 128","Honda Civic","Toyota Corolla","Toyota Corona","Dodge Challenger","AMC Javelin","Camaro Z28","Pontiac Firebird","Fiat X1-9","Porsche 914-2","Lotus Europa","Ford Pantera L","Ferrari Dino","Maserati Bora","Volvo 142E"],"mpg":[21,21,22.8,21.4,18.7,18.1,14.3,24.4,22.8,19.2,17.8,16.4,17.3,15.2,10.4,10.4,14.7,32.4,30.4,33.9,21.5,15.5,15.2,13.3,19.2,27.3,26,30.4,15.8,19.7,15,21.4],"cyl":["6","6","4","6","8","6","8","4","4","6","6","8","8","8","8","8","8","4","4","4","4","8","8","8","8","4","4","4","8","6","8","4"],"disp":[160,160,108,258,360,225,360,146.7,140.8,167.6,167.6,275.8,275.8,275.8,472,460,440,78.7,75.7,71.1,120.1,318,304,350,400,79,120.3,95.1,351,145,301,121],"hp":[110,110,93,110,175,105,245,62,95,123,123,180,180,180,205,215,230,66,52,65,97,150,150,245,175,66,91,113,264,175,335,109],"drat":[3.9,3.9,3.85,3.08,3.15,2.76,3.21,3.69,3.92,3.92,3.92,3.07,3.07,3.07,2.93,3,3.23,4.08,4.93,4.22,3.7,2.76,3.15,3.73,3.08,4.08,4.43,3.77,4.22,3.62,3.54,4.11],"wt":[2.62,2.875,2.32,3.215,3.44,3.46,3.57,3.19,3.15,3.44,3.44,4.07,3.73,3.78,5.25,5.424,5.345,2.2,1.615,1.835,2.465,3.52,3.435,3.84,3.845,1.935,2.14,1.513,3.17,2.77,3.57,2.78],"qsec":[16.46,17.02,18.61,19.44,17.02,20.22,15.84,20,22.9,18.3,18.9,17.4,17.6,18,17.98,17.82,17.42,19.47,18.52,19.9,20.01,16.87,17.3,15.41,17.05,18.9,16.7,16.9,14.5,15.5,14.6,18.6],"vs":[0,0,1,1,0,1,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,0,1,0,0,0,1],"am":[1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1],"gear":[4,4,4,3,3,3,3,4,4,4,4,3,3,3,3,3,3,4,4,4,3,3,3,3,3,4,5,5,5,5,5,4],"carb":[4,4,1,1,2,1,4,2,2,4,4,3,3,3,4,4,4,1,2,1,1,2,2,4,2,1,2,2,4,6,8,2]},"options":{"rownames":true,"brushMode":"2D-strums","brushPredicate":"OR","alphaOnBrushed":0.15,"reorderable":true,"margin":{"top":50,"bottom":50,"left":100,"right":50},"mode":false,"bundlingStrength":0.5,"smoothness":0},"autoresize":false,"tasks":null},"evals":[],"jsHooks":[]}</script>
```


### Color parameter

This parameter takes in a list (which can contain colorScale, colorBy, colorScheme, etc). Since most of the data will include continuous variables, ensure you install and import the library "d3r", or the graph will get an error
\
- set withD3 = TRUE when using the color parameter
\
\

## Ending Notes and Analysis:

### ggparcoord (GGally)

- can display continuous and discrete data, though best with continuous\
- can compare distributions between features\
- utilizes ggplot2 commands\
- has the most flexibility out of the 3 methods\

### ggparallel

- visualizes proportions between discrete data\
- many visualization options as seen with wedges\
- utilizes ggplot2 commands\
- not as flexible as ggparcoord\

### parcoords

- contains interactive functionality\
- best for observing relationships between continuous and discrete features\
- least flexible; cannot use ggplot2 commands\


