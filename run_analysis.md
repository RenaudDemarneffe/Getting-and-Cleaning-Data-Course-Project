# Technical analysis of "run_analysis.R"

This script is composed of 6 steps:

- Initialization;
- Merges the training and the test sets to create one data set;
- Extracts only the measurements on the mean and standard deviation for each measurement;
- Uses descriptive activity names to name the activities in the data set;
- Appropriately labels the data set with descriptive variable names;
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script is also commented directly into the code. This document will only explain the high-level logic applied to resolve the problem.

## Initialization
This step load the needed libraries, download and unzip the original files (if it's not already present).


## Merges the training and the test sets to create one data set
This step read each input file into data frames. For test and training data, it will combines the Subject, X and Y data into a same data frame (one for test and one for training).

To facilitate the reading of the content of the data set, this step attributes the correct names to the column of the data frames (mainly based on feature.txt file).

Finally, it will append the test and training data set into one merged data set and add a column to keep the origin of the row (test or training).


## Extracts only the measurements on the mean and standard deviation for each measurement
This step extracts, from the merged dataset, the columns containing a mean or std value. To do this, it uses the grepl function.

Remark: We also keep the subject and activity columns but remove columns based on angle because it doesn't represent a mean or std value (own choice).


## Uses descriptive activity names to name the activities in the data set
Read activity_labels.txt as a dataset and join it with the dataset resultant of previous step to associate an activity name at each row.


## Appropriately labels the data set with descriptive variable names
To obtain a tidy dataset, process mean and std columns to obtain only one information per column and one observation per row.

For example, the column "tBodyAcc-mean()-X" contains the following informaitons:

- t --> Time;
- Body;
- Acc --> accelerator;
- mean;
- X axis.


## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
Aggregate the tidy data set to obtain the mean for each arctivity, subject and variable. To do this, we use a data table and set a key to this table.

Remark: we remove the body2 and frequency column to compute the avergae because we think there are of no importance.
