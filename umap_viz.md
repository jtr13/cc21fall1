# Efficient dimension reduction with UMAP

Soham Joshi and Mehrab Singh Gill





## Brief Introduction to UMAP

The dimensionality techniques that exist right now do not tend to work very efficiently when there are a lot of dimensions involved. In such cases these techniques tend to be very slow and inefficient. This is where UMAP (Uniform Manifold Approximation and Projection) comes into the picture as it works very well in cases where there are a lot of dimensions involved. 


UMAP is a dimensionality reduction technique which uses Topological Data Analysis and Mapping to project higher dimensional data to lower dimensions. UMAP can be used for dimensionality reduction, unsupervised clustering and metric learning. UMAP tends to work much faster and efficiently compared to the other techniques. This can be very effective as it takes into consideration the local and global minima and maxima while projecting data into two dimensions. It does not find the principal components. 


Unlike PCA (Principal Component Analysis), which is a linear approach, UMAP uses k nearest neighbours on an n-dimensional manifold to find out those points which are closest to a certain point based on the topology of the data. UMAP basically checks the relations in the higher dimensions and then helps to plot the same in lower dimensions. 


UMAP can be used in R through the "umap" package which is an implementation of the python package in R. While working on this project, we gained hands on experience with the "umap" package and realized how efficient, fast and easy it can be to visualize data with higher dimensions with the help of UMAP. We aim to explore many more datasets on which we could define and demonstrate this technique as well as try to make a better and faster package for visualization of data in R.

As part of our project, we will now be demonstrating the use of the "umap" package, input tuning and its properties by working on two datasets, namely MNIST and IRIS.


## Experiments on the MNIST dataset

Let's start with a high dimensionality dataset which can be projected to 2 dimensions and then discerned with clusters. The MNIST hand written digits dataset is a collection of images of handwritten numbers, flattened and stored as a 784 dimension vectors. 



```r
df2<- read.csv("https://datahub.io/machine-learning/mnist_784/r/mnist_784.csv")
```

Since, the MNIST dataset has the digits from 0-9 with 70,000 rows, this processing is computationally very expensive for R. Hence, we will consider only the first 4 digits, i.e {0,1,2,3} and all entries corresponding to them. We thus get a 784 dimensions x 28,911 rows data.

We also separate the labels and the actual input data to umap.


```r
df2 <- df2[ !(df2$class >= 4),]
mnist_labels = df2[, "class"]
mnist_data = df2[1:784]
```

The function call to umap is very straightforward in the default case.


```r
mnist.umap = umap(mnist_data)
mnist.umap
```

Here we get an object of the following summary:

1. It is an umap embedding of 28911 items, which refer to our data points and 2 dimensions. Thus, the umap algorithm has reduced our data from 784 to 2 dimensional data.

2. Layout: This is a numeric vector which gives us the values of the 2 dimensions that we have created. These values can be considered as X and Y coordinates and form the projection that UMAP has created.

3. Data: It is the input data we fed into the algorithm.

4. KNN: This is also an object which consists of two components, indexes and distances, which are stored from the smooth knn part of the UMAP algorithm.

5. config: These are the input parameters which are considered for UMAP. In this particular case we have not tweaked any, but we will be doing it shortly.


If you now plot the embedding created by UMAP, we get the following result:


```r
df <- data.frame(mnist.umap$layout[,1], mnist.umap$layout[,2], mnist_labels)
colnames(df) <- c("X","Y", "Label")
ggplot(df, aes(x =X, y= Y))+ geom_point()
```

<img src="umap_viz_files/figure-html/unnamed-chunk-6-1.png" width="672" style="display: block; margin: auto;" />

We can clearly see that there are 4 distinct clusters formed in the embedded data. We can visually assess the accuracy of this clustering by coloring the points according to their true labels: 


```r
df <- data.frame(mnist.umap$layout[,1], mnist.umap$layout[,2], mnist_labels)
colnames(df) <- c("X","Y", "Label")
ggplot(df, aes(x =X, y= Y, color= Label))+ geom_point()
```

<img src="umap_viz_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

With the exception of a few outliers, we see that UMAP accurately separates the clusters corresponding to the digits {0,1,2,3}.


For our base case, the default values of UMAP worked out well, but in some scenarios it may not be the case. Parameter tuning is thus very efficient for UMAP. We can change the input parameters to umap using the config object.

We can check the default values of UMAP as follows:


```r
custom.config = umap.defaults 
custom.config
```

## Parameters and Additional Insights

We will be focusing on the 3 most important parameters in UMAP:

1. n_neighbors: This controls the number of neighbors in KNN. Since the number of neighbors changes our idea of what points are similar to any given point on the manifold, this value can have a visible effect in the output.

