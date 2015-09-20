# Codebook

## Original data
The original data can be found at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Its description is the following and located at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones:

    Data Set Information:
    ---------------------
    The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
    
    The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.
    
    Check the README.txt file for further details about this dataset.
    
    Attribute Information:
    ----------------------
    For each record in the dataset it is provided: 
    - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
    - Triaxial Angular velocity from the gyroscope. 
    - A 561-feature vector with time and frequency domain variables. 
    - Its activity label. 
    - An identifier of the subject who carried out the experiment.


## Data Acquisition
The script "run_analysis.R" automatically acquire the data for the link referenced above.


## Tidy dataset format
The format of the tidy dataset is the following.

|Column name           | Description                                               |
|:---------------------|:----------------------------------------------------------|
|activity_id           | Id of the activity                                        |
|subject               | Id of the subject                                         |
|activity_name         | Name of the activity                                      |
|signaldomain          | Time or frequency (Fourier) domain signal                 |
|signal                | Acceleration signal (Body or Gravity)                     |
|instrument            | Measuring instrument                                      |
|jerk                  | Jerk signal                                               |
|magnitude             | Magnitude of the signal                                   |
|variable              | Variable (mean or sd)                                     |
|axis                  | Axis of the measure                                       |
|count                 | Number of values used to compute the mean                 |
|average               | Mean for each variable for each activity and each subject |

The file name is "tidyDataSet.txt".

The format of the file is CSV as the write.table output without paramters. The first row contains the variable names and the subseqyent rows contain the values.