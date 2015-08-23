# tidyingdata

This repo is in response to the Coursera course, "Getting and Cleaning Data" as part of the Data Science specialization track.  This course project/repo contains the following files:

* README.md - this file
* LICENSE.md - a license file inexpertly granting all contents of this repo the Apache 2.0 open source license.
* Codebook.md - a description of: key variables, transformations, data sets
* run_analysis.R - an R script that takes the raw data of an experiment and generates a tidy data set computing mean values of ~10,000 observations by subject, activity and measurement.

---
## Creating the Tidy Data Set
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

---
The assignment was:

*The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.*  

*One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:* 

*http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones* 

*Here are the data for the project:* 

*https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip* 

*You should create one R script called run_analysis.R that does the following.* 

*1. Merges the training and the test sets to create one data set.*
*2. Extracts only the measurements on the mean and standard deviation for each measurement.*
*3. Uses descriptive activity names to name the activities in the data set.*
*4. Appropriately labels the data set with descriptive variable names.* 
*5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.*