2. min_dist: This value ranges from 0.0 to 1.0. It refers to the packing of data in the final projection. If data is packed too tightly, then it is harder to split clusters, while very loose packing might lead to loss of shape and cluster formations. Thus, it is important we choose a good value for min_dist. 

3. n_components: While n_components does not affect the projection in UMAP, it changes the target dimensionality for our reduction. By default n_components =2, i.e UMAP will always reduce data to 2 dimensions. But in many cases data can also be viewed better in 3 dimensions. This parameter can be utilized for such cases.


To demonstrate the effect of the first two parameters let us consider arbitrary values:

### min_dist = 0.99 and n_neighbors = 4 


```r
custom.config = umap.defaults # Set of configurations
custom.config$min_dist = 0.99 # change min_dist and n_neighbors
custom.config$n_neighbors = 4

mnist.umap.config = umap(mnist_data, config=custom.config)
```


The resultant projection is shown below:



```r
dfc <- data.frame(mnist.umap.config$layout[,1], mnist.umap.config$layout[,2], mnist_labels)
colnames(dfc) <- c("X","Y", "Label")

ggplot(dfc, aes(x =X, y= Y))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

As we can see, there are no separate clusters formed. This is evident, since we considered a lower number of neighbors and packed it loosely i.e we looked more from a local structure perspective and did not bind the points together.


If now, we change the n_neighbors to a higher number, say n_neighbors = 10

### min_dist = 0.99 and n_neighbors = 10


```r
custom.config = umap.defaults # Set of configurations
custom.config$min_dist = 0.99 # change min_dist and n_neighbors
custom.config$n_neighbors = 10

mnist.umap.config2 = umap(mnist_data, config=custom.config)

dfc <- data.frame(mnist.umap.config2$layout[,1], mnist.umap.config2$layout[,2], mnist_labels)
colnames(dfc) <- c("X","Y", "Label")


ggplot(dfc, aes(x =X, y= Y))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />

This has a good effect, as we include more neighbors, more clusters are formed. However, the boundaries are very close to each other since our min_dist value is still high. UMAP still does a good job of separating the clusters:


```r
dfc <- data.frame(mnist.umap.config2$layout[,1], mnist.umap.config2$layout[,2], mnist_labels)
colnames(dfc) <- c("X","Y", "Label")


ggplot(dfc, aes(x =X, y= Y, color =Label))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-12-1.png" width="672" style="display: block; margin: auto;" />

Instead of varying n_neighbors, if we change the min_dist to a lower value, say min_dist = 0.5; the packing becomes loose, but the clusters are not discernable. Thus, a lower n_neighbors value is not a good idea if we have a large dataset.

### min_dist = 0.5 and n_neighbors = 4


```r
custom.config = umap.defaults # Set of configurations
custom.config$min_dist = 0.5 # change min_dist and n_neighbors
custom.config$n_neighbors = 4

mnist.umap.config3 = umap(mnist_data, config=custom.config)
```


```r
dfc <- data.frame(mnist.umap.config3$layout[,1], mnist.umap.config3$layout[,2], mnist_labels)
colnames(dfc) <- c("X","Y", "Label")


ggplot(dfc, aes(x =X, y= Y))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-14-1.png" width="672" style="display: block; margin: auto;" />

If we add color to Labels and check the output, we can notice that the groups are actually separate, but there is no clear boundary.


```r
dfc <- data.frame(mnist.umap.config3$layout[,1], mnist.umap.config3$layout[,2], mnist_labels)
colnames(dfc) <- c("X","Y", "Label")


ggplot(dfc, aes(x =X, y= Y, color =Label))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-15-1.png" width="672" style="display: block; margin: auto;" />



## Iris Dataset

```r
iris.data = iris[, grep("Sepal|Petal", colnames(iris))] 
iris.labels = iris[, "Species"] 
```

Function call to umap in the default case


```r
iris.umap = umap(iris.data)
iris.umap
```

It is an umap embedding of 150 items, which refer to our data points and 2 dimensions. Thus, the umap algorithm has reduced our data from 4 to 2 dimensional data.

If you now plot the embedding created by UMAP, we get the following result:



```r
df_iris <- data.frame(iris.umap$layout[,1], iris.umap$layout[,2], iris.labels)
colnames(df_iris) <- c("X","Y", "Label")

ggplot(df_iris, aes(x =X, y= Y))+ geom_point()
```

<img src="umap_viz_files/figure-html/unnamed-chunk-18-1.png" width="672" style="display: block; margin: auto;" />


We see that there are 2 distinct clusters formed in the embedded data. We will now visually assess the accuracy of this clustering by coloring the points according to their true labels: 




```r
df_iris_1 <- data.frame(iris.umap$layout[,1], iris.umap$layout[,2], iris.labels)
colnames(df_iris_1) <- c("X","Y", "Label")

