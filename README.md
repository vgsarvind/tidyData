tidyData
========

This outlines the way in which the "run_analysis.R" script should be interpreted.

Data Input
==========

The raw input considered here is the *Human Activity Recognition Using Smartphones Dataset
Version 1.0* that contains data collected from the accelerometers from the Samsung Galaxy S smartphone from 30 volunteers(subjects) while each performed six activities (Walking, Standing etc.)

More information on the dataset can be had from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

A snapshot can be found in the github repository (the folder *UCI HAR Dataset*)

Data Output
===========

The tidy data output expected out of the processing of this data, is a dataset that contains the average of each variable for a combination of each unique activity and subject.

A snapshot can be found in the github repository (the *tidyOutput.csv* file)

The run_Analysis script
=======================

This generates the tidy data output that can be used for further processing by data scientists from the data input. It makes use of various R functions for doing so,

Running the Script
==================

- Load the R script into your workspace using the source command: **source(path-to-script-file)**
- Call the run_Analysis method: **run_Analysis()**

Description of Methods
======================

1. run_Analysis : A function that calls other functions to read, extract, label, aggregate and write data.
2. generate_dataset : A function that reads the training and test dataset files, the activity and feature files from the 'UCI HAR Dataset' directory in our working directory and generates a combined training dataset and a test dataset.
3. generate_combined_data : A function that replaces that the activity_id with the corresponding name and labels the columns of the data appropriately.
4. combine : Function that merges training and test data into one.
5. extract_measurements : Function that pulls measurements pertaining to 'mean' and 'standard deviation' metrics from the data [metrics *derived* from mean values (such as meanFrequency, gravityMean etc. are not considered)
6. label_data_set : Function that provides descriptive column names names to the variables
7. multi_gsub : A utility function that aids in the pattern replacement of multiple values at the same time.
8. aggregate_data_set : Function that aggregates the average of each variable for each subject and activity
9. write_to_file : Function that writes the tidy data generated into a csv file named "tidyOutput" in the working directory

Assumptions
===========

This script assumes that:
1. You have the Samsung dataset (extracted version from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) in your R working directory
2. You have the "plyr" package in R installed. If not, install it using **install.packages("plyr")** command
