# Supervised Learning Tutorial

Sung Jun Won


```r
library(ggplot2)
library(lattice)
library(caret)
library(AppliedPredictiveModeling)
library(mlbench)
library(MLmetrics)
```

link to caret package guide:
http://topepo.github.io/caret/index.html

In this tutorial, I will be introducing caret, R package that supports various machine learning tools. I will mainly focus on introducing supervised learning.

There are few important steps in supervised learning.
1. Data preprocessing
2. Data splitting
3. Model selection
4. Training
5. Evaluation

Let's walk through these steps one by one.


1) Data preprocessing

To go through the data preprocessing step, we will be using schedulingData data from AppliedPredictiveModeling library.


```r
data(schedulingData)
str(schedulingData)
```

```
## 'data.frame':	4331 obs. of  8 variables:
##  $ Protocol   : Factor w/ 14 levels "A","C","D","E",..: 4 4 4 4 4 4 4 4 4 4 ...
##  $ Compounds  : num  997 97 101 93 100 100 105 98 101 95 ...
##  $ InputFields: num  137 103 75 76 82 82 88 95 91 92 ...
##  $ Iterations : num  20 20 10 20 20 20 20 20 20 20 ...
##  $ NumPending : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ Hour       : num  14 13.8 13.8 10.1 10.4 ...
##  $ Day        : Factor w/ 7 levels "Mon","Tue","Wed",..: 2 2 4 5 5 3 5 5 5 3 ...
##  $ Class      : Factor w/ 4 levels "VF","F","M","L": 2 1 1 1 1 1 1 1 1 1 ...
```

Some dataset may have features that have only one unique value, or some unique values that occur with very low frequency. Model trained on such dataset may crash or not fit well. 
To resolve this issue, we can use nearZeroVar to identify such features and remove such features.


```r
nzv <- nearZeroVar(schedulingData)
filteredDescr <- schedulingData[, -nzv]
filteredDescr[1:10,]
```

```
##    Protocol Compounds InputFields Iterations     Hour Day Class
## 1         E       997         137         20 14.00000 Tue     F
## 2         E        97         103         20 13.81667 Tue    VF
## 3         E       101          75         10 13.85000 Thu    VF
## 4         E        93          76         20 10.10000 Fri    VF
## 5         E       100          82         20 10.36667 Fri    VF
## 6         E       100          82         20 16.53333 Wed    VF
## 7         E       105          88         20 16.40000 Fri    VF
## 8         E        98          95         20 16.73333 Fri    VF
## 9         E       101          91         20 16.18333 Fri    VF
## 10        E        95          92         20 10.78333 Wed    VF
```

For models that can't take categorical features (linear regression, logistic regression, etc), we need to convert them to dummy variables using so-called One-Hot Encoding.

```r
str(filteredDescr)
```

```
## 'data.frame':	4331 obs. of  7 variables:
##  $ Protocol   : Factor w/ 14 levels "A","C","D","E",..: 4 4 4 4 4 4 4 4 4 4 ...
##  $ Compounds  : num  997 97 101 93 100 100 105 98 101 95 ...
##  $ InputFields: num  137 103 75 76 82 82 88 95 91 92 ...
##  $ Iterations : num  20 20 10 20 20 20 20 20 20 20 ...
##  $ Hour       : num  14 13.8 13.8 10.1 10.4 ...
##  $ Day        : Factor w/ 7 levels "Mon","Tue","Wed",..: 2 2 4 5 5 3 5 5 5 3 ...
##  $ Class      : Factor w/ 4 levels "VF","F","M","L": 2 1 1 1 1 1 1 1 1 1 ...
```


```r
dummies <- dummyVars("~.", data = filteredDescr[,-7])
encodedData <- data.frame(predict(dummies, newdata = filteredDescr))
head(encodedData)
```

