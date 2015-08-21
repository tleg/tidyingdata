# tidyingdata

Assignment:
---

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

---

Files of note in the data set:


* x_train.txt | x_test.txt - provides a table of data N rows by ~561 columns with various measurements.
* features.txt - provides column names for the 561 measurements in each test file.
* y_train.txt | y_test.txt - a table of data N rows by 1 column with an integer representing the activity taken (e.g. walking up, walking down)  
* activity_labels.txt - labels the activities - this corresponds to the y_test and y_train files and maps the numbers in those files to an activity.
* subject_train.txt | subject_test.txt - a table of data N rows by 1 column with the subject #.

---

What I think needs to be done:

1. combine x_train.txt, y_train.txt, features.txt, subject_train.txt into a data frame with features.txt providing the header rows.
2. combine x_test.txt, y_test.txt, features.txt and subject_test.txt into a data frame with features.txt providing the header rows.
3. merge df_train and df_test into a single data frame, df.
4. selects out the mean() and std() columns into a new datafram df2.
5. replaces the activity #s from y_* with the corresponding character-based factor from activity_labels.txt
6. ensure that all columns are intelligently named.
 
make sure we are tidy data (Each variable you measure should be in one column, Each different observation of that variable should be in a different row)

