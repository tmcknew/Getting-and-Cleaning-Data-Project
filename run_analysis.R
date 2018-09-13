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

# rm(list = ls())
# we will use "fread" from "data.table" to read the data
# install.packages("data.table")
# and dplyr for tidying
# install.packages("dplyr")
# and tibble for tibbles
# install.packages("tibble")

library(data.table); library(dplyr); library(tibble)

# ensure files are present
data_dir = "UCI HAR Dataset/"
if (!file.exists(data_dir)) {
    if (!file.exists("UCI HAR Dataset.zip")) {
        url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        paste("Downloading data from", url) %>% print
        download.file(url, destfile = "UCI HAR Dataset.zip", method = "curl")
        }
    paste0("Decompressing archive into '", data_dir, "'") %>% print
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
    set_tidy_names(quiet = TRUE) %>%
    assign(x = "X_test", ., pos = 1)

# import activity data for the training data set as a factor
# then cbind to X_train
read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE, 
         col.names = "activity", colClasses = "factor" ) %>%
    as_tibble %>%
    cbind(X_train) %>%
    set_tidy_names(quiet = TRUE) %>%
    assign(x = "X_train", ., pos = 1)

# import subject data for the test data set as an integer
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

# combine train and test datasets
X_all <- rbind(X_train,X_test) %>% as_tibble

#   Objective 1 complete:
#   1. Merges the training and the test sets to create one data set.

# read activity labels
activitylabels <- 
    read.csv("UCI HAR Dataset/activity_labels.txt", sep = " ", 
                header = FALSE, col.names = c("index", "activity"),
                colClasses = c("integer", "character") ) %>%
                    mutate(activity = tolower(activity))

# set factor levels in X_all to activitylabels[,"activity"]
levels(X_all$activity)[levels(X_all$activity) == activitylabels[,"index"]] <- 
    activitylabels[,"activity"]

#   Objective 3 Complete:
#   3. Uses descriptive activity names to name the activities in the 
#   data set

# some logical vectors for columns we want to keep 
# ... (subject, activity, means and stdevs.)
first_cols <- c(rep(TRUE,2),rep(FALSE,length(colnames(X_all)) - 2))
mean_cols <- grepl("mean", colnames(X_all))
std_cols <- grepl("std", colnames(X_all))

# select on columns to keep
mean_std_X_all <- X_all %>%
    select(which(first_cols | mean_cols | std_cols) )

#   Objective 2 Complete:
#   2. Extracts only the measurements on the mean and standard deviation 
#   for each measurement.

# fix column names to be friendlier
names(mean_std_X_all) <- names(mean_std_X_all) %>%
    gsub("^t","timeseries_",.) %>%
    gsub("^f","fft_",.) %>%
    gsub("Body","body_",.) %>%
    gsub("Gravity","gravity_",.) %>%
    gsub("Acc","acceleration_",.) %>%
    gsub("Gyro","angular_velocity_",.) %>%
    gsub("Jerk","jerk_",.) %>%
    gsub("Mag","magnitude_",.) %>%
    gsub("-X","x_component",.) %>%
    gsub("-Y","y_component",.) %>%
    gsub("-Z","z_component",.) %>%
    gsub("std","standard_deviation",.) %>%
    gsub("meanFreq","frequency_mean",.) %>%
    gsub("_body_body","_body",.) %>%
    
    gsub("(-)(\\w*)(\\(\\))(\\w*)",
        "\\4_\\2",.) %>%
    gsub("__","_",.)
    
#   Objective 4 Complete:
#   4. Appropriately labels the data set with descriptive variable names.
#   names(mean_std_X_all)

summary_X_all <- mean_std_X_all %>%
    arrange(activity, subject) %>%
    group_by(activity, subject) %>%
    summarise_if(is.numeric, mean)

#   Objective 5 Complete:
#   5. From the data set in step 4, creates a second, independent 
#   tidy data set with the average of each variable for each activity 
#   and each subject.

write.table(summary_X_all, file = "out.txt", row.name = FALSE)
