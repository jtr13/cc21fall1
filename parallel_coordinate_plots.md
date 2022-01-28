# Parallel coordinate plots cheatsheet

Kechengjie Zhu

<style type="text/css">
h1 {color: #0146C6}
h2 {color: #3E82FF}
h3 {color: #83AEFF}
</style>



***

## Overview
A parallel coordinate plot maps each row in the data table as a line. Packages including **GGally** and **parcoords** help build & improve parallel coordinate plots in R.

***

## Load Packages


```r
library(GGally)
library(parcoords)
library(d3r)
```

***

## Load Data
Using the **mariokart** data set for illustration.

```r
df <- as.data.frame(openintro::mariokart)
```

***

## Basics

```r
ggparcoord(data = df,
           column = c(2:7, 9, 11),
           alphaLines = 0.5,) +
  ggtitle("Relations across auction details")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-5-1.png" width="672" style="display: block; margin: auto;" />

### Group by column
Pass to the **groupColumn** argument with a categorical variable representing groups.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond") +
  ggtitle("Relations across auction details grouped")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-6-1.png" width="672" style="display: block; margin: auto;" />

### Grouping Application: Highlight Certain Data Entries
Requires some manipulation on data frame.

```r
modified <- df %>%
  mutate(thresh = factor(ifelse(total_pr > 60, "Over 60", "Under 60"))) %>%
  arrange(desc(thresh))
ggparcoord(data = modified,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "thresh") +
  scale_color_manual(values = c("red", "grey")) +
  ggtitle("Highlight sales with total price over $60")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

### Add data points
Toggle the logical argument **showPoints** to display/hide data points.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond",
           showPoints = TRUE) +
  ggtitle("Relations across auction details with points")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-8-1.png" width="672" style="display: block; margin: auto;" />

### Spline interpolation
Smooth the lines with argument **splineFactor**. Value can be either logical or numeric.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond",
           splineFactor = 7) +
  ggtitle("Smoothed relations across auction details")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-9-1.png" width="672" style="display: block; margin: auto;" />

### Add box plots
Add box plots with **boxplot**.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.2,
           groupColumn = "cond",
           boxplot = TRUE) +
  ggtitle("Relations across auction details with box plots")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

***

## Scaling methods
Select scaling method with argument **scale**. Default method is **"std"**: subtract mean and divide by standard deviation.

### "robust"
Subtract median and divide by median absolute deviation.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond",
           scale = "robust")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />

### "uniminmax"
Scale so the minimum of the variable is zero, and the maximum is one.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond",
           scale = "uniminmax")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-12-1.png" width="672" style="display: block; margin: auto;" />

### "globalminmax"
No scaling: the range of the graphs is defined by the global minimum and the global maximum.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond",
           scale = "globalminmax")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />

### "center"
Scale using method **"uniminmax"**, and then center each variable at the summary statistic specified by the **scaleSummary** argument.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond",
           scale = "center",
           scaleSummary = "mean")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-14-1.png" width="672" style="display: block; margin: auto;" />

### "centerObs"
Scale using method **"uniminmax"**, and then center each variable at the row number specified by the **centerObsID** argument.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond",
           scale = "centerObs",
           centerObsID = 5)
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-15-1.png" width="672" style="display: block; margin: auto;" />

***

## Ordering methods

### "anyClass"
Calculate F-statistics for each class vs. the rest, order variables by their maximum F-statistics.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond",
           order = "anyClass")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-16-1.png" width="672" style="display: block; margin: auto;" />

### "allClass"
Order variables by their overall F-statistic from an ANOVA with **groupColumn** as the explanatory variable.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond",
           order = "allClass")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-17-1.png" width="672" style="display: block; margin: auto;" />

### "skewness"
Order variables by their skewness.

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond",
           order = "skewness")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-18-1.png" width="672" style="display: block; margin: auto;" />

***

## Make Plots for Each Group with Facets

