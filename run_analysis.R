#Getting and Cleaning Data Course Project
#January 2015

#runAnalysis.r description: 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.

#set working directory to where data files are stored
setwd('/Users/lisar/Documents/R/GettingAndCleaningData/Course Project/UCI HAR Dataset')

#clean workspace
rm(list = ls(all = TRUE))

#load necessary packages
library(plyr)
library(data.table)
library(dplyr)

#load the data
x_test <- read.table("test/x_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
x_train <- read.table("train/x_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

#add column names to the datasets
colnames(x_test) <- t(features[2])
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(x_train) <- t(features[2])
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"
colnames(activity_labels) <- c("activityId", "activityName")

#merge the x and y datasets
testdata <- cbind(y_test, subject_test, x_test)
traindata <- cbind(y_train, subject_train, x_train)

#merge the test and training datasets
data <- rbind(traindata, testdata)

#make logical vector to be true for only desired columns
#looking for mean and standard deviation
log <- (grepl("activity..", colnames(data)) | grepl("subject..", colnames(data)) |
                grepl("..-mean..", colnames(data)) & !grepl("..-meanFreq..", colnames(data)) |
                grepl("-std..", colnames(data)))

#pull only columns with logical vector value = TRUE
data <- data[log == TRUE]

#add activity names by merging activity_labels dataset with the data dataset
data <- merge(data, activity_labels, by = 'activityId', all.x = TRUE)

#create a vector of column names so they are more easily updated
columns <- colnames(data)

#clean up column names
for (i in 1:length(columns)) {
        columns[i] <- gsub("-mean()", "Mean", columns[i])
        columns[i] <- gsub("-std()", "StdDev", columns[i])
        columns[i] <- gsub("^(t)", "time", columns[i])
        columns[i] <- gsub("^(f)", "frequency", columns[i])
        columns[i] <- gsub("BodyBody", "Body", columns[i])
        columns[i] <- gsub("\\()", "", columns[i])
}

#update the column names
colnames(data) <- columns

#remove activity name to simplify process of creating tidy dataset
data_ <- data[, names(data) != 'activityName']

#create a tidy dataset that summarizes the data dataset to just have the average of each
#variable for each activity and each subject
tidy <- aggregate(data_[,names(data_) != c('activityId', 'subjectId')], 
                  by = list(activityId = data_$activityId, subjectId = data_$subjectId), mean)

#add the acitivity name back to the dataset
tidy <- merge(tidy, activity_labels, by = 'activityId', all.x = TRUE)

write.table(tidy, './tidyData.txt', row.names = TRUE, sep = '\t')