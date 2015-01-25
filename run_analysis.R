#Getting and Cleaning Data Course Project
#January 2015

#runAnalysis.r description: 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

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
colnames(activity_labels) <- c('activityId', 'activityType')