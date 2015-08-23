# Codebook.md
The goal of this repository is to take data from an experiment with a wearable device and collate the train and test data of approximately 10,000 measurements across 561 variables and turn it into a smaller tidy data set.  That data set should contain columns for the subject of the test, the activity of the subject during the observation (e.g. walking, standing), and the average value of test numbers across all observations for that subject and that activity for variables which are, themselves, the mean or standard deviation metrics for the underlying data.  This Codebook describes (1) where to get the data, (2) what is in the important files, (3) the necessary steps to transform the data and (4) the variables in the final data set.

## Getting the data
The data for this repo can be retrieved from its original location:

* http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

or through the course link:

* https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Once you have received the zip file, unzip the following folders/files into your R working directory.

* folder: test
* folder: train
* file: activity_labels.txt
* file: features.txt
* file: features_info.txt
* file: README.txt

The features_info.txt and README.txt are informative files to help describe the data set in more detail.  It is recommended that anyone interested in this dataset review these files.

## Important files & description
The following files contain the underlying data required to create the tidy data set:

File Name | Information
--- | ---
test/X_test.txt | this is the test data set with ~3,000 observations for 561 variables
test/y_test.txt | this is a ~3000 x 1 data set with a number from 1-6 corresponding the to activity for each of the observations in X_test.xt
test/subject_test.txt | this is a ~3000 x 1 data set with a number from 1-30 corresponding to the subject of the test for each of the observations in X_test.txt
train/X_train.txt | this is the training data set with ~7,000 observations for 561 variables
ttrain/y_train.txt | this is a ~7000 x 1 data set with a number from 1-6 corresponding the to activity for each of the observations in X_train.xt
train/subject_train.txt | this is a ~7000 x 1 data set with a number from 1-30 corresponding to the subject of the test for each of the observations in X_train.txt
features.txt | this file contains the name/headers for the 561 measurements taken in X_test.txt and X_train.txt
activity_labels.txt | this file contains a 6x2 matrix of activities assigned to a number 1-6.  It is required for eventually mapping the activities of the observations (derived from y_train.txt and y_test.txt) into human-readable form.

## Creating the Tidy Data Set
*Note: This is repeated from README.md because it's unclear if this should be in the README the Codebook or both.  Given that overcommunication is better than undercommunication, I'm going with both.*

The script run_analysis.R performs these basic funbctions:

1. It loads the requisite libraries to ensure that it can do its job.  They are:
  * dplyr - used for efficiently managing data in a data frame
  * readr - used to read data from X_test.txt and X_train.txt with read_fwf, which is much more efficient thatn read.fwf (and failed on my Windows machine)
  * reshape2 - used to melt the dataframe into a format that makes summarization stragitforward.
2. It assigns the important filenames in the section above to variables to make them easy to identify and use throughouth the script.
3. It creates a dataframe *meshead_df* loading the values of features.txt.  
4. It then uses fwf_widths() to establish the column dimensions of X_test.txt and X_train.txt (16 characters) and attach headers from meshead_df.
5. Next for both the *test* and *train* data sets it:
  1. loads observation (X_test or X_train), activity (y_test or y_train) and subject (subject_test or subject_train) data into data frames
  2. builds a data frame named *test* or *train* from those data frames in the order of subject, activity, observations. 
6. Combines the data sets into one large data named *full_data* set with **rbind(train, test)**
7. Uses dplyr to **select** a subject of observations that match "mean." or "std" - restricting it to the observations requested in the assignment.
8. Loads the mapping of integer value (1-6) to the associated activity (e.g. WALKING, STANDING) into a dataframe named *activities*
9. Uses dplyr's **transmute** function to set *full_data$activity* to character values (e.g. WALKING, STANDING) rather than numbers.
10. Uses reshape2's **melt** function to melt the *full_data* data frame into the *full_melt* data frame with the id vector of subject and activity.  This turns the other columns of the *full_data* data frame into a tall and skinny data frame with each measurement a variable with an associated value.
11. Uses dplyr's **group_by** function to group *full_melt* by subject, activity and the 'variable' column (this enables grouping by subject-activity-measurement tuples)
12. computes the average into a dataframe named *full_average* by using dplyr's **summarize** command

This completes the steps required to make the final tidy data set, *full_average*.

## Variables in the data set
The following variables and values are in the final data set.

