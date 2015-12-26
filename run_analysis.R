library(dplyr)

## Download and unzip project data file
if(!file.exists("./downloaded.zip")){
    fileURL <- 
        "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, destfile = "downloaded.zip")
}
unzip("./downloaded.zip")

## Step 1: Merges the training and the test sets to create one data set
feature <- read.table("UCI HAR Dataset/features.txt", header = FALSE)

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "subjectId")
## Read x_train.txt and apply column names as found in features.txt. The same for x_test.txt.
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = feature[,2])
## Read y_train.txt and set column name, ready for merge. The same for y_test.txt.
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = "activityClass")
## Column bind all since all data is sorted.
train_data <- cbind(subject_train, y_train, x_train)

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "subjectId")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = feature[,2])
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "activityClass")
test_data <- cbind(subject_test, y_test, x_test)

## Row bind training and test data
all_data <- rbind(train_data, test_data)

## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement
## Use regex pattern to pick mean and standard deviation variables, plus subject and activity ids.
select_column_index <- grepl("subject|activity|mean|std", names(all_data), ignore.case = TRUE)
selected_data <- all_data[,select_column_index]

## Step 3: Uses descriptive activity names to name the activities in the data set
activity <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, 
                       sep = " ", col.names = c("activityClass", "activityName"))
## Merge on column "activityClass"
selected_data <- merge(activity, selected_data, all.x = TRUE)
selected_data <- selected_data[, 2:ncol(selected_data)]

## Step 4: Appropriately labels the data set with descriptive variable names
colnames(selected_data) <- gsub("mean","Mean",colnames(selected_data))
colnames(selected_data) <- gsub("std","StandardDeviation",colnames(selected_data))
## Remove any nonword charactor
colnames(selected_data) <- gsub("\\W","",colnames(selected_data))

## Step 5: From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject
tidy_data <- aggregate(selected_data[,4:ncol(selected_data)],
                       by = list(selected_data$subjectId, selected_data$activityName), FUN = mean)
names(tidy_data)[names(tidy_data) == "Group.1"] <- "subjectId"
names(tidy_data)[names(tidy_data) == "Group.2"] <- "activityName"

write.table(tidy_data, "tidy_data.txt", sep = " ", row.names = FALSE, col.names = TRUE)
