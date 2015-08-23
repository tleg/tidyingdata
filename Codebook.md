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

