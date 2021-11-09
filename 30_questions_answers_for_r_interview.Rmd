# 30 questions & answers for r technical interview

Anna Dai

This is 30 Questions & Answers To Help You Prepare For An R Technical Interview

Motivations
Some of the students are graduating soon and it’s the time for job hunting and interview
prepping! I am coming up with 30 relevant and technical R interview questions and answers
that help students who’s preparing for an interview. Currently, there are many great interview
prep materials for Python online, but not many useful materials for R interviews. Some of the R
interview questions on the web are not very technical (e.g., what’s R? what’s your favorite R
functions? etc.). I wanted to make it more technical, concise and ready-to-use as in how we
can solve problems using the things we learned in EDAV class. I divided the questions &
answers into three sections:
1. (Data Manipulation)
2. (Data Visualization & Plots)
3. (Statistical Tests In R)

Data Manipulations
Q1: What is the difference between sapply and lapply? When should you use one versus the
other?
A1: Use lapply when you want the output to be a list, and sapply when you want the output to
be a vector or a dataframe.
Q2: How to subset observations based on their value?
A2: Use Filter(). This allows you to subset observations based on their values. The first
argument is the name of the data frame. The second and subsequent arguments are the
expressions that filter the data frame. For example, we can select all flights on January 1st with:
filter(flights, month == 1, day == 1)
Q3: How to determine if a value is missing?
A3: Use is.na() This will return true or false.
Q4: What is the difference between arrange and filter?
A4: arrange() works similarly to filter() except that instead of selecting rows, it changes their
order. It takes a data frame and a set of column names (or more complicated expressions) to
order by. If you provide more than one column name, each additional column will be used to
break ties in the values of preceding columns:
Q5: How to subset the dataset using operations based on the names of the variable?
A5: select() allows you to rapidly zoom in on a useful subset using operations based on the
names of the variables.
Q6: How do you add new columns that are functions of existing columns?
A6: mutate() always adds new columns at the end of your dataset so we’ll start by creating a
narrower dataset so we can see the new variables.
Q7: How do you collapse a dataframe to a single row?
A7: Use summaries(). summarise() is useful when we pair it with group_by(). This changes
the unit of analysis from the complete dataset to individual groups.
Q8: How to combine multiple operations?
A8: Use the pipe %>%
Q9: How do you remove the missing value prior to computation?
A9: Use na.rm All aggregation functions have an na.rm argument which removes the missing
values prior to computation.
Q10: How to return to operations on ungrouped data?
A10: If you need to remove grouping, and return to operations on ungrouped data, use
ungroup()
Q11: How would you use pivot longer and pivot wider?
A11: pivot_longer() "lengthens" data, increasing the number of rows and decreasing the
number of columns. The inverse transformation is pivot_wider()
Q12: How to create factors in R?
A12: We can create a factor using the function factor(). Levels of a factor are inferred from the
data if not provided. Similarly, levels of a factor can be checked using the levels() function.
For example:
x <- factor(c("single", "married", "married", "single"));

