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
library(data.table)
# and dplyr for tidying
install.packages("dplyr")
library(dplyr)

# ensure files are present
if (!file.exists("UCI HAR Dataset/")) {
    url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, destfile = "UCI HAR Dataset.zip", method = "curl")
    unzip(zipfile = "UCI HAR Dataset.zip" )
}

# load observations ("X_") from train/ and test/
X_train <- fread("UCI HAR Dataset/train/X_train.txt")
X_test <- fread("UCI HAR Dataset/test/X_test.txt")
# convert to tibble 
X_train <- as_tibble(X_train)
X_test <- as_tibble(X_test)

# read in the labels (column names) from features.txt
X_labels <- read.csv("UCI HAR Dataset/features.txt", 
                     sep = " ", header = FALSE,
                     col.names = c("index", "name"),
                     colClasses = c("integer", "character") )
X_labels$name <- gsub('(\\(|\\)|,)',"",X_labels$name)
X_labels
# assign labels to columns of the data frames
colnames(X_train) <- X_labels$name
colnames(X_test) <- X_labels$name
# rm(X_labels)

# add logical columns to indicate source before rbinding train and test
X_train_src = data.frame(from_X_train = rep(TRUE, nrow(X_train)),
                         from_X_test = rep(FALSE, nrow(X_train)))
X_test_src = data.frame(from_X_train = rep(FALSE, nrow(X_test)),
                        from_X_test = rep(TRUE, nrow(X_test)))
# bind columns
X_train <- cbind(X_train_src,X_train)
X_test <- cbind(X_test_src,X_test)
# rm(X_train_src); rm(X_test_src) 

# bind rows from train and test
obs <- rbind(X_train, X_test)

select(obs, -contains("bandsEnergy"))

X_train %>%
    select( contains("mean"), contains("std") )
    as_tibble %>%
    group_by(from_X_train) %>%
    summarise(n = n())
# import activity data for the training data set as a factor
activity_train <-  read.csv("UCI HAR Dataset/train/y_train.txt",
                            header = FALSE, col.names = c("activity"),
                            colClasses = c("factor") )

# import activity data for the test data set as a factor
activity_test <-  read.csv("UCI HAR Dataset/test/y_test.txt", 
                            header = FALSE, col.names = c("activity"),
                            colClasses = c("factor") )

# read activity labels
activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", 
                     sep = " ", header = FALSE,
                     col.names = c("index", "activity"),
                     colClasses = c("integer", "character") )
short <- head(activity_test)
activity_test %>%
    as_tibble %>%
    mutate(activity_label = activity_labels[activity,"activity"]) %>%
    assign(x="activity_test", ., pos = 1)
