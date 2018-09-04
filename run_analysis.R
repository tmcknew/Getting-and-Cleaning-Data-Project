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
# we will use "fread" from "data.table" to read the data
install.packages("data.table")
# and dplyr for tidying
install.packages("dplyr")
# and tibble for tibbles
install.packages("tibble")

library(data.table)
library(dplyr)
library(tibble)

# ensure files are present
if (!file.exists("UCI HAR Dataset/")) {
    url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, destfile = "UCI HAR Dataset.zip", method = "curl")
    unzip(zipfile = "UCI HAR Dataset.zip" )
}

# load observations ("X_") from test/ and train/
X_test <- fread("UCI HAR Dataset/test/X_test.txt") %>% as_tibble
X_train <- fread("UCI HAR Dataset/train/X_train.txt") %>% as_tibble

# read labels (column names) from features.txt
X_labels <- read.csv("UCI HAR Dataset/features.txt", 
                     sep = " ", header = FALSE,
                     col.names = c("index", "name"),
                     colClasses = c("integer", "character") ) %>%
                        as_tibble
                        
# assign labels to columns of the data frames
colnames(X_test) <- X_labels$name
colnames(X_train) <- X_labels$name

# import activity data for the test data set as a factor
# then cbind to X_test
read.csv("UCI HAR Dataset/test/y_test.txt", header = FALSE, 
         col.names = "activity", colClasses = "factor" ) %>%
    as_tibble %>%
    cbind(X_test) %>%
    set_tidy_names %>%
    assign(x = "X_test", ., pos = 1)

# import activity data for the training data set as a factor
# then cbind to X_train
read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE, 
         col.names = "activity", colClasses = "factor" ) %>%
    as_tibble %>%
    cbind(X_train) %>%
    set_tidy_names %>%
    assign(x = "X_train", ., pos = 1)

# import subject data for the test data set as a an integer
read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE, 
         col.names = "subject", colClasses = "integer" ) %>%
    as_tibble %>%
    cbind(X_test) %>%
    assign(x = "X_test", ., pos = 1)

# import subject data for the training data set as an integer
read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE, 
         col.names = "subject", colClasses = "integer" ) %>%
    as_tibble %>%
    cbind(X_train) %>%
    assign(x = "X_train", ., pos = 1)

# # add source column to dataset before merging with rbind
# data.frame(datasource = rep("test", nrow(X_test))) %>%
#     cbind(X_test) %>%
#     assign(x = "X_test", ., pos = 1)
# 
# # add source column to dataset before merging with rbind
# data.frame(datasource = rep("train", nrow(X_train))) %>%
#     cbind(X_train) %>%
#     assign(x = "X_train", ., pos = 1)

# combine train and test datasets
obs <- rbind(X_train,X_test) %>% as_tibble

# read activity labels
activitylabels <- 
    read.csv("UCI HAR Dataset/activity_labels.txt", sep = " ", 
                header = FALSE, col.names = c("index", "activity"),
                colClasses = c("integer", "character") ) %>%
                    mutate(activity = tolower(activity))

# set factor levels in obs to activitylabels[,"activity"]
levels(obs$activity)[levels(obs$activity) == activitylabels[,"index"]] <- 
    activitylabels[,"activity"]

# collect columns we want to keep (first 2, means and stdevs.)
first_cols <- c(rep(TRUE,2),rep(FALSE,length(colnames(obs)) - 2))
mean_cols <- grepl("mean", colnames(obs))
std_cols <- grepl("std", colnames(obs))

# group by subject, activity and summarise
avg_obs <- obs %>%
    select(which(first_cols | mean_cols | std_cols) ) %>%
    arrange(activity, subject) %>%
    group_by(activity, subject) %>%
    summarise_if(is.numeric, mean)

