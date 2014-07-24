
run_Analysis <- function() {
	dataset <- generate_dataset()
	extractedDataset <- extract_measurements(dataset)
	labelledDataset <- label_data_set(extractedDataset)
	tidyDataset <- aggregate_data_set(labelledDataset)
	write_to_file(tidyDataset)
}

generate_dataset <- function() {
	
	print("Reading Data Files . . ")
	
	activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
	features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
	
	subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")	
	X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
	Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
	
	subject_training <- read.table("./UCI HAR Dataset/train/subject_train.txt")
	X_training <- read.table("./UCI HAR Dataset/train/X_train.txt")
	Y_training <- read.table("./UCI HAR Dataset/train/y_train.txt")
	
	print("Generating Test and Training Datasets")
	
	testData <-  generate_combined_data(subject_test, X_test, Y_test, activity, features)
	trainingData <- generate_combined_data(subject_training, X_training, Y_training, activity, features)
	dataset <- combine(testData, trainingData)
	
	dataset
}

generate_combined_data <- function(subject_data, X_data, Y_data, activity, features) {
	descriptive_Y_data <- data.frame(v1=activity[match(Y_data$V1, activity$V1), 2])	
	colnames(subject_data) <- "subjectID"
	colnames(X_data) <- features$V2[1:561]
	colnames(descriptive_Y_data) <- "activity"

	test_data <- cbind(subject_data, descriptive_Y_data, X_data)
	
	test_data
}

combine <- function(dataset1, dataset2) {
	print("Combining Test & Training Datasets")
	combined_dataset <- rbind(dataset1, dataset2)	
}

extract_measurements <- function(dataset) {
	print("Extracting Measurements on Mean and Standard Deviation")
	
	extracted_columns_on_mean <- grep( 'mean()', colnames(dataset), fixed=TRUE)		
	extracted_columns_on_standard_deviation <- grep( 'std()', colnames(dataset), fixed=TRUE)	
	
	df <- cbind(dataset[1:2])
	df <- cbind(df, dataset[ , extracted_columns_on_mean])	
	df <- cbind(df, dataset[ , extracted_columns_on_standard_deviation])
	
	df
}

label_data_set <- function(dataset) {
	print("Labelling Dataset with descriptive variable names")
	pattern <- c("^t", "^f", "X", "Y", "Z", "Acc", "Mag", "Gyro", "-mean", "-std", "-", "\\()")
	replacement <- c("time", "frequency", "Xaxis", "Yaxis", "Zaxis", "Acceleration", "Magnitude", "Gyroscope", "Mean", "StdDeviation", "", "")

	labels <- multi_gsub(pattern, replacement, colnames(dataset))
	colnames(dataset) <- labels
	
	dataset
}

multi_gsub <- function(pattern, replacement, x, ...) {
  if (length(pattern)!=length(replacement)) {
    stop("Pattern and Replacement vectors do not match")
  }
  result <- x
  for (i in 1:length(pattern)) {
    result <- gsub(pattern[i], replacement[i], result, ...)
  }
  result
}

aggregate_data_set <- function(dataset) {
	print("Aggregating the average of  each variable for each subject and activity")
	
	library(plyr)
	aggregated_data_set <- ddply(dataset, .(subjectID, activity), numcolwise(mean))
	
	aggregated_data_set
}

write_to_file <- function(dataset) {
	print("Writing Tidy Data Set to file tidyOutput.txt")
	write.csv(dataset, file = "./tidyOutput.csv")
}