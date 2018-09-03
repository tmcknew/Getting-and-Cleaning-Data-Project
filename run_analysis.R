# run_analysis.R
# 
#   Objectives:
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation 
#   for each measurement.
#   3. Uses descriptive activity names to name the activities in the 
#   data set
#   4. Appropriately labels the data set with descriptive variable names.
#   5. From the data set in step 4, creates a second, independent 
#   tidy data set with the average of each variable for each activity 
#   and each subject.
rm(list = ls())
# ensure files are present
if (!file.exists("UCI HAR Dataset/")) {
    url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, destfile = "UCI HAR Dataset.zip", method = "curl")
    unzip(zipfile = "UCI HAR Dataset.zip" )
}

# we will use "fread" from "data.table" to read the data
install.packages("data.table")
install.packages("dplyr")
library(data.table)
library(dplyr)
X_train <- fread("UCI HAR Dataset/train/X_train.txt")
X_test <- fread("UCI HAR Dataset/test/X_test.txt")

activity_train <-  read.csv("UCI HAR Dataset/train/y_train.txt", 
                            sep = " ", header = FALSE,
                            col.names = c("activity"),
                            colClasses = c("integer") )
activity_test <-  read.csv("UCI HAR Dataset/test/y_test.txt", 
                            sep = " ", header = FALSE,
                            col.names = c("activity"),
                            colClasses = c("integer") )

# read activity labels
activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", 
                     sep = " ", header = FALSE,
                     col.names = c("index", "activity"),
                     colClasses = c("integer", "character") )

# read in the labels (column names) from features.txt
X_labels <- read.csv("UCI HAR Dataset/features.txt", 
                     sep = " ", header = FALSE,
                     col.names = c("index", "name"),
                     colClasses = c("integer", "character") )

X_test <- as_tibble(X_test)
X_train <- as_tibble(X_train)

# assign labels to columns of the data frame
colnames(X_train) <- X_labels$name
colnames(X_test) <- X_labels$name
