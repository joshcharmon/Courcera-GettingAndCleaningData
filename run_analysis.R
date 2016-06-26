rm(list=ls())

setwd("~/Courcera/UCI HAR Dataset")

train <- read.table("train/X_train.txt", header=FALSE, sep = "")
train <- cbind(train, read.table("train/subject_train.txt"), read.table("train/y_train.txt"))

test <- read.table("test/X_test.txt", header=FALSE, sep = "")
test <- cbind(test, read.table("test/subject_test.txt"), read.table("test/y_test.txt"))
data <- rbind(train, test)

features <- read.table("features.txt", header=FALSE, stringsAsFactors=FALSE)
features <- make.names(features[,"V2"])
mean_std <- data[,grep(pattern="std|mean", x=features, ignore.case=TRUE)]

activity_labels <- read.table("activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)
activity_labels <- apply(activity_labels, 1, function(x) unlist(strsplit(x, split=" ")))
data[,563] <- factor(as.factor(data[,563]), labels=activity_labels[2,])

features <- read.table("features.txt", header=FALSE, stringsAsFactors=FALSE)
features <- make.names(features[,"V2"])
features[562] = "subject"
features[563] = "activity"
colnames(data) <- features

labels <- colnames(data)[-c(562,563)]
data2 <- lapply(X=labels, FUN=function(x) tapply(data[[x]], list(data$activity, data$subject), mean))
names(data2) <- labels
capture.output(data2, file = "tidy_data.txt")