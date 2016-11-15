#devtools::install_github("kbenoit/quanteda")
#install.packages("tm")
#install.packages("NLP")

library(quanteda)
library(NLP)
library(tm)
library(wordcloud)

tips<- read.csv("/Users/Laura/GoogleDrive/NYU/InfoVis/YelpProject/Data/yelp_dataset_challenge_academic_dataset/tips.csv", stringsAsFactors = FALSE)

#View(tips)

one_star <- paste(tips$text[tips$stars==1], collapse=" ")
two_stars <- paste(tips$text[tips$stars==2], collapse=" ")
three_stars <- paste(tips$text[tips$stars==3], collapse=" ")
four_stars <- paste(tips$text[tips$stars==4], collapse=" ")
five_stars <- paste(tips$text[tips$stars==5], collapse=" ")

#View(one_star)
#View(two_stars)
#View(three_stars)
#View(four_stars)
#View(five_stars)

# Create DTM and preprocess
groups <- VCorpus(VectorSource(c("One Star" = one_star, "Two Stars" = two_stars, "Three Stars" = three_stars, "Four Stars" = four_stars, "Five Stars" = five_stars)))
groups <- tm_map(groups, content_transformer(tolower))
groups <- tm_map(groups, removePunctuation)
groups <- tm_map(groups, stripWhitespace)
dtm <- DocumentTermMatrix(groups)

## Label groups
dtm$dimnames$Docs = c("One Star", "Two Stars", "Three Stars", "Four Stars", "Five Stars")
## Transpose matrix so that we can use it with comparison.cloud
tdm <- t(dtm)
## Compute TF-IDF transformation
tdm <- as.matrix(weightTfIdf(tdm))


## Display word clouds
comparison.cloud(tdm, max.words=100, random.order=FALSE,colors=c("red","#00B2FF","yellow","green","#6600CC"))
