# Getting and Cleaning Data Course Project: Code Book  

This project processes data from the [UCI HAR Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) to create several data products. From <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>:

>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
>
>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Data from the [UCI HAR Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) were processed and modified to produce:

+ a tidy data set `X_all` (10299 observations of 563 variables)
+ a reduced data set containing only the computed mean and standard deviation for each observation `mean_std_X_all` (10299 observations of 81 variables), and 
+ a summary dataset `summary_X_all` (180 observations of 81 variables) created from grouping `mean_std_X_all` by activity and subject, then computing mean values for each variable

## Processing Steps:

1. The observations were read from `test/X_test.txt`(2947 observations of 561 variables) and `train/X_train.txt` (7352 obs, 561 var).
2. Column names were read from `features.txt` and assigned to the data frame column names.
3. The activity data were read from `test/y_test.txt` and `train/y_train.txt` and column-bound to the `X_` data (now 562 variables).
4. The subject data were read from `test/subject_test.txt` and `train/subject_train.txt` and column-bound to the `X_` data (now 563 variables).
5. The `test` and `train` data were combined into `X_all` (10299 observations of 563 variables).
6. The `activity` column (factor) was relabelled to indicate the performed activity in a readable format using data from `activity_labels.txt`
7. A subset of columns was selected to produce `mean_std_X_all` (10299 observations of 81 variables)
8. Column names were modified to make them more easily readable
9. The summary data set `summary_X_all`(180 observations of 81 variables) was then created, grouping by `activity` and `subject`, then calculating mean values for each variable.
The data were then grouped by subject and activity, and numerical means calculated for each grouping. 

## Columns

The table below indicats the columns present in both `mean_std_X_all` and `summary_X_all`, along with their orignal names and the units of measurement.