```
##   Protocol.A Protocol.C Protocol.D Protocol.E Protocol.F Protocol.G Protocol.H
## 1          0          0          0          1          0          0          0
## 2          0          0          0          1          0          0          0
## 3          0          0          0          1          0          0          0
## 4          0          0          0          1          0          0          0
## 5          0          0          0          1          0          0          0
## 6          0          0          0          1          0          0          0
##   Protocol.I Protocol.J Protocol.K Protocol.L Protocol.M Protocol.N Protocol.O
## 1          0          0          0          0          0          0          0
## 2          0          0          0          0          0          0          0
## 3          0          0          0          0          0          0          0
## 4          0          0          0          0          0          0          0
## 5          0          0          0          0          0          0          0
## 6          0          0          0          0          0          0          0
##   Compounds InputFields Iterations     Hour Day.Mon Day.Tue Day.Wed Day.Thu
## 1       997         137         20 14.00000       0       1       0       0
## 2        97         103         20 13.81667       0       1       0       0
## 3       101          75         10 13.85000       0       0       0       1
## 4        93          76         20 10.10000       0       0       0       0
## 5       100          82         20 10.36667       0       0       0       0
## 6       100          82         20 16.53333       0       0       1       0
##   Day.Fri Day.Sat Day.Sun
## 1       0       0       0
## 2       0       0       0
## 3       0       0       0
## 4       1       0       0
## 5       1       0       0
## 6       0       0       0
```
We can see that for each categorical values, a column is made with values of 0 and 1.

To preprocess all the features as needed, caret supports an amazing function called preProcess, which decides whatever preprocessings it needs to perform on any dataset and apply them accordingly. 
For numerical features, we can apply centering and scaling to normalize the dataset.


```r
pp_hpc <- preProcess(encodedData, 
                     method = c("center", "scale", "YeoJohnson"))
transformed <- predict(pp_hpc, newdata = encodedData)
head(transformed)
```

```
##   Protocol.A Protocol.C Protocol.D Protocol.E Protocol.F Protocol.G Protocol.H
## 1 -0.1489308 -0.1958347 -0.1887344   6.641114 -0.2021043 -0.1926351 -0.2828982
## 2 -0.1489308 -0.1958347 -0.1887344   6.641114 -0.2021043 -0.1926351 -0.2828982
## 3 -0.1489308 -0.1958347 -0.1887344   6.641114 -0.2021043 -0.1926351 -0.2828982
## 4 -0.1489308 -0.1958347 -0.1887344   6.641114 -0.2021043 -0.1926351 -0.2828982
## 5 -0.1489308 -0.1958347 -0.1887344   6.641114 -0.2021043 -0.1926351 -0.2828982
## 6 -0.1489308 -0.1958347 -0.1887344   6.641114 -0.2021043 -0.1926351 -0.2828982
##   Protocol.I Protocol.J  Protocol.K Protocol.L Protocol.M Protocol.N Protocol.O
## 1 -0.3105373 -0.5439322 -0.03724195 -0.2432478 -0.3408963 -0.3757737 -0.3935703
## 2 -0.3105373 -0.5439322 -0.03724195 -0.2432478 -0.3408963 -0.3757737 -0.3935703
## 3 -0.3105373 -0.5439322 -0.03724195 -0.2432478 -0.3408963 -0.3757737 -0.3935703
## 4 -0.3105373 -0.5439322 -0.03724195 -0.2432478 -0.3408963 -0.3757737 -0.3935703
## 5 -0.3105373 -0.5439322 -0.03724195 -0.2432478 -0.3408963 -0.3757737 -0.3935703
## 6 -0.3105373 -0.5439322 -0.03724195 -0.2432478 -0.3408963 -0.3757737 -0.3935703
##    Compounds InputFields Iterations         Hour    Day.Mon   Day.Tue
## 1  1.2289592  -0.6324580 -0.0615593  0.004586516 -0.4360255  1.952266
## 2 -0.6065826  -0.8120473 -0.0615593 -0.043733201 -0.4360255  1.952266
## 3 -0.5719534  -1.0131504 -2.7894869 -0.034967177 -0.4360255 -0.512107
## 4 -0.6427737  -1.0047277 -0.0615593 -0.964170752 -0.4360255 -0.512107
## 5 -0.5804713  -0.9564504 -0.0615593 -0.902085020 -0.4360255 -0.512107
## 6 -0.5804713  -0.9564504 -0.0615593  0.698108782 -0.4360255 -0.512107
##      Day.Wed    Day.Thu    Day.Fri     Day.Sat    Day.Sun
## 1 -0.5131843 -0.4464804 -0.5203564 -0.08626629 -0.1964693
## 2 -0.5131843 -0.4464804 -0.5203564 -0.08626629 -0.1964693
## 3 -0.5131843  2.2392230 -0.5203564 -0.08626629 -0.1964693
## 4 -0.5131843 -0.4464804  1.9213160 -0.08626629 -0.1964693
## 5 -0.5131843 -0.4464804  1.9213160 -0.08626629 -0.1964693
## 6  1.9481679 -0.4464804 -0.5203564 -0.08626629 -0.1964693
```