Variable | Values | Comments
--- | --- | ---
subject | Integer 1 - 30 | An integer representing a subject in the test.  30 individuals were tested and each assigned a value 1 - 30.
activity | Factor with six levels:<br>LAYING<br>SITTING<br>STANDING<br>WALKING<br>WALKING_DOWNSTAIRS<br>WALKING_UPSTAIRS | A human-readable description of one of the six activities subjects engaged in while observed.
tBodyAcc.mean...X | numeric | average value of body impact on accelerometer in X axis
tBodyAcc.mean...Y | numeric | average value of body impact on accelerometer in Y axis
tBodyAcc.mean...Z | numeric | average value of body impact on accelerometer in Z axis
tBodyAcc.std...X | numeric | standard deviation of body impact on accelerometer in X axis
tBodyAcc.std...Y | numeric | standard deviation of body impact on accelerometer in Y axis
tBodyAcc.std...Z | numeric | standard deviation of body impact on accelerometer in Z axis
tGravityAcc.mean...X | numeric | average value of gravity impact on accelerometer in X axis
tGravityAcc.mean...Y | numeric | average value of gravity impact on accelerometer in Y axis
tGravityAcc.mean...Z | numeric | average value of gravity impact on accelerometer in Z axis
tGravityAcc.std...X | numeric | standard deviation of gravity impact on accelerometer in X axis
tGravityAcc.std...Y | numeric | standard deviation of gravity impact on accelerometer in X axis
tGravityAcc.std...Z | numeric | standard deviation of gravity impact on accelerometer in X axis
tBodyAccJerk.mean...X | numeric | average value of body impact on accelerometer Jerk in X axis
tBodyAccJerk.mean...Y | numeric | average value of body impact on accelerometer Jerk in Y axis
tBodyAccJerk.mean...Z | numeric | average value of body impact on accelerometer Jerk in Z axis
tBodyAccJerk.std...X | numeric | standard deviation of body impact on accelerometer Jerk in X axis
tBodyAccJerk.std...Y | numeric | standard deviation of body impact on accelerometer Jerk in Y axis
tBodyAccJerk.std...Z | numeric | standard deviation of body impact on accelerometer Jerk in Z axis
tBodyGyro.mean...X | numeric | average value of body impact on gyroscopic measurements in X axis
tBodyGyro.mean...Y | numeric | average value of body impact on gyroscopic measurements in Y axis
tBodyGyro.mean...Z | numeric | average value of body impact on gyroscopic measurements in Z axis
tBodyGyro.std...X | numeric | standard deviation of body impact on gyroscopic measurements in X axis
tBodyGyro.std...Y | numeric | standard deviation of body impact on gyroscopic measurements in Y axis
tBodyGyro.std...Z | numeric | standard deviation of body impact on gyroscopic measurements in Z axis
tBodyGyroJerk.mean...X | numeric | average value of body impact on gyroscopic Jerk in X axis
tBodyGyroJerk.mean...Y | numeric | average value of body impact on gyroscopic Jerk in X axis
tBodyGyroJerk.mean...Z | numeric | average value of body impact on gyroscopic Jerk in X axis
tBodyGyroJerk.std...X | numeric | standard deviation of body impact on gyroscopic Jerk in X axis
tBodyGyroJerk.std...Y | numeric | standard deviation of body impact on gyroscopic Jerk in X axis
tBodyGyroJerk.std...Z | numeric | standard deviation of body impact on gyroscopic Jerk in X axis
tBodyAccMag.mean.. | numeric | average value of magnitude of three dimensional signals of body impact on accelerometer calculated using the Euclidean norm.
tBodyAccMag.std.. | numeric | standard deviation of magnitude of three dimensional signals of body impact on accelerometer calculated using the Euclidean norm.
tGravityAccMag.mean.. | numeric | average value of magnitude of three dimensional signals of gravity impact on accelerometer calculated using the Euclidean norm.
tGravityAccMag.std.. | numeric | standard deviation of magnitude of three dimensional signals of gravity impact on accelerometer calculated using the Euclidean norm.
tBodyAccJerkMag.mean.. | numeric | average value of magnitude of three dimensional signals of body impact on accelerometer Jerk calculated using the Euclidean norm.
tBodyAccJerkMag.std.. | numeric | standard deviation of magnitude of three dimensional signals of body impact on accelerometer Jerk calculated using the Euclidean norm.
tBodyGyroMag.mean.. | numeric | average value of magnitude of three dimensional signals of body impact on gyroscope calculated using the Euclidean norm.
tBodyGyroMag.std.. | numeric | standard deviation of magnitude of three dimensional signals of body impact on gyroscope calculated using the Euclidean norm.
tBodyGyroJerkMag.mean.. | numeric | average value of magnitude of three dimensional signals of body impact on gyroscope Jerk calculated using the Euclidean norm.
tBodyGyroJerkMag.std.. | numeric | standard deviation of magnitude of three dimensional signals of body impact on gyroscope Jerk calculated using the Euclidean norm.
fBodyAcc.mean...X | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAcc.mean...Y | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAcc.mean...Z | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAcc.std...X | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAcc.std...Y | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAcc.std...Z | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAccJerk.mean...X | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAccJerk.mean...Y | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAccJerk.mean...Z | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAccJerk.std...X | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAccJerk.std...Y | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAccJerk.std...Z | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyGyro.mean...X | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyGyro.mean...Y | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyGyro.mean...Z | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyGyro.std...X | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyGyro.std...Y | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyGyro.std...Z | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAccMag.mean.. | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyAccMag.std.. | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyBodyAccJerkMag.mean.. | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyBodyAccJerkMag.std.. | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyBodyGyroMag.mean.. | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyBodyGyroMag.std.. | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyBodyGyroJerkMag.mean.. | numeric | Fast Fourier Transform of same value beginning with t above.
fBodyBodyGyroJerkMag.std.. | numeric | Fast Fourier Transform of same value beginning with t above.

For more details on the observations and how they're computed and what they mean, read *features_info.txt* in the data set ZIP.
