# Getting and Cleaning Data Course Project

as outlined in the [project instructions](/project_instructions.md), the r-script `run_analysis.r`([here](/run_analysis.R)) completes the following objectives:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation 
for each measurement.
3. Uses descriptive activity names to name the activities in the 
data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent 
tidy data set with the average of each variable for each activity 
and each subject.

`run_analysis.R` has the following dependencies:

+ `data.table` for fast file reads with `fread`
+ `dplyr` for tidying data tables, and 
+ `tibble` for more table formatting goodness

## run_analysis.r

The script first checks for the data, downloads it if not present, and extracts it:

```r
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
```

Next, the observations (for both the training and test data) are loaded into data frames:

```r
# load observations ("X_") from test/ and train/
X_test <- fread("UCI HAR Dataset/test/X_test.txt") %>% as_tibble
X_train <- fread("UCI HAR Dataset/train/X_train.txt") %>% as_tibble
```

Now the data frame column labels are read in from `features.txt`

```r
# read labels (column names) from features.txt
X_labels <- read.csv("UCI HAR Dataset/features.txt", 
                     sep = " ", header = FALSE,
                     col.names = c("index", "name"),
                     colClasses = c("integer", "character") ) %>%
                        as_tibble
                        
# assign labels to columns of the data frames
colnames(X_test) <- X_labels$name
colnames(X_train) <- X_labels$name
```

Next, the activity data is read from `test/y_test.txt` and `train/y_train.txt` as a factor, and column-bound with the appropriate data frame. The factors will be relabelled once the data sets are row-bound into one.

```r
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
```

Now the subject data is read from `test/subject_test.txt` and `train/subject_train.txt`, and column-bound with the data sets:

```r
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
```

And finally the two data sets from `train` and `test` are row-bound to make one data set, **Objective 1 complete**. 

```
# combine train and test datasets
X_all <- rbind(X_train,X_test) %>% as_tibble

#   Objective 1 complete:
#   1. Merges the training and the test sets to create one data set.
```

Next, we will read in the activity labels from `activity_labels.txt` and use them to assign new labels to the factor levels, keeping the underlying column as a factor, but giving us nice readable names. **Objective 3 complete**.

```r
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
```

Next, we will select which columns to keep for further anaylsis, including the first two (`subject` and `activity`), as well as any whose name contains either `mean` or `std`. **Objective 2 complete**

```r
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
```

Now for the column names, we construct a pipeline of `gsub` to make a series of changes, replacing abbreviations with more human readable full names. **Objective 4 Complete**

```r
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
```

And finally a summary table is created, arranging and grouping by activity and subject, then computing means. **Objective 5 complete**

```r
summary_X_all <- mean_std_X_all %>%
    arrange(activity, subject) %>%
    group_by(activity, subject) %>%
    summarise_if(is.numeric, mean)

#   Objective 5 Complete:
#   5. From the data set in step 4, creates a second, independent 
#   tidy data set with the average of each variable for each activity 
#   and each subject.
```

Now the tidy summary dataset is exported as a .txt file for submission:

```r
write.table(summary_X_all, file = "out.txt", row.name = FALSE)
```