ggplot(df_iris_1, aes(x =X, y= Y, color= Label))+ geom_point()
```

<img src="umap_viz_files/figure-html/unnamed-chunk-19-1.png" width="672" style="display: block; margin: auto;" />



On clustering by coloring the points, we infact realize that there are 3 clusters and not 2.


For our base case, the default values of UMAP didn't work out well in this case. We thus go for parameter tuning.

As discussed before, we can check the default values of UMAP as follows:




```r
custom.config = umap.defaults 
custom.config
```

## Analysis of Iris using UMAP

To demonstrate the effect of n_neighbors and min_dist, let us consider arbitrary values:

### min_dist = 0.10 and n_neighbors = 20


```r
custom.config = umap.defaults # Set of configurations
custom.config$min_dist = 0.10 # change min_dist and n_neighbors
custom.config$n_neighbors = 20

iris.umap.config = umap(iris.data, config=custom.config)
```


The resultant projection is shown below:


```r
dfc_iris <- data.frame(iris.umap.config$layout[,1], iris.umap.config$layout[,2], iris.labels)
colnames(dfc_iris) <- c("X","Y", "Label")


ggplot(dfc_iris, aes(x =X, y= Y))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-22-1.png" width="672" style="display: block; margin: auto;" />

If we add color to the same,


```r
dfc_iris <- data.frame(iris.umap.config$layout[,1], iris.umap.config$layout[,2], iris.labels)
colnames(dfc_iris) <- c("X","Y", "Label")


ggplot(dfc_iris, aes(x =X, y= Y, color = Label))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-23-1.png" width="672" style="display: block; margin: auto;" />



With an increase in the number of neighbors, we observe a close packing of similar clusters. More neighbors implies merging of clusters ( observe versicolor and verginica). Some clusters are still not well connected. For low number of neighbours, data is over-clustered. 

Say, now we increase the min_dist parameter to 0.5

### min_dist = 0.5 and n_neighbors = 20


```r
custom.config = umap.defaults # Set of configurations
custom.config$min_dist = 0.5 # change min_dist 
custom.config$n_neighbors = 20

iris.umap.config2 = umap(iris.data, config=custom.config)

dfc_iris <- data.frame(iris.umap.config2$layout[,1], iris.umap.config2$layout[,2], iris.labels)
colnames(dfc_iris) <- c("X","Y", "Label")


ggplot(dfc_iris, aes(x =X, y= Y))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-24-1.png" width="672" style="display: block; margin: auto;" />

If we add color,



```r
dfc_iris <- data.frame(iris.umap.config2$layout[,1], iris.umap.config2$layout[,2], iris.labels)
colnames(dfc_iris) <- c("X","Y", "Label")


ggplot(dfc_iris, aes(x =X, y= Y, color =Label))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-25-1.png" width="672" style="display: block; margin: auto;" />


 Finer separation of data has been achieved now (observe virginica and versicolor). By reducing the density of packing, the amount of points which can be wrongly classified can be reduced. However, the downside is that the weak inter cluster connection can be misrepresented as separate clusters which infact might even loosen up the third tightly classified cluster ( setosa).


### High min_dist and low n_neighbors 


```r
custom.config = umap.defaults # Set of configurations
custom.config$min_dist = 0.9 # change min_dist and n_neighbors
custom.config$n_neighbors = 3

iris.umap.config3 = umap(iris.data, config=custom.config)

dfc_iris <- data.frame(iris.umap.config3$layout[,1], iris.umap.config3$layout[,2], iris.labels)
colnames(dfc_iris) <- c("X","Y", "Label")


ggplot(dfc_iris, aes(x =X, y= Y))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-26-1.png" width="672" style="display: block; margin: auto;" />


If we add color,


```r
dfc_iris <- data.frame(iris.umap.config3$layout[,1], iris.umap.config3$layout[,2], iris.labels)
colnames(dfc_iris) <- c("X","Y", "Label")


ggplot(dfc_iris, aes(x =X, y= Y, color =Label))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-27-1.png" width="672" style="display: block; margin: auto;" />


Two different labels start merging. There are a few outliers with respect to setosa label here as well. We observe an overlap of clusters in this case. 


### Low min_dist and high n_neighbors

```r
custom.config = umap.defaults # Set of configurations
custom.config$min_dist = 0.15 # change min_dist and n_neighbors
custom.config$n_neighbors = 35

