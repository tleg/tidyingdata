# Load requisite libraries
#library(plyr)
library(dplyr) # used to manage/arrange data in a data frame, should be loaded after plyr
library(readr) # Used to read FWF files efficiently on windows
library(reshape2) # used to melt the data set for the final tidy data set.

# This script assumes the data set 
#     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# has been downloaded and extracted to your working directory.  If this link doesn't work.
# you can get the original data from its source:
#     http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# Assign variables to the important files.
test_mes <- "test/X_test.txt"
test_act <- "test/Y_test.txt"
test_subj <- "test/subject_test.txt"

train_mes <- "train/X_train.txt"
train_act <- "train/Y_train.txt"
train_subj <- "train/subject_train.txt"

measurement_headers <- "features.txt"
activity_labels <- "activity_labels.txt"

# The measurement data is 561 columns of a fixed with of 16 characters.
# We'll use fwf_read which has an option to send column widths and headers through fwf_widths.
# So prime fwf_widths with the right vectors.

meshead_df <- read.delim(measurement_headers, sep=" ", header=FALSE)
widths <- fwf_widths(rep(16,561), col_names = as.character(meshead_df[[2]]))

# Now, build a data frame of the test data with the format:
# subject, activity, measurements with the headers:
# subject, activity, <contents of measurement_headers>

testmes_df <- read_fwf(test_mes, widths)
testact_df <- read.csv(test_act, sep=" ", col.names=c("activity"), header=FALSE)
testsubj_df <- read.csv(test_subj, sep=" ", col.names=c("subject"), header=FALSE)

test <- data.frame(testsubj_df, testact_df, testmes_df)

# Do the same for the train data.

trainmes_df <- read_fwf(train_mes, widths)
trainact_df <- read.csv(train_act, sep=" ", col.names=c("activity"), header=FALSE)
trainsubj_df <- read.csv(train_subj, sep=" ", col.names=c("subject"), header=FALSE)

train <- data.frame(trainsubj_df, trainact_df, trainmes_df)

# Combine data sets!

full_data <- rbind(train, test)

# With the two data frames built we now want them to have only the
# measurements that are mean.. or std.. measurements per the assignment. In the case
# of mean, we are looking for columns that have the mean values of the measurement.
# Other columns with meanFreq.. aren't providing a mean value of the measurement and
# angle(tBodyGyroJerkMean,gravityMean) is providing a derivative metric. These are not
# called for in our assignment which states:
#
# "Extracts only the measurements on the mean and standard deviation for each measurement"

full_data <- dplyr::select(full_data, 1:2, matches("mean\\.|std", ignore.case=FALSE))

# We now have 10,299 (7352+2947) observations with 68 variables.  So on to step 3:
# "Uses descriptive activity names to name the activities in the data set"

# Load the activity mapping data from activity_labels.txt
activities <- read.csv(activity_labels, sep=" ", header=FALSE, col.names=c("act_ID", "act_label"))

# This creates a 6x2 data frame with each of the activity IDs 1-6 with their associated label.
# our job is now to convert full_data$activity from the number to the labels.  
# We do this with a simple assignment of a transmuted value with dplyr.

full_data$activity <- transmute(full_data, activities$act_label[full_data$activity])[,]

# We should now have 10,299 objects with 68 variables, where the activity is a label that is in
# english rather than a numeric value and the variables are only mean and std variables.
# The last step is to create a second data set that takes the average (mean) of each variable
# for each activity for each subject.

# Melt them to make them more usable.
full_melt <- melt(full_data, id=c("subject", "activity"))

# Then group by subject, activity and variable -- the latter is necessary or summarize will collapse 
# metrics intro subject-activity tuples when you need subject-activity-measurement tuples.

full_group <- group_by(full_melt, subject, activity, variable)

# Use summarize to compute the mean of each variable.
full_average <- summarize(full_group, mean=mean(value))

# Complete.  Should have ~11,880 objects with 4 variables: Subject, Activity, Variable, Mean