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
<div id="htmlwidget-d6c7a765ed85b42c83c2" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-d6c7a765ed85b42c83c2">{"x":{"visdat":{"38fe11e276e4":["function () ","plotlyVisDat"]},"cur_data":"38fe11e276e4","attrs":{"38fe11e276e4":{"x":[13.8121578643682,12.5566185746569,12.4948344016622,12.3849592723223,13.723579529129,14.5758787954857,12.7561143911126,13.5933726026208,12.3902307719118,12.4131855753828,14.2591004057755,13.0136991102706,12.4552508209844,12.572596423469,14.4639741650979,14.6242425792845,14.3388598392924,13.6551598838426,14.2933725977433,14.6281776463333,13.8607509294728,14.5152807010776,13.1064433408276,13.5307940218486,12.9082049060809,12.3148261876195,13.5695930074017,13.9693417276317,13.6809067458826,12.5709429244156,12.3584141692026,13.7847693713654,14.8270292843955,14.7025755190871,12.4254765366015,13.3285450982454,13.9578767428722,13.6336711582968,12.3377962003,13.7971684156603,13.5586609214334,12.2771694269348,12.6385932846858,13.8146625927908,14.5411727491688,12.4677012601784,14.756221946324,12.5079599905215,14.2449179125671,13.352076063042,-7.36153664527532,-7.10623189029042,-7.35473410790472,-5.4750181268726,-7.04721150451443,-6.05445019740175,-7.36225014190672,-5.39171877150382,-7.08734832311141,-5.66650460391516,-5.29287404561178,-6.02227191649367,-5.17713756542136,-7.01540629709977,-5.30631332743886,-7.20006679487844,-6.12006718172142,-5.23450485027368,-6.81387277073767,-5.46013235117493,-7.68779316828611,-5.5346762732865,-7.19230502496095,-6.83274678190861,-6.83969662575974,-7.0236641606101,-7.26843402452166,-7.39293862622029,-6.79881647274359,-5.17894010529982,-5.13166884370656,-5.22224922003748,-5.2886376346191,-7.42158047839975,-6.03758376264499,-7.22476262495404,-7.25391662727767,-6.67971449713231,-5.79867372038863,-5.62364061341747,-6.03212681087835,-6.93680163111135,-5.29561365229052,-5.37905625734217,-5.63939761360822,-5.76671496013567,-5.65903274035383,-6.63023228231964,-5.29921655135279,-5.40225444796753,-7.18829713061538,-7.98904421263893,-6.93528070871611,-7.32782547321933,-7.24876815578294,-6.88235542331649,-6.03146111335257,-7.03222557905399,-7.39058212456879,-6.93162640411351,-6.97987250977684,-7.20828493852684,-6.99341495949017,-7.98568176216187,-8.11620308841414,-7.06992050851917,-7.18722674379634,-6.91303506278734,-6.89405662953303,-7.05709760213763,-7.01680002915099,-8.15904093870066,-6.77699861511054,-7.34802831057034,-6.84509486451152,-6.96117422533117,-7.39686429804188,-7.55228799324447,-7.46266294653305,-6.9520541207802,-6.9856000168214,-6.84071126545261,-7.16590014289819,-7.21653842399065,-7.32716317656963,-7.09513993265427,-7.32218029758142,-7.15745788322055,-7.66472750427485,-6.7962799305455,-7.23964147082257,-6.69728947770208,-7.92753928953192,-7.0055847549639,-7.07888552918911,-6.81640904278409,-7.24436079353062,-6.88491419975765,-7.27403834707078,-7.74874278773642],"y":[1.02397476567686,-0.567421286047145,-0.435043592918402,-0.612609978455118,1.05184705773421,1.68592975264312,-0.198040904484283,0.780139694922116,-0.762823885859453,-0.513740160641438,1.62581062928858,0.234325307519616,-0.628029082088913,-0.585998913464958,1.6488850170626,1.54688416309006,1.81758731327483,1.02757531265436,1.47504446498101,1.65969569212409,1.34030713132472,1.58553753373289,0.163529619574196,0.672459394957424,0.192875191062707,-0.463138974852975,0.721865024504781,1.21721844636453,1.15845053424816,-0.299572636120625,-0.236273506189499,1.30931806176057,1.7654101334544,1.6985429789211,-0.456944699812852,0.302827306477955,1.4853375602038,0.904686361267992,-0.779196637395603,0.916790898348356,0.960620596483703,-0.972889511196989,-0.485228917918434,0.746564255157637,1.51322113280271,-0.868997133288326,1.82531988720836,-0.308579317970664,1.86418875997619,0.612718421667121,1.37055086772055,1.22504320951378,1.37827606515138,2.23579905715718,1.06763521595521,1.58745428694735,0.917590427610034,2.55997960625234,1.32252778539473,2.14847286354544,2.68299955401552,1.48875731785903,2.32677590182945,0.802046902753949,2.42329953254726,1.43724473045237,1.54540649011749,2.02612204795871,0.417899258721111,2.36521248158771,0.185256465457153,1.89636867889233,-0.298719974894434,0.999493808280078,1.35999104792419,1.40508616590419,1.3877433281043,0.98633667991713,1.12928775780034,2.6953145883693,2.67926439391362,2.664892212159,2.13611635289907,-0.474149290414082,1.74460367934585,0.887651894977381,1.4123194643855,0.699156818407363,1.57875198837227,2.12740899313542,1.67881562181836,1.14288883283846,2.11182465728387,2.57893344323175,1.70622558797109,1.54481446986901,1.62260611750036,1.36996446223672,2.51987669483156,1.73855550163587,-2.97890810989539,-0.396492641672701,-3.67600970189454,-2.00800021276985,-2.83832236250486,-4.07661034710218,1.899362295724,-4.07559260731435,-2.35439981933008,-3.43573793996816,-1.92809902589161,-1.74147154527487,-2.63484020781644,-0.425449904364044,-0.437109450286394,-2.27178434167866,-2.10059344270228,-3.96040698104247,-4.25821690607506,-0.325031928738914,-3.14872867261326,-0.315368574057206,-4.39450026222652,-0.216942399552104,-3.0400194636249,-3.85190368386112,0.0560417516732384,0.00996716453396207,-2.43275851612874,-3.77216779119965,-4.12330289714002,-4.13530461688252,-2.53097308523715,-0.566051573968658,-1.23188770513488,-4.02550404667318,-2.66726558343547,-2.12384039857128,0.180321880167587,-2.67742817721464,-2.90552385292241,-2.39250516026124,-0.329772194769551,-3.23582846653718,-3.25082551002189,-2.30859807502625,-0.160766110469938,-1.97092337537869,-2.30786305459491,-0.0127956752813084],"z":[-1.58186238122201,-1.05581502493324,-1.39804421752362,-1.47679273139815,-1.67399754625466,-0.660227960579674,-1.54078072185444,-1.58691672284277,-1.5763279196228,-1.07206167955058,-0.656152235295735,-1.25083253436615,-1.15723672939609,-1.77051855504044,-0.211583080828016,-0.303172746844047,-0.386402185576532,-1.41369593883279,-0.520129812370682,-0.905055878316622,-1.11028621108706,-1.03426752505158,-1.71703308542378,-1.084962580336,-1.07033633443545,-0.828320039493734,-1.07143232994472,-1.38419192233119,-1.37479716422428,-1.18860782238828,-0.882184728942324,-1.15187558040464,-0.487987176172805,-0.282434057053523,-0.962360241591115,-1.47603042463016,-1.01121292243992,-1.74157633245089,-1.78389677643741,-1.32457827288079,-1.97683828453164,-1.56044864276005,-1.65500679227084,-1.12535779938992,-0.833442503274033,-1.05272042470981,-0.97531639349078,-1.60994152550503,-0.632903519404393,-1.5151047102158,1.19706235016903,0.390599391643291,1.18811182121706,-1.87100805228775,0.732280965648653,-1.30743291932943,0.298707420588048,-2.12901186846146,0.759419959370257,-1.84127139600017,-2.18524932269361,-0.897218563679385,-1.58184272898196,-0.163852798076601,-1.67347296588741,0.890627875440911,-1.19699078389626,-1.54646789403243,0.233553782178637,-1.7509295127727,0.168254723731345,-0.996222966347511,0.668296983055444,-0.0175867001088879,0.331690606748702,0.606860202488165,1.11546510532609,1.36385370024088,-0.241274836996124,-1.7614136213626,-1.70610619715391,-1.76415509080199,-1.3922333829657,0.554983364927597,-1.50010714474303,0.139797327849436,1.07497415183285,0.144755816680996,-1.23031633793076,-1.84377795919234,-1.438988459347,0.0225118622682494,-1.55254607363515,-2.28008957366688,-1.6137061680653,-1.15887770795881,-1.03385773559003,-0.00901855271594387,-2.22777616613844,-1.47946992049302,2.50964828260352,0.307834305541381,2.59276667525875,1.74727944967419,2.34893995150967,2.7908518829766,-1.69732281548764,2.88949506271754,1.93393896410061,2.59759149179427,2.16438017485428,1.59818129892204,2.26966846965878,0.311422692030019,0.247073051383599,2.44223543424972,1.83693014760633,2.6174509025804,2.91415476853211,0.507824409449865,2.73648748613992,0.159303803166467,3.0270286293176,0.500744537689771,2.63992785369198,2.48972914665995,0.290276334338415,0.286241446565085,1.96521828035576,2.81528047477903,2.78620104881609,2.7473220249821,2.09553401498654,0.901264496067575,1.17547580397138,2.7582336897678,2.63887272112536,1.9473619536257,0.156299836698321,2.42297259446788,2.62218028692131,2.38899475222072,0.396943399218767,2.62201367232769,2.56648362222077,2.37292021540734,0.419513016942264,1.98734605340521,2.53360740491994,0.233401515075177],"mode":"markers","color":{},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":[]},"yaxis":{"title":[]},"zaxis":{"title":[]}},"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[13.8121578643682,12.5566185746569,12.4948344016622,12.3849592723223,13.723579529129,14.5758787954857,12.7561143911126,13.5933726026208,12.3902307719118,12.4131855753828,14.2591004057755,13.0136991102706,12.4552508209844,12.572596423469,14.4639741650979,14.6242425792845,14.3388598392924,13.6551598838426,14.2933725977433,14.6281776463333,13.8607509294728,14.5152807010776,13.1064433408276,13.5307940218486,12.9082049060809,12.3148261876195,13.5695930074017,13.9693417276317,13.6809067458826,12.5709429244156,12.3584141692026,13.7847693713654,14.8270292843955,14.7025755190871,12.4254765366015,13.3285450982454,13.9578767428722,13.6336711582968,12.3377962003,13.7971684156603,13.5586609214334,12.2771694269348,12.6385932846858,13.8146625927908,14.5411727491688,12.4677012601784,14.756221946324,12.5079599905215,14.2449179125671,13.352076063042],"y":[1.02397476567686,-0.567421286047145,-0.435043592918402,-0.612609978455118,1.05184705773421,1.68592975264312,-0.198040904484283,0.780139694922116,-0.762823885859453,-0.513740160641438,1.62581062928858,0.234325307519616,-0.628029082088913,-0.585998913464958,1.6488850170626,1.54688416309006,1.81758731327483,1.02757531265436,1.47504446498101,1.65969569212409,1.34030713132472,1.58553753373289,0.163529619574196,0.672459394957424,0.192875191062707,-0.463138974852975,0.721865024504781,1.21721844636453,1.15845053424816,-0.299572636120625,-0.236273506189499,1.30931806176057,1.7654101334544,1.6985429789211,-0.456944699812852,0.302827306477955,1.4853375602038,0.904686361267992,-0.779196637395603,0.916790898348356,0.960620596483703,-0.972889511196989,-0.485228917918434,0.746564255157637,1.51322113280271,-0.868997133288326,1.82531988720836,-0.308579317970664,1.86418875997619,0.612718421667121],"z":[-1.58186238122201,-1.05581502493324,-1.39804421752362,-1.47679273139815,-1.67399754625466,-0.660227960579674,-1.54078072185444,-1.58691672284277,-1.5763279196228,-1.07206167955058,-0.656152235295735,-1.25083253436615,-1.15723672939609,-1.77051855504044,-0.211583080828016,-0.303172746844047,-0.386402185576532,-1.41369593883279,-0.520129812370682,-0.905055878316622,-1.11028621108706,-1.03426752505158,-1.71703308542378,-1.084962580336,-1.07033633443545,-0.828320039493734,-1.07143232994472,-1.38419192233119,-1.37479716422428,-1.18860782238828,-0.882184728942324,-1.15187558040464,-0.487987176172805,-0.282434057053523,-0.962360241591115,-1.47603042463016,-1.01121292243992,-1.74157633245089,-1.78389677643741,-1.32457827288079,-1.97683828453164,-1.56044864276005,-1.65500679227084,-1.12535779938992,-0.833442503274033,-1.05272042470981,-0.97531639349078,-1.60994152550503,-0.632903519404393,-1.5151047102158],"mode":"markers","type":"scatter3d","name":"setosa","marker":{"color":"rgba(102,194,165,1)","line":{"color":"rgba(102,194,165,1)"}},"textfont":{"color":"rgba(102,194,165,1)"},"error_y":{"color":"rgba(102,194,165,1)"},"error_x":{"color":"rgba(102,194,165,1)"},"line":{"color":"rgba(102,194,165,1)"},"frame":null},{"x":[-7.36153664527532,-7.10623189029042,-7.35473410790472,-5.4750181268726,-7.04721150451443,-6.05445019740175,-7.36225014190672,-5.39171877150382,-7.08734832311141,-5.66650460391516,-5.29287404561178,-6.02227191649367,-5.17713756542136,-7.01540629709977,-5.30631332743886,-7.20006679487844,-6.12006718172142,-5.23450485027368,-6.81387277073767,-5.46013235117493,-7.68779316828611,-5.5346762732865,-7.19230502496095,-6.83274678190861,-6.83969662575974,-7.0236641606101,-7.26843402452166,-7.39293862622029,-6.79881647274359,-5.17894010529982,-5.13166884370656,-5.22224922003748,-5.2886376346191,-7.42158047839975,-6.03758376264499,-7.22476262495404,-7.25391662727767,-6.67971449713231,-5.79867372038863,-5.62364061341747,-6.03212681087835,-6.93680163111135,-5.29561365229052,-5.37905625734217,-5.63939761360822,-5.76671496013567,-5.65903274035383,-6.63023228231964,-5.29921655135279,-5.40225444796753],"y":[1.37055086772055,1.22504320951378,1.37827606515138,2.23579905715718,1.06763521595521,1.58745428694735,0.917590427610034,2.55997960625234,1.32252778539473,2.14847286354544,2.68299955401552,1.48875731785903,2.32677590182945,0.802046902753949,2.42329953254726,1.43724473045237,1.54540649011749,2.02612204795871,0.417899258721111,2.36521248158771,0.185256465457153,1.89636867889233,-0.298719974894434,0.999493808280078,1.35999104792419,1.40508616590419,1.3877433281043,0.98633667991713,1.12928775780034,2.6953145883693,2.67926439391362,2.664892212159,2.13611635289907,-0.474149290414082,1.74460367934585,0.887651894977381,1.4123194643855,0.699156818407363,1.57875198837227,2.12740899313542,1.67881562181836,1.14288883283846,2.11182465728387,2.57893344323175,1.70622558797109,1.54481446986901,1.62260611750036,1.36996446223672,2.51987669483156,1.73855550163587],"z":[1.19706235016903,0.390599391643291,1.18811182121706,-1.87100805228775,0.732280965648653,-1.30743291932943,0.298707420588048,-2.12901186846146,0.759419959370257,-1.84127139600017,-2.18524932269361,-0.897218563679385,-1.58184272898196,-0.163852798076601,-1.67347296588741,0.890627875440911,-1.19699078389626,-1.54646789403243,0.233553782178637,-1.7509295127727,0.168254723731345,-0.996222966347511,0.668296983055444,-0.0175867001088879,0.331690606748702,0.606860202488165,1.11546510532609,1.36385370024088,-0.241274836996124,-1.7614136213626,-1.70610619715391,-1.76415509080199,-1.3922333829657,0.554983364927597,-1.50010714474303,0.139797327849436,1.07497415183285,0.144755816680996,-1.23031633793076,-1.84377795919234,-1.438988459347,0.0225118622682494,-1.55254607363515,-2.28008957366688,-1.6137061680653,-1.15887770795881,-1.03385773559003,-0.00901855271594387,-2.22777616613844,-1.47946992049302],"mode":"markers","type":"scatter3d","name":"versicolor","marker":{"color":"rgba(252,141,98,1)","line":{"color":"rgba(252,141,98,1)"}},"textfont":{"color":"rgba(252,141,98,1)"},"error_y":{"color":"rgba(252,141,98,1)"},"error_x":{"color":"rgba(252,141,98,1)"},"line":{"color":"rgba(252,141,98,1)"},"frame":null},{"x":[-7.18829713061538,-7.98904421263893,-6.93528070871611,-7.32782547321933,-7.24876815578294,-6.88235542331649,-6.03146111335257,-7.03222557905399,-7.39058212456879,-6.93162640411351,-6.97987250977684,-7.20828493852684,-6.99341495949017,-7.98568176216187,-8.11620308841414,-7.06992050851917,-7.18722674379634,-6.91303506278734,-6.89405662953303,-7.05709760213763,-7.01680002915099,-8.15904093870066,-6.77699861511054,-7.34802831057034,-6.84509486451152,-6.96117422533117,-7.39686429804188,-7.55228799324447,-7.46266294653305,-6.9520541207802,-6.9856000168214,-6.84071126545261,-7.16590014289819,-7.21653842399065,-7.32716317656963,-7.09513993265427,-7.32218029758142,-7.15745788322055,-7.66472750427485,-6.7962799305455,-7.23964147082257,-6.69728947770208,-7.92753928953192,-7.0055847549639,-7.07888552918911,-6.81640904278409,-7.24436079353062,-6.88491419975765,-7.27403834707078,-7.74874278773642],"y":[-2.97890810989539,-0.396492641672701,-3.67600970189454,-2.00800021276985,-2.83832236250486,-4.07661034710218,1.899362295724,-4.07559260731435,-2.35439981933008,-3.43573793996816,-1.92809902589161,-1.74147154527487,-2.63484020781644,-0.425449904364044,-0.437109450286394,-2.27178434167866,-2.10059344270228,-3.96040698104247,-4.25821690607506,-0.325031928738914,-3.14872867261326,-0.315368574057206,-4.39450026222652,-0.216942399552104,-3.0400194636249,-3.85190368386112,0.0560417516732384,0.00996716453396207,-2.43275851612874,-3.77216779119965,-4.12330289714002,-4.13530461688252,-2.53097308523715,-0.566051573968658,-1.23188770513488,-4.02550404667318,-2.66726558343547,-2.12384039857128,0.180321880167587,-2.67742817721464,-2.90552385292241,-2.39250516026124,-0.329772194769551,-3.23582846653718,-3.25082551002189,-2.30859807502625,-0.160766110469938,-1.97092337537869,-2.30786305459491,-0.0127956752813084],"z":[2.50964828260352,0.307834305541381,2.59276667525875,1.74727944967419,2.34893995150967,2.7908518829766,-1.69732281548764,2.88949506271754,1.93393896410061,2.59759149179427,2.16438017485428,1.59818129892204,2.26966846965878,0.311422692030019,0.247073051383599,2.44223543424972,1.83693014760633,2.6174509025804,2.91415476853211,0.507824409449865,2.73648748613992,0.159303803166467,3.0270286293176,0.500744537689771,2.63992785369198,2.48972914665995,0.290276334338415,0.286241446565085,1.96521828035576,2.81528047477903,2.78620104881609,2.7473220249821,2.09553401498654,0.901264496067575,1.17547580397138,2.7582336897678,2.63887272112536,1.9473619536257,0.156299836698321,2.42297259446788,2.62218028692131,2.38899475222072,0.396943399218767,2.62201367232769,2.56648362222077,2.37292021540734,0.419513016942264,1.98734605340521,2.53360740491994,0.233401515075177],"mode":"markers","type":"scatter3d","name":"virginica","marker":{"color":"rgba(141,160,203,1)","line":{"color":"rgba(141,160,203,1)"}},"textfont":{"color":"rgba(141,160,203,1)"},"error_y":{"color":"rgba(141,160,203,1)"},"error_x":{"color":"rgba(141,160,203,1)"},"line":{"color":"rgba(141,160,203,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```



## References:

1) Uniform Manifold Approximation and Projection in R: https://umap-learn.readthedocs.io/en/latest/

2) Uniform Manifold Approximation and Projection for Dimension Reduction:  https://umap-learn.readthedocs.io/en/latest/

3) MNIST dataset: https://datahub.io/machine-learning/mnist_784#resource-mnist_784