```r
ggparcoord(data = df,
           column = c(2:3, 5:7, 9, 11),
           alphaLines = 0.5,
           groupColumn = "cond") +
  facet_wrap(~ cond) +
  ggtitle("Relations across auction details")
```

<img src="parallel_coordinate_plots_files/figure-html/unnamed-chunk-19-1.png" width="1152" style="display: block; margin: auto;" />

***

## Interactive Parallel Coordinate Plots

```r
parcoords(df[,c(2:3, 5:7, 9, 11)],
          rownames = F,
          color = list(CcolorBy = "cond"),
          brushMode = "1D-axes",
          reorderable = T,
          queue = T,
          withD3 = T)
```

```{=html}
<div class="parcoords html-widget" height="480" id="htmlwidget-062cc26351576b38edaa" style="width:672px;height:480px; position:relative; overflow-x:auto; overflow-y:hidden; max-width:100%;" width="672"></div>
<script type="application/json" data-for="htmlwidget-062cc26351576b38edaa">{"x":{"data":{"names":["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143"],"duration":[3,7,3,3,1,3,1,1,3,7,1,1,1,1,7,7,3,3,1,7,1,1,1,1,3,1,3,3,1,7,1,7,5,5,3,3,3,7,1,1,7,3,1,1,1,3,1,7,7,7,1,1,3,3,7,1,7,5,7,10,1,1,1,5,3,7,1,7,7,7,3,3,7,1,1,1,3,5,3,5,10,1,3,7,7,3,7,7,5,3,7,5,1,7,1,3,3,1,7,5,5,1,1,1,5,7,5,7,1,5,3,3,7,1,1,7,7,7,1,3,7,7,1,1,3,7,1,1,1,3,1,7,7,5,7,1,5,7,1,7,3,7,1],"n_bids":[20,13,16,18,20,19,13,15,29,8,15,15,13,16,6,22,14,23,10,22,7,16,1,18,12,19,5,5,13,15,11,14,13,24,10,15,16,17,9,14,5,13,14,29,17,8,12,20,21,16,10,17,16,2,16,14,10,7,16,3,23,12,9,18,27,12,13,14,12,16,9,17,16,20,1,13,4,21,14,18,15,8,19,2,14,14,7,7,5,16,13,10,11,15,16,15,23,20,9,14,11,13,1,22,7,18,17,9,16,20,16,5,5,25,3,7,18,10,13,8,16,3,17,11,9,10,23,19,14,11,1,14,14,17,11,18,20,6,20,9,14,13,13],"start_pr":[0.99,0.99,0.99,0.99,0.01,0.99,0.01,1,0.99,19.99,1,0.01,1,0.01,24.99,0.99,0.99,0.99,1,1,0.99,1,64.95,1,0.01,0.01,15,0.99,0.99,9.99,10,1.99,0.99,0.99,0.99,0.99,0.99,15,1,1,30,0.99,0.99,1,1,9.99,1,15,0.99,0.99,1,0.99,0.99,51.99,0.99,0.99,0.99,25,0.99,30,1,0.01,1,9.99,6.95,30,1,0.99,0.99,5,25,0.99,0.99,0.01,64.95,0.99,34.99,0.99,0.99,19.99,9.99,1,12,55,10,0.99,0.99,29.95,35,0.99,10,9.99,9.99,12,0.01,0.99,0.99,1,10,10,19.99,1,54.99,0.01,0.99,18,0.99,0.01,1,0.01,0.99,35,1,1,69.95,25,9.99,0.99,0.01,20,9.99,38,1,1,0.01,0.99,0.99,0.01,0.01,0.99,64.95,9.95,16,0.99,9.99,1,0.99,24.99,0.01,17.99,0.99,1,1],"ship_pr":[4,3.99,3.5,0,0,4,0,2.99,4,4,2.99,0,2.99,0,4,4,8.7,0,2.99,25.51,0,2.99,0,2.99,4,0,3.5,0,4,4,4,0,4,3.99,0,8.7,4,4,2.99,2.99,0,0,4,2.99,2.99,3.99,2.99,0,3,0,2.99,0,0,0,2.95,0,4,2.99,4,0,2.99,0,2.99,3.59,4,0,2.99,3,4,4,4,0,3.5,0,0,8.02,4,4,4,2.95,6,2.99,4,9.02,3.75,4,3,8.7,4,4,0,1.99,3.99,0,0,0,4,2.99,4,9.26,4,2.99,11.45,0,4,4,4,3,2.99,0,4,0,0,2.99,0,11.42,4,4,0,4,9.69,4,2.99,0,0,3.99,0,0,0,4,0,3.99,4,10.35,3,2.99,4,8.7,0,0,8.7,4.9,2.99],"total_pr":[51.55,37.04,45.5,44,71,45,37.02,53.99,47,50,54.99,56.01,48,56,43.33,46,46.71,46,55.99,326.51,31,53.98,64.95,50.5,46.5,55,34.5,36,40,47,43,31,41.99,49.49,41,44.78,47,44,63.99,53.76,46.03,42.25,46,51.99,55.99,41.99,53.99,39,38.06,46,59.88,28.98,36,51.99,43.95,32,40.06,48,36,31,53.99,30,58,38.1,118.5,61.76,53.99,40,64.5,49.01,47,40.1,41.5,56,64.95,49,48,38,45,41.95,43.36,54.99,45.21,65.02,45.75,64,36,54.7,49.91,47,43,35.99,54.49,46,31.06,55.6,40.1,52.59,44,38.26,51,48.99,66.44,63.5,42,47,55,33.01,53.76,46,43,42.55,52.5,57.5,75,48.92,45.99,40.05,45,50,49.75,47,56,41,46,34.99,49,61,62.89,46,64.95,36.99,44,41.35,37,58.98,39,40.7,39.51,52,47.7,38.76,54.51],"seller_rate":[1580,365,998,7,820,270144,7284,4858,27,201,4858,820,4858,820,154,309,251,7,4858,115,4982,4858,118345,4858,172,820,37,15,4200,62,18,166,16041,27,42241,88,1270,2131,4858,4858,555,42241,34,4858,4858,69,4858,422,8625,90,4858,4982,2046,223861,943,206,4473,239,355,19,4858,7284,4858,861,41,27,4858,88,991,285,627,2046,998,820,118345,350,85,14504,270144,194,2399,4858,64,25,0,127,0,208,127,231,21,19,69,15,7284,54,270144,4858,103,35,36,4858,118345,820,14503,389,261,381,4858,8224,270143,10,116,4858,118345,11,1154,877,556,63,94,508,4858,30,1144,462,280,820,820,299,118345,2290,37,14503,297,4858,14503,3085,7284,121,251,41,4858],"wheels":[1,1,1,1,2,0,0,2,1,1,2,2,2,2,1,0,1,1,2,2,0,2,2,2,1,2,0,0,0,1,0,0,1,2,1,1,0,1,2,2,1,1,2,2,2,1,2,0,0,1,2,0,1,0,0,0,1,1,0,0,2,0,2,0,0,2,2,1,3,2,1,1,1,2,2,2,1,0,0,0,1,2,1,4,1,2,0,1,1,0,1,0,2,1,0,2,0,2,2,1,2,2,2,2,0,1,2,1,2,1,0,1,2,2,3,1,1,1,1,2,0,1,2,1,1,1,2,2,2,1,2,0,1,1,0,2,0,1,0,2,1,0,2]},"options":{"rownames":false,"color":{"CcolorBy":"cond"},"brushMode":"1D-axes","brushPredicate":"AND","reorderable":true,"margin":{"top":50,"bottom":50,"left":100,"right":50},"mode":"queue","bundlingStrength":0.5,"smoothness":0},"autoresize":false,"tasks":null},"evals":[],"jsHooks":[]}</script>
```

***

## References
https://www.rdocumentation.org/packages/GGally/versions/1.5.0/topics/ggparcoord
https://www.rdocumentation.org/packages/parcoords/versions/1.0.0/topics/parcoords
