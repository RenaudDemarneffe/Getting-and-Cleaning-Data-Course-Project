
## Initialization phase.
message("Initialization phase.")

# Load the needed libraries.
library(data.table)
library(plyr)
library(tidyr)

# Download the data if it's not already done. After, if needed, unzip the file.
if (!file.exists("UCI HAR Dataset.zip"))
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI HAR Dataset.zip")

if (!dir.exists("UCI HAR Dataset"))
  # Remark: it will automatically create the directory "UCI HAR Dataset".
  unzip("UCI HAR Dataset.zip", overwrite = TRUE)



## Part 1 of the project: Merges the training and test sets to create one data set.
message("Part 1 of the project: Merges the training and test sets to create one data set.")

# Load the sets (training and test).
trainingSet <- read.table("UCI HAR Dataset\\train\\X_train.txt")
testSet <- read.table("UCI HAR Dataset\\test\\X_test.txt")
# Load the labels of activities (training and test)
trainingActivities <- read.table("UCI HAR Dataset\\train\\Y_train.txt")
testActivities <- read.table("UCI HAR Dataset\\test\\Y_test.txt")
# Load the subjects of activities (training and test)
trainingSubjects <- read.table("UCI HAR Dataset\\train\\subject_train.txt")
testSubjects <- read.table("UCI HAR Dataset\\test\\subject_test.txt")

# Read the headers of the column for the two sets and replace the names automatically allocated.
features <- read.table("UCI HAR Dataset\\features.txt")
names(trainingSet) <- features[,2]
names(testSet) <- features[,2]
# Set a header name to the columns of subjects and labels data set.
names(trainingSubjects) <- c("subject")
names(testSubjects) <- c("subject")
names(trainingActivities) <- c("activity_id")
names(testActivities) <- c("activity_id")

# Add a column to each set to identify the origin of each row.
trainingSet[,trainingSet$origin] <- "training"
testSet[,testSet$origin] <- "test"

# Merge ("join") the activities, labels and set for training and test.
trainingJoinSet <- cbind(trainingActivities, trainingSubjects, trainingSet)
testJoinSet <- cbind(testActivities, testSubjects, testSet)
# Merge (concatenate) the to resultant sets.
mergedSet <- rbind(trainingJoinSet, testJoinSet)



## Part 2 of the project: Extracts only the measurements on the mean and standard deviation for each measurement.
message("Part 2 of the project: Extracts only the measurements on the mean and standard deviation for each measurement.")

# Build a boolean list with the columns to extract (mean, std, subject and activity_id) and then extract from the merged set.
# Remarks: The columns subject and activity_id are for the following parts of the project.
#          We exclude columns with "angle" that are not mean or std.
featuresToExtract <- grepl("mean|std|subject|activity_id", names(mergedSet), ignore.case = TRUE) & !grepl("angle", names(mergedSet), ignore.case = TRUE)
reducedMergedSet <- mergedSet[,featuresToExtract]



## Part 3 of the project: Uses descriptive activity names to name the activities in the data set.
message("Part 3 of the project: Uses descriptive activity names to name the activities in the data set.")

# Load activity labels and set column names.
activityLabels <- read.table("UCI HAR Dataset\\activity_labels.txt")
names(activityLabels) <- c("activity_id", "activity_name")

# Join the merged data set with the activity labels to obtains activity names (column activity_name) into the data set.
reducedMergedSet <- join(reducedMergedSet, activityLabels, by="activity_id")



## Part 4 of the project: Appropriately labels the data set with descriptive variable names.
## We took the descision to split each column name into 9 parts and so construct a data set
##   sith one variable into each column.
message("Part 4 of the project: Appropriately labels the data set with descriptive variable names.")

# Gather the column with value into key-value pairs.
descriptiveMergedSet <- gather(reducedMergedSet, feature, value, -subject, -activity_id, -activity_name)
# Modify the value of the key "feature" to facilitate the split into distincts columns.
descriptiveMergedSet$feature <- gsub("^(f|t)(Body|Gravity)(Body)?(Acc|Gyro)(Jerk)?(Mag)?-(mean|std)(Freq)?\\(\\)-?(X|Y|Z)?",
                                     x=descriptiveMergedSet$feature, "\\1_\\2_\\3_\\4_\\5_\\6_\\7_\\8_\\9", ignore.case = TRUE)
# Split the key "feature" into 9 columns, each column with one attribute.
descriptiveMergedSet <- separate(descriptiveMergedSet, feature,
         c("signaldomain", "signal", "body2", "instrument", "jerk", "magnitude", "variable", "frequency", "axis"),
         sep="_")
# Replace attributes with <white> per NA.
# For column "signaldomain", replace "f" with "Fourier" and "t" with "Time".
descriptiveMergedSet[descriptiveMergedSet==""] <- NA
descriptiveMergedSet$signaldomain[descriptiveMergedSet$signaldomain == "t"] <- "Time"
descriptiveMergedSet$signaldomain[descriptiveMergedSet$signaldomain == "f"] <- "Fourier"



## Part 5 of the project: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
message("Part 5 of the project: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.")

# Compute the average using an aggregation function.
# Remark: we remove the body2 and frequency column to compute the avergae because we think there are of no importance.
descriptiveMergedSet <- data.table(descriptiveMergedSet)
setkey(descriptiveMergedSet, activity_id, subject, activity_name, signaldomain, signal, instrument,
       jerk, magnitude, variable, axis)
tidyDataSet <- descriptiveMergedSet[, list(count=.N, average=mean(value)), by=key(descriptiveMergedSet)]

# Write the tidy data set.
write.table(tidyDataSet, "tidyDataSet.txt", row.names = FALSE)
message("Tidy data set created as \"tidyDataSet.txt\" file.")