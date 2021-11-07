# TwitteR R Package Scraping via API Tutorial

Felix Yeung

Set Up:

In order to begin using the TwitteR package, you first need to create a Twitter Account and App so that you can get the API Access Keys & Tokens. Here are the exact steps:

1. If you don't have one, go to Twitter.com and create an account.
2. Go to apps.twitter.com and create an app *Note you will have to fill out information about why you are creating an app. The easiest way to do this is to write that you're exploring the API.
3. Once approved, you can can then finally start to create an app. 
4. After completing the steps, you will be given the opportunity to save the API Key, API Secret, Access Token, and Access Token Secret. You will need to save these to access the API. *Note if you forgot to save them you can always regenerate them after. 
5. Lastly, once you're done with these steps, you can run `install.packages("rtweet")` and you'll be all set!

Here's link to the full documentation: https://cran.r-project.org/web/packages/rtweet/rtweet.pdf


```r
library(rtweet)
library(dplyr)
library(tidyr)
library(DT)
library(ggplot2)
```


Starting with loading authenticiation token:

With the keys/tokens that you acquired in the Set Up, you can store it into a token for easy access. You are going to need to use this token often as you're utilizing the functions of rtweet.


```r
# load rtweet
library(rtweet)

# Store API Keys here. Use your own! These are fakes.
apikey <- "bgBjMmye9UQESChqld2gjkDnm"
apisecret <- "P9xUNJ2PCbxlQ3znD6bj8jOM7VPSdqeujVmCjMUxYijBYFGA2c"
accestoken <- "1283967367333191687-bMXBUIqjkbYcaZnMfacl9V0ijcYf9j"
accesssecret <- "HAN0d943eDJFzmDpUrdSCcfWftkWnpJiaiMWCEGLylIHv"

#Create a token with the create_token function

token <- create_token(
  app = "RPackageTest",
  consumer_key = apikey,
  consumer_secret = apisecret,
  access_token = accestoken,
  access_secret = accesssecret)

token
```

Introduction to useful functions:

Friends & Followers
- Friend is an account that the user follows
- Follower is account that follows the user

There's a few functions that enable you to pull friends or followers of an account given the handle.
* `get_friends()` pulls the list of IDs that are friends of the user
* `get_followers()` pulls the list of IDs that follow the user 

Here's an example


```r
#Get a list of friends for the @DataSciColumbia account
friends <- get_friends("DataSciColumbia")
multifriends <- get_friends(c("Columbia", "DataSciColumbia")) #Note you can pass multiple handles at the same time

#Get a list of followers of the @DataSciColumbia account
followers <- get_followers("DataSciColumbia")

datatable(friends)
datatable(multifriends)
datatable(followers)
```
With the list of User IDs, you can now use `lookup_users()' to find other relevant information for each UserID.


```r
users <- c(followers$user_id)
lookup_users(users[0:10]) #get information on 10 users that follow @DataSciColumbia
```

Tweets & Favorites

Next we can look at functions that can pull information on Tweets & Favorites.
- Tweets are the character messages that users can post on Twitter
- Favorites are Tweets that users have liked

Here are some useful functions:
*search_tweets()
*lookup_tweets()
*get_favorites()


```r
# search tweets for a keyword or phrase
search_tweets(q = "Columbia Data Science")
#You can even specify the language or whether you want to include retweets
search_tweets("Columbia Data Science", lang = "en", include_rts = FALSE)

#If you have just the status IDs, you can use the lookup_tweets() function to get number of tweets. 
lookup_tweets(c("1454214453990416386", "1454213087473672194"))

#If you have just the user handle, you can also look up what tweets a user have favorited.
favorites <- get_favorites("DataSciColumbia", n = 3000)
```

Analysis & Interesting Application of functions:

Graphing # of favorited tweets of an account over time

Now that we have some of the basic building block of the functions, we can put together some interesting visualiations using Twitter data.

In the first example here, we can graph the number of tweets that @DataSciColumbia favorited!


```r
ts_plot(favorites, "weeks")
```
As you can see, the account was really active in favorit-ing tweets from 2017 up until before 2019. Maybe, we should go check on the owner of the account?


Finding top hashtags 

Next, we can use the search tweets function to pull tweets that mention @DataSciColumbia account and then find the top hashtags (by frequency) used when mentioning this account.



```r
#Search for tweets that mention @DataSciColumbia
tweets <- search_tweets("@DataSciColumbia",n=1000,include_rts = FALSE,retryonratelimit=F)

#Show a preview of screen names and tweets
preview <- tweets %>% dplyr::select(screen_name,text)
datatable(preview)

#Pull all the hashtags associated with the tweets
hash <- tweets %>% dplyr::select(created_at,screen_name,hashtags)
hash <- unnest(hash,cols=c(hashtags))

#Get a list of all the hashtags and count by frequency
tophash <- hash %>% filter(is.na(hashtags)==F) %>% 
            group_by(hashtags) %>% 
            summarise(count=n()) %>%
            arrange(-count) %>%
            arrange(count) %>% 
            mutate(hashtags=factor(hashtags,levels=hashtags))

#Plot the hashtags in a geom bar chart
ggplot(tophash,aes(x=hashtags,y=count)) + geom_bar(stat='identity') + 
    ggtitle(label="Most popular hashtags that menioned @DataSciColumbia") +
    coord_flip()
```