Index | Original Name | Modified Name | Units
---:|---|---|---
[1] | from `test/subject_test.txt` and `train/subject_train.txt`   | subject | -
[2] | from `test/y_test.txt` and `train/y_train.txt`  | activity | -
[3] | tBodyAcc-mean()-X | timeseries_body_acceleration_x_component_mean | [g]
[4] | tBodyAcc-mean()-Y | timeseries_body_acceleration_y_component_mean | [g]
[5] | tBodyAcc-mean()-Z | timeseries_body_acceleration_z_component_mean | [g]
[6] | tBodyAcc-std()-X  | timeseries_body_acceleration_x_component_standard_deviation | [g]
[7] | tBodyAcc-std()-Y  | timeseries_body_acceleration_y_component_standard_deviation | [g]
[8] | tBodyAcc-std()-Z  | timeseries_body_acceleration_z_component_standard_deviation | [g]
[9] | tGravityAcc-mean()-X  | timeseries_gravity_acceleration_x_component_mean | [g]
[10] | tGravityAcc-mean()-Y | timeseries_gravity_acceleration_y_component_mean | [g]
[11] | tGravityAcc-mean()-Z | timeseries_gravity_acceleration_z_component_mean | [g]
[12] | tGravityAcc-std()-X  | timeseries_gravity_acceleration_x_component_standard_deviation | [g]
[13] | tGravityAcc-std()-Y  | timeseries_gravity_acceleration_y_component_standard_deviation | [g]
[14] | tGravityAcc-std()-Z  | timeseries_gravity_acceleration_z_component_standard_deviation | [g]
[15] | tBodyAccJerk-mean()-X    | timeseries_body_acceleration_jerk_x_component_mean | [g/sec]
[16] | tBodyAccJerk-mean()-Y    | timeseries_body_acceleration_jerk_y_component_mean | [g/sec]
[17] | tBodyAccJerk-mean()-Z    | timeseries_body_acceleration_jerk_z_component_mean | [g/sec]
[18] | tBodyAccJerk-std()-X | timeseries_body_acceleration_jerk_x_component_standard_deviation | [g/sec]
[19] | tBodyAccJerk-std()-Y | timeseries_body_acceleration_jerk_y_component_standard_deviation | [g/sec]
[20] | tBodyAccJerk-std()-Z | timeseries_body_acceleration_jerk_z_component_standard_deviation | [g/sec]
[21] | tBodyGyro-mean()-X   | timeseries_body_angular_velocity_x_component_mean | [rad/sec]
[22] | tBodyGyro-mean()-Y   | timeseries_body_angular_velocity_y_component_mean | [rad/sec]
[23] | tBodyGyro-mean()-Z   | timeseries_body_angular_velocity_z_component_mean | [rad/sec]
[24] | tBodyGyro-std()-X    | timeseries_body_angular_velocity_x_component_standard_deviation | [rad/sec]
[25] | tBodyGyro-std()-Y    | timeseries_body_angular_velocity_y_component_standard_deviation | [rad/sec]
[26] | tBodyGyro-std()-Z    | timeseries_body_angular_velocity_z_component_standard_deviation | [rad/sec]
[27] | tBodyGyroJerk-mean()-X   | timeseries_body_angular_velocity_jerk_x_component_mean | [rad/sec^2]
[28] | tBodyGyroJerk-mean()-Y   | timeseries_body_angular_velocity_jerk_y_component_mean | [rad/sec^2]
[29] | tBodyGyroJerk-mean()-Z   | timeseries_body_angular_velocity_jerk_z_component_mean | [rad/sec^2]
[30] | tBodyGyroJerk-std()-X    | timeseries_body_angular_velocity_jerk_x_component_standard_deviation | [rad/sec^2]
[31] | tBodyGyroJerk-std()-Y    | timeseries_body_angular_velocity_jerk_y_component_standard_deviation | [rad/sec^2]
[32] | tBodyGyroJerk-std()-Z    | timeseries_body_angular_velocity_jerk_z_component_standard_deviation | [rad/sec^2]
[33] | tBodyAccMag-mean()   | timeseries_body_acceleration_magnitude_mean | [g]
[34] | tBodyAccMag-std()    | timeseries_body_acceleration_magnitude_standard_deviation | [g]
[35] | tGravityAccMag-mean()    | timeseries_gravity_acceleration_magnitude_mean | [g]
[36] | tGravityAccMag-std() | timeseries_gravity_acceleration_magnitude_standard_deviation | [g]
[37] | tBodyAccJerkMag-mean()   | timeseries_body_acceleration_jerk_magnitude_mean | [g/sec]
[38] | tBodyAccJerkMag-std()    | timeseries_body_acceleration_jerk_magnitude_standard_deviation | [g/sec]
[39] | tBodyGyroMag-mean()  | timeseries_body_angular_velocity_magnitude_mean | [rad/sec]
[40] | tBodyGyroMag-std()   | timeseries_body_angular_velocity_magnitude_standard_deviation | [rad/sec]
[41] | tBodyGyroJerkMag-mean()  | timeseries_body_angular_velocity_jerk_magnitude_mean | [rad/sec^2]
[42] | tBodyGyroJerkMag-std()   | timeseries_body_angular_velocity_jerk_magnitude_standard_deviation | [rad/sec^2]
[43] | fBodyAcc-mean()-X    | fft_body_acceleration_x_component_mean | [g]
[44] | fBodyAcc-mean()-Y    | fft_body_acceleration_y_component_mean | [g]
[45] | fBodyAcc-mean()-Z    | fft_body_acceleration_z_component_mean | [g]
[46] | fBodyAcc-std()-X | fft_body_acceleration_x_component_standard_deviation | [g]
[47] | fBodyAcc-std()-Y | fft_body_acceleration_y_component_standard_deviation | [g]
[48] | fBodyAcc-std()-Z | fft_body_acceleration_z_component_standard_deviation | [g]
[49] | fBodyAcc-meanFreq()-X    | fft_body_acceleration_x_component_frequency_mean | [Hz]
[50] | fBodyAcc-meanFreq()-Y    | fft_body_acceleration_y_component_frequency_mean | [Hz]
[51] | fBodyAcc-meanFreq()-Z    | fft_body_acceleration_z_component_frequency_mean | [Hz]
[52] | fBodyAccJerk-mean()-X    | fft_body_acceleration_jerk_x_component_mean | [g/sec]
[53] | fBodyAccJerk-mean()-Y    | fft_body_acceleration_jerk_y_component_mean | [g/sec]
[54] | fBodyAccJerk-mean()-Z    | fft_body_acceleration_jerk_z_component_mean | [g/sec]
[55] | fBodyAccJerk-std()-X | fft_body_acceleration_jerk_x_component_standard_deviation | [g/sec]
[56] | fBodyAccJerk-std()-Y | fft_body_acceleration_jerk_y_component_standard_deviation | [g/sec]
[57] | fBodyAccJerk-std()-Z | fft_body_acceleration_jerk_z_component_standard_deviation | [g/sec]
[58] | fBodyAccJerk-meanFreq()-X    | fft_body_acceleration_jerk_x_component_frequency_mean | [Hz]
[59] | fBodyAccJerk-meanFreq()-Y    | fft_body_acceleration_jerk_y_component_frequency_mean | [Hz]
[60] | fBodyAccJerk-meanFreq()-Z    | fft_body_acceleration_jerk_z_component_frequency_mean | [Hz]
[61] | fBodyGyro-mean()-X   | fft_body_angular_velocity_x_component_mean | [rad/sec]
[62] | fBodyGyro-mean()-Y   | fft_body_angular_velocity_y_component_mean | [rad/sec]
[63] | fBodyGyro-mean()-Z   | fft_body_angular_velocity_z_component_mean | [rad/sec]
[64] | fBodyGyro-std()-X    | fft_body_angular_velocity_x_component_standard_deviation | [rad/sec]
[65] | fBodyGyro-std()-Y    | fft_body_angular_velocity_y_component_standard_deviation | [rad/sec]
[66] | fBodyGyro-std()-Z    | fft_body_angular_velocity_z_component_standard_deviation | [rad/sec]
[67] | fBodyGyro-meanFreq()-X   | fft_body_angular_velocity_x_component_frequency_mean | [Hz]
[68] | fBodyGyro-meanFreq()-Y   | fft_body_angular_velocity_y_component_frequency_mean | [Hz]
[69] | fBodyGyro-meanFreq()-Z   | fft_body_angular_velocity_z_component_frequency_mean | [Hz]
[70] | fBodyAccMag-mean()   | fft_body_acceleration_magnitude_mean | [g]
[71] | fBodyAccMag-std()    | fft_body_acceleration_magnitude_standard_deviation | [g]
[72] | fBodyAccMag-meanFreq()   | fft_body_acceleration_magnitude_frequency_mean | [Hz]
[73] | fBodyBodyAccJerkMag-mean()   | fft_body_acceleration_jerk_magnitude_mean | [g/sec]
[74] | fBodyBodyAccJerkMag-std()    | fft_body_acceleration_jerk_magnitude_standard_deviation | [g/sec]
[75] | fBodyBodyAccJerkMag-meanFreq()   | fft_body_acceleration_jerk_magnitude_frequency_mean | [Hz]
[76] | fBodyBodyGyroMag-mean()  | fft_body_angular_velocity_magnitude_mean | [rad/sec]
[77] | fBodyBodyGyroMag-std()   | fft_body_angular_velocity_magnitude_standard_deviation | [rad/sec]
[78] | fBodyBodyGyroMag-meanFreq()  | fft_body_angular_velocity_magnitude_frequency_mean | [Hz]
[79] | fBodyBodyGyroJerkMag-mean()  | fft_body_angular_velocity_jerk_magnitude_mean | [rad/sec^2]
[80] | fBodyBodyGyroJerkMag-std()   | fft_body_angular_velocity_jerk_magnitude_standard_deviation | [rad/sec^2]
[81] | fBodyBodyGyroJerkMag-meanFreq()  | fft_body_angular_velocity_jerk_magnitude_frequency_mean | [Hz]