iris.umap.config4 = umap(iris.data, config=custom.config)

dfc_iris <- data.frame(iris.umap.config4$layout[,1], iris.umap.config4$layout[,2], iris.labels)
colnames(dfc_iris) <- c("X","Y", "Label")


ggplot(dfc_iris, aes(x =X, y= Y))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-28-1.png" width="672" style="display: block; margin: auto;" />


If we add color,


```r
dfc_iris <- data.frame(iris.umap.config4$layout[,1], iris.umap.config4$layout[,2], iris.labels)
colnames(dfc_iris) <- c("X","Y", "Label")


ggplot(dfc_iris, aes(x =X, y= Y, color =Label))+ geom_point(alpha =0.5)
```

<img src="umap_viz_files/figure-html/unnamed-chunk-29-1.png" width="672" style="display: block; margin: auto;" />


Here, too we observe an overlap of clusters


### 3D Visualisation using UMAP

We can always choose the number of dimensions we need for the projection. While we usually plot data on 2 dimensions to visualize it better on a plot, we can always create 3 dimensional visualization by projecting it on 3 components. This can be done by changing the n_components parameter to 3 and proceeding to plot it using plotly (for 3-D plot).

```r
custom.config = umap.defaults # Set of configurations
custom.config$n_components = 3 # change min_dist and n_neighbors

iris.umap.config5 = umap(iris.data, config=custom.config)



df <- data.frame(iris.umap$layout[,1], iris.umap$layout[,2])
colnames(df) <- c("X","Y")

dfc <- data.frame(iris.umap.config5$layout[,1], iris.umap.config5$layout[,2], iris.umap.config5$layout[,3], iris.labels)
colnames(dfc) <- c("X","Y", "Z", "Label" )


plot_ly(dfc, x=dfc$X, y=dfc$Y, z=dfc$Z, color = ~Label, type="scatter3d", mode="markers")
```