2) Data Splitting

We can split the data into train & test.
We can use createDataPartition function to create balanced split between train and test.
We will use Sonar data from mlbench package as an example.

```r
data(Sonar)
str(Sonar)
```

```
## 'data.frame':	208 obs. of  61 variables:
##  $ V1   : num  0.02 0.0453 0.0262 0.01 0.0762 0.0286 0.0317 0.0519 0.0223 0.0164 ...
##  $ V2   : num  0.0371 0.0523 0.0582 0.0171 0.0666 0.0453 0.0956 0.0548 0.0375 0.0173 ...
##  $ V3   : num  0.0428 0.0843 0.1099 0.0623 0.0481 ...
##  $ V4   : num  0.0207 0.0689 0.1083 0.0205 0.0394 ...
##  $ V5   : num  0.0954 0.1183 0.0974 0.0205 0.059 ...
##  $ V6   : num  0.0986 0.2583 0.228 0.0368 0.0649 ...
##  $ V7   : num  0.154 0.216 0.243 0.11 0.121 ...
##  $ V8   : num  0.16 0.348 0.377 0.128 0.247 ...
##  $ V9   : num  0.3109 0.3337 0.5598 0.0598 0.3564 ...
##  $ V10  : num  0.211 0.287 0.619 0.126 0.446 ...
##  $ V11  : num  0.1609 0.4918 0.6333 0.0881 0.4152 ...
##  $ V12  : num  0.158 0.655 0.706 0.199 0.395 ...
##  $ V13  : num  0.2238 0.6919 0.5544 0.0184 0.4256 ...
##  $ V14  : num  0.0645 0.7797 0.532 0.2261 0.4135 ...
##  $ V15  : num  0.066 0.746 0.648 0.173 0.453 ...
##  $ V16  : num  0.227 0.944 0.693 0.213 0.533 ...
##  $ V17  : num  0.31 1 0.6759 0.0693 0.7306 ...
##  $ V18  : num  0.3 0.887 0.755 0.228 0.619 ...
##  $ V19  : num  0.508 0.802 0.893 0.406 0.203 ...
##  $ V20  : num  0.48 0.782 0.862 0.397 0.464 ...
##  $ V21  : num  0.578 0.521 0.797 0.274 0.415 ...
##  $ V22  : num  0.507 0.405 0.674 0.369 0.429 ...
##  $ V23  : num  0.433 0.396 0.429 0.556 0.573 ...
##  $ V24  : num  0.555 0.391 0.365 0.485 0.54 ...
##  $ V25  : num  0.671 0.325 0.533 0.314 0.316 ...
##  $ V26  : num  0.641 0.32 0.241 0.533 0.229 ...
##  $ V27  : num  0.71 0.327 0.507 0.526 0.7 ...
##  $ V28  : num  0.808 0.277 0.853 0.252 1 ...
##  $ V29  : num  0.679 0.442 0.604 0.209 0.726 ...
##  $ V30  : num  0.386 0.203 0.851 0.356 0.472 ...
##  $ V31  : num  0.131 0.379 0.851 0.626 0.51 ...
##  $ V32  : num  0.26 0.295 0.504 0.734 0.546 ...
##  $ V33  : num  0.512 0.198 0.186 0.612 0.288 ...
##  $ V34  : num  0.7547 0.2341 0.2709 0.3497 0.0981 ...
##  $ V35  : num  0.854 0.131 0.423 0.395 0.195 ...
##  $ V36  : num  0.851 0.418 0.304 0.301 0.418 ...
##  $ V37  : num  0.669 0.384 0.612 0.541 0.46 ...
##  $ V38  : num  0.61 0.106 0.676 0.881 0.322 ...
##  $ V39  : num  0.494 0.184 0.537 0.986 0.283 ...
##  $ V40  : num  0.274 0.197 0.472 0.917 0.243 ...
##  $ V41  : num  0.051 0.167 0.465 0.612 0.198 ...
##  $ V42  : num  0.2834 0.0583 0.2587 0.5006 0.2444 ...
##  $ V43  : num  0.282 0.14 0.213 0.321 0.185 ...
##  $ V44  : num  0.4256 0.1628 0.2222 0.3202 0.0841 ...
##  $ V45  : num  0.2641 0.0621 0.2111 0.4295 0.0692 ...
##  $ V46  : num  0.1386 0.0203 0.0176 0.3654 0.0528 ...
##  $ V47  : num  0.1051 0.053 0.1348 0.2655 0.0357 ...
##  $ V48  : num  0.1343 0.0742 0.0744 0.1576 0.0085 ...
##  $ V49  : num  0.0383 0.0409 0.013 0.0681 0.023 0.0264 0.0507 0.0285 0.0777 0.0092 ...
##  $ V50  : num  0.0324 0.0061 0.0106 0.0294 0.0046 0.0081 0.0159 0.0178 0.0439 0.0198 ...
##  $ V51  : num  0.0232 0.0125 0.0033 0.0241 0.0156 0.0104 0.0195 0.0052 0.0061 0.0118 ...
##  $ V52  : num  0.0027 0.0084 0.0232 0.0121 0.0031 0.0045 0.0201 0.0081 0.0145 0.009 ...
##  $ V53  : num  0.0065 0.0089 0.0166 0.0036 0.0054 0.0014 0.0248 0.012 0.0128 0.0223 ...
##  $ V54  : num  0.0159 0.0048 0.0095 0.015 0.0105 0.0038 0.0131 0.0045 0.0145 0.0179 ...
##  $ V55  : num  0.0072 0.0094 0.018 0.0085 0.011 0.0013 0.007 0.0121 0.0058 0.0084 ...
##  $ V56  : num  0.0167 0.0191 0.0244 0.0073 0.0015 0.0089 0.0138 0.0097 0.0049 0.0068 ...
##  $ V57  : num  0.018 0.014 0.0316 0.005 0.0072 0.0057 0.0092 0.0085 0.0065 0.0032 ...
##  $ V58  : num  0.0084 0.0049 0.0164 0.0044 0.0048 0.0027 0.0143 0.0047 0.0093 0.0035 ...
##  $ V59  : num  0.009 0.0052 0.0095 0.004 0.0107 0.0051 0.0036 0.0048 0.0059 0.0056 ...
##  $ V60  : num  0.0032 0.0044 0.0078 0.0117 0.0094 0.0062 0.0103 0.0053 0.0022 0.004 ...
##  $ Class: Factor w/ 2 levels "M","R": 2 2 2 2 2 2 2 2 2 2 ...
```