Visualizations & Plots
Q13: When should you use boxplot?
A13: Boxplots should be used to display continuous variables. They are particularly useful for
identifying outliers and comparing different groups. To use boxplot in base R, you can simply
use boxplot() function.
Q14: When would you use violin plot?
A14: Violin plots should be used to display continuous variables only.
Q15: What is QQ plot?
A15: In statistics, a Q-Q (quantile-quantile) plot is a probability plot, which is a graphical method
for comparing two probability distributions by plotting their quantiles against each other. A
point (x, y) on the plot corresponds to one of the quantiles of the second distribution (ycoordinate)
plotted against the same quantile of the first distribution (x-coordinate). Thus the
line is a parametric curve with the parameter which is the number of the interval for the
quantile.
Q16: What is the difference between barchart and cleveland plot? The advantages and
disadvantages?
A16: Bar Charts are best for categorical data. Often you will have a collection of factors that you
want to split into different groups. Cleveland dot plots are a great alternative to a simple bar
chart, particularly if you have more than a few items. It doesn’t take much for a bar chart to
look cluttered. In the same amount of space, many more values can be included in a dot plot,
and it’s easier to read as well. R has a built-in base function, dotchart()
Q17: If you want to understand the correlations between variables what would you use?
A17: Scatterplots are great for exploring relationships between variables. Basically, if you are
interested in how variables relate to each other, the scatterplot is a great place to start.
Q18: How to Create and Interpret Pairs Plots in R?
A18: A pairs plot is a matrix of scatterplots that lets you understand the pairwise relationship
between different variables in a dataset. It’s easy to create a pairs plot in R by using the pairs ()
function.
Q19: What is Mosaic plot? How would you use it?
A19: A mosaic plot is a special type of stacked bar chart that shows percentages of data in
groups. It works well with multivariate categorical variables. The plot is a graphical
representation of a contingency table. Mosaic plots are used to show relationships and to
provide a visual comparison of groups.
Q20: If you want to compare different parameters while also seeing their relative distributions,
what would you use?
A20: Heat maps are like a combination of scatterplots and histograms: they allow you to
compare different parameters while also seeing their relative distributions.
Q21: What's Alluvial diagrams and how would you use and create one?
A21: Parallel coordinates plot is one of the tools for visualizing multivariate data. Every
observation in a dataset is represented with a polyline that crosses a set of parallel axes
corresponding to variables in the dataset. You can create such plots in R using a function
parcoord in package MASS.
Q22: What are some R visualization packages?
A22: Plotly, ggplot2, tidyquant, geofacet, googleVis, Shiny.

Statistical Tests In R
Q23: What is t-test() in R?
A23: The t-test() function is used to determine that the mean of the two groups are equal
or not.
Q24: What is Shapiro Test and why is it used?
A24: Sahpiro test is used to test if a sample follows a normal distribution. The basic syntax in R
for Shapiro test is:
shapiro.test(numericVector)
Q25: What is Fisher’s F-Test?
A25: Fisher’s F test can be used to check if two samples have same variance. For example:
var.test(x, y)
Q26: How do you interpret P-value?
A26: P values determine whether your hypothesis test results are statistically significant. P
value is the probability of obtaining an effect at least as extreme as the one in your sample
data, assuming the truth of the null hypothesis. For example, suppose that a cancer treatment
study produced a P value of 0.04. This P value indicates that if the cancer treatment had no
effect, you’d obtain the observed difference or more in 4% of studies due to random sampling
error. P values address only one question: how likely are your data, assuming a true null
hypothesis? It does not measure support for the alternative hypothesis.
Q27: What is Mann-Whitney-Wilcoxon Test?
A27: Two data samples are independent if they come from distinct populations and the
samples do not affect each other. Using the Mann-Whitney-Wilcoxon Test, we can decide
whether the population distributions are identical without assuming them to follow the normal
distribution.
Q28: How do you compute Compute one-way ANOVA test in R?
A28: The R function aov() can be used to answer to this question. The function summary.aov() is
used to summarize the analysis of variance model.
For example:
res.aov <- aov(weight ~ group, data = my_data)
summary(res.aov)
Q29: How to Perform the Friedman Test in R?
A29: The Friedman Test is a non-parametric alternative to the Repeated Measures ANOVA. It is
used to determine whether or not there is a statistically significant difference between the
means of three or more groups in which the same subjects show up in each group.
To perform the Friedman Test in R, we can use the friedman.test() function, which uses
the following syntax:
friedman.test(y, groups, blocks).
Q30: What is Chi-Square test in R?
A30: The Chi-Square Test is used to analyze the frequency table (i.e., contingency table), which
is formed by two categorical variables. The chi-square test evaluates whether there is a
significant relationship between the categories of the two variables. For example, we can build
a data set with observations on people's candy buying pattern and try to correlate the gender
of a person with the flavor of the candy they prefer. If a correlation is found, we can plan for
appropriate stock of flavors by knowing the number of gender of people visiting. The basic
syntax for creating Chi-Square is:
chisq.test(data)

Citations
https://www.rdocumentation.org/packages/tidyverse/versions/1.3.1
https://www.rdocumentation.org/packages/ggplot2/versions/3.3.5
https://plotly.com/r/
https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/t.test
https://r-pkgs.org/tests.html
https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/chisq.test
https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/wilcox.test