```{=html}
<div id="htmlwidget-17cc0449c259fc1929f0" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-17cc0449c259fc1929f0">{"x":{"visdat":{"52763769569c":["function () ","plotlyVisDat"]},"cur_data":"52763769569c","attrs":{"52763769569c":{"x":[16.5200380611963,15.2704178779652,14.9452427880337,15.1167474147139,16.3484261578853,17.4768347277371,15.0673983861829,16.2698082907783,14.7561979933807,15.3008482227241,17.1195760713613,15.866674327562,15.0590772712025,14.7763834268856,17.3969381414682,17.5107692854426,17.4110137030166,16.5780930465176,17.4311135634739,17.3682643749664,16.9894205312418,17.1282198839518,15.4560727997592,16.4863548299131,15.8092968069282,15.5467227521318,16.4852904114778,16.7282211841145,16.5498518837504,15.2919564762085,15.3552780946432,16.8250811708338,17.6429584938794,17.7146326585451,15.3755283458991,15.8478539487795,16.9089276905891,16.471915247974,14.7324382158097,16.3743533753205,16.2713179390146,14.7139204126405,14.891936202097,16.6866190953172,17.3024272770345,15.1277015644495,17.4371964509525,14.9636237613955,17.0462879375589,16.2418526531502,-6.68455280490821,-7.37845288461038,-6.57586650231007,-7.75058847287698,-7.08589686587606,-8.28403068391804,-7.87059368900718,-7.62905729926332,-6.87432602176569,-7.98247060736216,-7.64440376655557,-8.03736904667763,-7.6345130521811,-7.87474946085913,-7.89380540053508,-7.01861308346689,-8.29386665690309,-7.90812704653645,-7.98191313546272,-7.70129233653639,-8.48162993175519,-7.76615549951028,-8.11211472328224,-7.71086072551949,-7.27690149345094,-7.0986237570982,-6.71947997015533,-6.67094160078971,-7.94032596658506,-7.65506567345734,-7.57814312958468,-7.58291901442883,-7.79658350051324,-8.58749811406915,-8.45658781420099,-8.08603795530336,-6.8895591849017,-7.75449588734449,-8.3880694427996,-8.13471399871753,-8.18899460918762,-7.85916241089225,-7.99091984576375,-7.53973888456492,-8.29367604379565,-8.36680297280508,-8.33561208631256,-7.60100587519477,-7.51373400884773,-8.21799769765855,-8.51227707819224,-9.03625847417043,-8.25307778490989,-8.72064389632509,-8.64669604753358,-7.80532274740352,-8.34149854341541,-7.96751674058065,-8.60578051619621,-8.15402693303412,-8.84385781040626,-8.64639863161483,-8.40627568181242,-9.18242926981265,-9.25948874586578,-8.85008774282984,-8.6468288709245,-7.74535116122796,-7.78469874942544,-8.32602499863907,-8.29464628825236,-9.24264216327122,-7.69518938944026,-8.20081761284687,-8.50879769753285,-8.11623387356273,-8.21304107904071,-8.56987383838822,-8.50004643791265,-8.15116056484135,-7.65355920155266,-7.85868620564735,-8.55058576445659,-8.28711809342646,-8.62500400136599,-7.73003168421593,-8.83553653515919,-8.91529765604592,-8.54124831724889,-8.4027527897522,-8.30589552671796,-8.69081737319325,-9.16416097622158,-8.47834086223737,-8.46564952529837,-8.62720597183678,-8.386594724932,-8.82303804149362,-8.97274410815435,-8.75302386338688],"y":[1.76788116541839,1.20734697681566,0.753570233823574,0.634850339467847,1.50343441911618,1.98916452158756,0.46729457350423,1.48338246290495,0.513808793780493,1.10744493339856,2.19081949178557,0.915699788559805,1.10997332049123,0.413897069659138,2.3342076241058,2.34383196347338,2.16631299982626,1.67637230607391,2.24446450724018,1.82224078752799,1.9882926521414,1.67755743220091,0.579314497579266,1.13667445375185,1.00296004967728,1.13318067235943,1.23053060144702,1.88181800740589,2.10154249993664,0.701403499971774,0.894593056139346,2.3337583995556,1.99165298902281,2.47318128933086,1.23654318887145,1.50789694607275,2.3685552329205,1.6282731309334,0.413023682046237,1.73753273066959,1.84809895219819,0.665108506089552,0.319618193467532,1.35197090876484,1.58091274340477,1.00208868681221,1.73187580315012,0.529986188702234,1.92786844592434,1.37410951992243,0.570639386635744,0.590069004459071,0.559274069722841,0.59888927896838,0.348593472489592,0.169362341265381,0.434735891569742,0.547799297758614,0.604126500148431,0.533956059453449,0.604028454340425,0.0263381612437479,0.213177808673911,0.011996247570017,0.261392227650409,0.573798296503965,0.153218882445709,0.0925767362627339,-0.333097368635584,0.377847044077429,0.155654946078979,0.00125939559886512,-0.353980135254864,0.056947491580934,0.356756174592525,0.577179904233996,0.559855203358886,0.368436664639969,0.115535747604763,0.302930874500478,0.188159334148048,0.504679051923564,0.0596004999874826,-0.284702421002356,0.46196154452743,0.438008137903061,0.701719067537871,-0.316756855987961,-0.0453297014521399,0.665456784833543,0.400765423245954,0.320421089203571,-0.0442322791806751,0.589700188533597,0.216838636566743,0.0120402916426419,-0.0200821961476341,0.131687830429321,0.428645811140875,0.144847047586699,-2.38272116691574,-0.111424568552608,-2.94996540734108,-1.27666876819211,-1.8913193175204,-3.34201091521674,0.661602654174914,-3.51638222102924,-1.40673857458483,-2.73587964988252,-1.72607865390626,-1.28213491143193,-1.9604450058306,-0.284531306875459,-0.112637580128431,-1.86409983256241,-1.38045687219295,-3.16117418681016,-3.28812537939621,-0.423744324225413,-2.5726522022419,-0.125353879035499,-3.25279639360248,-0.297473102169533,-2.27390782522412,-3.33917894312161,-0.0951859205640495,0.125373513763934,-1.48700072040456,-3.27827986659979,-3.46089942086607,-3.06085939612408,-1.60842128439313,-0.247237505516949,-0.70907419537191,-3.42342757473757,-2.21142354598505,-1.5143641101073,0.0745950917045874,-2.16934007202633,-2.0968762704621,-1.96216500224781,-0.177181269656037,-2.52333197027226,-2.44309108829203,-1.91610534840189,-0.438908989686195,-1.6805404093272,-2.02993607480427,0.00133318018427131],"z":[-4.18140658443917,-4.2966897827929,-4.36544541461265,-4.50814950207412,-4.06308597934106,-4.84888179795124,-4.45734401684979,-4.29196872465946,-4.76815523938491,-4.49473341647027,-4.63470573465611,-4.4816778997744,-4.58339228247071,-4.71910541085613,-4.75584365408746,-4.76440439812439,-4.88466986875545,-4.22374582098857,-4.77663260339512,-4.62757041165667,-4.34461527068391,-4.5261349588044,-4.18353757249563,-4.4485658274084,-4.624614613857,-4.59594785036015,-4.39335186673994,-4.46256987992002,-4.30295561390233,-4.49862636059115,-4.64382333944393,-4.24798370876766,-4.49393450063746,-4.8486900765309,-4.52342442662328,-4.18785937988959,-4.49186528134714,-4.1521926139782,-4.71588194799695,-4.36487161696292,-4.39024074852131,-4.79163335804656,-4.48159987858581,-4.55986519997931,-4.80769698754442,-4.46564843506035,-4.57340743264343,-4.30671269917679,-4.66151537163676,-4.23749495899678,1.90034290692978,1.72390564701917,2.02174703902174,-0.830481692674551,1.69246918363696,0.123318638457339,1.73531046747627,-1.47376290668444,1.64110648653537,-0.875492904592785,-1.55779394608901,0.365224071082551,-0.772843369610932,1.4865291552684,-0.835415377015757,1.80779406370612,0.331067533117095,-0.585623070122663,1.72590874012338,-0.892414997520692,1.87395626837901,-0.0156099313830466,2.28878610353322,1.44530125742124,1.39346820133857,1.64435522296037,1.90558161205448,2.15049542873953,1.16435802383623,-1.04115074034389,-1.11315386843162,-1.31251270922098,-0.612215231771475,2.45952908397218,-0.0726234850215607,1.60628206286165,2.1141444994986,1.48022462274433,-0.170633941080189,-0.807189775832537,-0.187420422461974,1.33365869615479,-0.526013095066316,-1.52813079897312,-0.372336324474781,-0.201654127542231,-0.259751495465803,1.07945981209962,-1.36661576241662,-0.473773249488676,5.21391872034734,2.29876011154193,5.11338788101904,4.37935287440313,5.15084377723785,4.93074803272251,-0.333713719758413,4.8682567498286,4.58585263310444,5.29354955491085,4.24492068728194,4.10670935321252,4.73283886564321,2.41137996248832,2.14563424869567,4.75227346376956,4.49738903427695,5.19900382081911,5.05330117096137,2.22049085096187,5.00250659158415,2.11768227049487,5.01182102617069,2.357430798877,5.03307359493977,4.96237040790675,2.15514867984058,2.25206804207795,4.81086214597876,5.02939448026889,5.02381199481648,5.10262602940921,4.93794451607332,2.5983410839739,3.19502573113864,5.16118523073814,5.03645521609099,4.48417895086475,1.98913269326814,4.59662265026185,4.92739595208007,4.49609762703996,2.29153226312237,5.30601918468377,5.14347554877958,4.54787574559692,2.52156116132429,4.2600253496858,4.93566971084865,2.29292596438667],"mode":"markers","color":{},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":[]},"yaxis":{"title":[]},"zaxis":{"title":[]}},"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[16.5200380611963,15.2704178779652,14.9452427880337,15.1167474147139,16.3484261578853,17.4768347277371,15.0673983861829,16.2698082907783,14.7561979933807,15.3008482227241,17.1195760713613,15.866674327562,15.0590772712025,14.7763834268856,17.3969381414682,17.5107692854426,17.4110137030166,16.5780930465176,17.4311135634739,17.3682643749664,16.9894205312418,17.1282198839518,15.4560727997592,16.4863548299131,15.8092968069282,15.5467227521318,16.4852904114778,16.7282211841145,16.5498518837504,15.2919564762085,15.3552780946432,16.8250811708338,17.6429584938794,17.7146326585451,15.3755283458991,15.8478539487795,16.9089276905891,16.471915247974,14.7324382158097,16.3743533753205,16.2713179390146,14.7139204126405,14.891936202097,16.6866190953172,17.3024272770345,15.1277015644495,17.4371964509525,14.9636237613955,17.0462879375589,16.2418526531502],"y":[1.76788116541839,1.20734697681566,0.753570233823574,0.634850339467847,1.50343441911618,1.98916452158756,0.46729457350423,1.48338246290495,0.513808793780493,1.10744493339856,2.19081949178557,0.915699788559805,1.10997332049123,0.413897069659138,2.3342076241058,2.34383196347338,2.16631299982626,1.67637230607391,2.24446450724018,1.82224078752799,1.9882926521414,1.67755743220091,0.579314497579266,1.13667445375185,1.00296004967728,1.13318067235943,1.23053060144702,1.88181800740589,2.10154249993664,0.701403499971774,0.894593056139346,2.3337583995556,1.99165298902281,2.47318128933086,1.23654318887145,1.50789694607275,2.3685552329205,1.6282731309334,0.413023682046237,1.73753273066959,1.84809895219819,0.665108506089552,0.319618193467532,1.35197090876484,1.58091274340477,1.00208868681221,1.73187580315012,0.529986188702234,1.92786844592434,1.37410951992243],"z":[-4.18140658443917,-4.2966897827929,-4.36544541461265,-4.50814950207412,-4.06308597934106,-4.84888179795124,-4.45734401684979,-4.29196872465946,-4.76815523938491,-4.49473341647027,-4.63470573465611,-4.4816778997744,-4.58339228247071,-4.71910541085613,-4.75584365408746,-4.76440439812439,-4.88466986875545,-4.22374582098857,-4.77663260339512,-4.62757041165667,-4.34461527068391,-4.5261349588044,-4.18353757249563,-4.4485658274084,-4.624614613857,-4.59594785036015,-4.39335186673994,-4.46256987992002,-4.30295561390233,-4.49862636059115,-4.64382333944393,-4.24798370876766,-4.49393450063746,-4.8486900765309,-4.52342442662328,-4.18785937988959,-4.49186528134714,-4.1521926139782,-4.71588194799695,-4.36487161696292,-4.39024074852131,-4.79163335804656,-4.48159987858581,-4.55986519997931,-4.80769698754442,-4.46564843506035,-4.57340743264343,-4.30671269917679,-4.66151537163676,-4.23749495899678],"mode":"markers","type":"scatter3d","name":"setosa","marker":{"color":"rgba(102,194,165,1)","line":{"color":"rgba(102,194,165,1)"}},"textfont":{"color":"rgba(102,194,165,1)"},"error_y":{"color":"rgba(102,194,165,1)"},"error_x":{"color":"rgba(102,194,165,1)"},"line":{"color":"rgba(102,194,165,1)"},"frame":null},{"x":[-6.68455280490821,-7.37845288461038,-6.57586650231007,-7.75058847287698,-7.08589686587606,-8.28403068391804,-7.87059368900718,-7.62905729926332,-6.87432602176569,-7.98247060736216,-7.64440376655557,-8.03736904667763,-7.6345130521811,-7.87474946085913,-7.89380540053508,-7.01861308346689,-8.29386665690309,-7.90812704653645,-7.98191313546272,-7.70129233653639,-8.48162993175519,-7.76615549951028,-8.11211472328224,-7.71086072551949,-7.27690149345094,-7.0986237570982,-6.71947997015533,-6.67094160078971,-7.94032596658506,-7.65506567345734,-7.57814312958468,-7.58291901442883,-7.79658350051324,-8.58749811406915,-8.45658781420099,-8.08603795530336,-6.8895591849017,-7.75449588734449,-8.3880694427996,-8.13471399871753,-8.18899460918762,-7.85916241089225,-7.99091984576375,-7.53973888456492,-8.29367604379565,-8.36680297280508,-8.33561208631256,-7.60100587519477,-7.51373400884773,-8.21799769765855],"y":[0.570639386635744,0.590069004459071,0.559274069722841,0.59888927896838,0.348593472489592,0.169362341265381,0.434735891569742,0.547799297758614,0.604126500148431,0.533956059453449,0.604028454340425,0.0263381612437479,0.213177808673911,0.011996247570017,0.261392227650409,0.573798296503965,0.153218882445709,0.0925767362627339,-0.333097368635584,0.377847044077429,0.155654946078979,0.00125939559886512,-0.353980135254864,0.056947491580934,0.356756174592525,0.577179904233996,0.559855203358886,0.368436664639969,0.115535747604763,0.302930874500478,0.188159334148048,0.504679051923564,0.0596004999874826,-0.284702421002356,0.46196154452743,0.438008137903061,0.701719067537871,-0.316756855987961,-0.0453297014521399,0.665456784833543,0.400765423245954,0.320421089203571,-0.0442322791806751,0.589700188533597,0.216838636566743,0.0120402916426419,-0.0200821961476341,0.131687830429321,0.428645811140875,0.144847047586699],"z":[1.90034290692978,1.72390564701917,2.02174703902174,-0.830481692674551,1.69246918363696,0.123318638457339,1.73531046747627,-1.47376290668444,1.64110648653537,-0.875492904592785,-1.55779394608901,0.365224071082551,-0.772843369610932,1.4865291552684,-0.835415377015757,1.80779406370612,0.331067533117095,-0.585623070122663,1.72590874012338,-0.892414997520692,1.87395626837901,-0.0156099313830466,2.28878610353322,1.44530125742124,1.39346820133857,1.64435522296037,1.90558161205448,2.15049542873953,1.16435802383623,-1.04115074034389,-1.11315386843162,-1.31251270922098,-0.612215231771475,2.45952908397218,-0.0726234850215607,1.60628206286165,2.1141444994986,1.48022462274433,-0.170633941080189,-0.807189775832537,-0.187420422461974,1.33365869615479,-0.526013095066316,-1.52813079897312,-0.372336324474781,-0.201654127542231,-0.259751495465803,1.07945981209962,-1.36661576241662,-0.473773249488676],"mode":"markers","type":"scatter3d","name":"versicolor","marker":{"color":"rgba(252,141,98,1)","line":{"color":"rgba(252,141,98,1)"}},"textfont":{"color":"rgba(252,141,98,1)"},"error_y":{"color":"rgba(252,141,98,1)"},"error_x":{"color":"rgba(252,141,98,1)"},"line":{"color":"rgba(252,141,98,1)"},"frame":null},{"x":[-8.51227707819224,-9.03625847417043,-8.25307778490989,-8.72064389632509,-8.64669604753358,-7.80532274740352,-8.34149854341541,-7.96751674058065,-8.60578051619621,-8.15402693303412,-8.84385781040626,-8.64639863161483,-8.40627568181242,-9.18242926981265,-9.25948874586578,-8.85008774282984,-8.6468288709245,-7.74535116122796,-7.78469874942544,-8.32602499863907,-8.29464628825236,-9.24264216327122,-7.69518938944026,-8.20081761284687,-8.50879769753285,-8.11623387356273,-8.21304107904071,-8.56987383838822,-8.50004643791265,-8.15116056484135,-7.65355920155266,-7.85868620564735,-8.55058576445659,-8.28711809342646,-8.62500400136599,-7.73003168421593,-8.83553653515919,-8.91529765604592,-8.54124831724889,-8.4027527897522,-8.30589552671796,-8.69081737319325,-9.16416097622158,-8.47834086223737,-8.46564952529837,-8.62720597183678,-8.386594724932,-8.82303804149362,-8.97274410815435,-8.75302386338688],"y":[-2.38272116691574,-0.111424568552608,-2.94996540734108,-1.27666876819211,-1.8913193175204,-3.34201091521674,0.661602654174914,-3.51638222102924,-1.40673857458483,-2.73587964988252,-1.72607865390626,-1.28213491143193,-1.9604450058306,-0.284531306875459,-0.112637580128431,-1.86409983256241,-1.38045687219295,-3.16117418681016,-3.28812537939621,-0.423744324225413,-2.5726522022419,-0.125353879035499,-3.25279639360248,-0.297473102169533,-2.27390782522412,-3.33917894312161,-0.0951859205640495,0.125373513763934,-1.48700072040456,-3.27827986659979,-3.46089942086607,-3.06085939612408,-1.60842128439313,-0.247237505516949,-0.70907419537191,-3.42342757473757,-2.21142354598505,-1.5143641101073,0.0745950917045874,-2.16934007202633,-2.0968762704621,-1.96216500224781,-0.177181269656037,-2.52333197027226,-2.44309108829203,-1.91610534840189,-0.438908989686195,-1.6805404093272,-2.02993607480427,0.00133318018427131],"z":[5.21391872034734,2.29876011154193,5.11338788101904,4.37935287440313,5.15084377723785,4.93074803272251,-0.333713719758413,4.8682567498286,4.58585263310444,5.29354955491085,4.24492068728194,4.10670935321252,4.73283886564321,2.41137996248832,2.14563424869567,4.75227346376956,4.49738903427695,5.19900382081911,5.05330117096137,2.22049085096187,5.00250659158415,2.11768227049487,5.01182102617069,2.357430798877,5.03307359493977,4.96237040790675,2.15514867984058,2.25206804207795,4.81086214597876,5.02939448026889,5.02381199481648,5.10262602940921,4.93794451607332,2.5983410839739,3.19502573113864,5.16118523073814,5.03645521609099,4.48417895086475,1.98913269326814,4.59662265026185,4.92739595208007,4.49609762703996,2.29153226312237,5.30601918468377,5.14347554877958,4.54787574559692,2.52156116132429,4.2600253496858,4.93566971084865,2.29292596438667],"mode":"markers","type":"scatter3d","name":"virginica","marker":{"color":"rgba(141,160,203,1)","line":{"color":"rgba(141,160,203,1)"}},"textfont":{"color":"rgba(141,160,203,1)"},"error_y":{"color":"rgba(141,160,203,1)"},"error_x":{"color":"rgba(141,160,203,1)"},"line":{"color":"rgba(141,160,203,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```



## References:

1) Uniform Manifold Approximation and Projection in R: https://umap-learn.readthedocs.io/en/latest/

2) Uniform Manifold Approximation and Projection for Dimension Reduction:  https://umap-learn.readthedocs.io/en/latest/

3) MNIST dataset: https://datahub.io/machine-learning/mnist_784#resource-mnist_784