By setting p = 0.8, we can split the data in 8:2 ratio, 8 for train and 2 for test.
We want matrix output so list = FALSE, and since we are only splitting into two, partition times = 1.

```r
inTraining <- createDataPartition(Sonar$Class, p = .8, list = FALSE, times = 1)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]
```

3) Model Selection

caret provides trainControl function, with which we can change the cross validation methods, parameters for tuning, number of folds for k-fold CV, number of resampling, etc. Depending on what classification or regression model we decide to use, we can set these parameters as fit and tune the model to be optimal.

For instance, if we want to use k-fold cross validation, with the number of folds = 10 and number of resampling = 10, we can set the parameters as such:

```r
fitControl <- trainControl(## 10-fold CV
                           method = "repeatedcv",
                           number = 10,
                           ## repeated ten times
                           repeats = 10)
```

In python, we have to do hyperparameter tuning to find the best performing model. But in R, the function train by default uses best, which basically means that it chooses the parameters that shows the best accuracy. (or lowest RMSE) 

==> best(testing, "RMSE", maximize = FALSE)

But there are two other choices besides best, which are oneSE and tolerance.

oneSE aims to find the simplest model within one standard error of ideally most optimal model. 

==> oneSE(testing, "RMSE", maximize = FALSE, num = 10)

tolerance attempts to find less complex model that falls within a percent tolerance from ideally most optimal model. 

==> tolerance(testing, "RMSE", tol = 3, maximize = FALSE)

The idea behind using oneSE and tolerance is that they are ordering of models from simple to complex, but in many cases, models are too complicated to order one next to another. It is important to use the these two methods if the ordering of model complexity is deemed right.

4) Training

We can use the cross validation parameters chosen to train the model.
There are numerous classification or regression models that we can use to fit the data. 

To list a few, there are 
"treebag" or "logicbag" for Bagged Trees, 
"rf" for Random Forest, 
"adaboost" or "gbm" for Boosted Trees, 
"lm" for Linear Regression,
"logreg" for Logistic Regression,
and of course, numerous variations to these models too with regularization and so on.

To show an example, we can see Random Forest model fitting to the training data, with the 10-fold cross validation choosing the model with best performance.

```r
rfFit <- train(Class ~ ., data = training,
                 method = "rf", 
                 trControl = fitControl)
```

5) Evaluation

Using postResample function, we can get the performance of the model on the test data. With Random Forest, we can get prediction accuracy and Kappa, which compares observed accuracy from expected accuracy.

```r
pred <- predict(rfFit, testing)

postResample(pred = pred, obs = testing$Class)
```

```
##  Accuracy     Kappa 
## 0.8780488 0.7521161
```

We can also get confusion matrix for the test data using confusionMatrix function. It shows the accuracy scores as well as p-value and other evaluation metrics. To get precision, recall, and F1 score, we can set mode to "prec_recall".

```r
confusionMatrix(data = pred, reference = testing$Class, mode = "prec_recall")
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction  M  R
##          M 21  4
##          R  1 15
##                                          
##                Accuracy : 0.878          
##                  95% CI : (0.738, 0.9592)
##     No Information Rate : 0.5366         
##     P-Value [Acc > NIR] : 3.487e-06      
##                                          
##                   Kappa : 0.7521         
##                                          
##  Mcnemar's Test P-Value : 0.3711         
##                                          
##               Precision : 0.8400         
##                  Recall : 0.9545         
##                      F1 : 0.8936         
##              Prevalence : 0.5366         
##          Detection Rate : 0.5122         
##    Detection Prevalence : 0.6098         
##       Balanced Accuracy : 0.8720         
##                                          
##        'Positive' Class : M              
## 
```

So far, we have seen the basics of supervised learning.
In the link provided above, there are more details of each step as well as other steps to consider such as feature selection, calibration, etc.

I hope you guys liked this tutorial!

