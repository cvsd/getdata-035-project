# Getting and Cleaning Data Course Project

The purpose of this project is to prepare tidy data that can be used for later analysis. 

* First, download project data in local working folder if this is not done yet. Unzip the downloaded zip file.
* Step 1: Merges the training and the test sets to create one data set. Txt files are read into data frames respectively. Name the columns of x_train with feature names found in features.txt. Column bind subject_train, y_train and x_train into one data frame. Do the same for test data. Then row bind these two into one single data frame holding all data.
* Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. Use a regex pattern to form a logical vector selecting requested measurements, plus subject id and activity class id. Subset into selected data frame.
* Step 3: Uses descriptive activity names to name the activities in the data set. Read activity_labels.txt into data frame, then merge with selected data frame. Once activity name merged into selected data frame, the activity class id variable is no longer needed.
* Step 4: Appropriately labels the data set with descriptive variable names. This is partly done when reading x_train and x_test with naming of columns by features label frome features.txt (cf.Step 1). Additionally, any nonword charactor is removed from variable names.
* Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. The function aggregate() is used to calculate average of each variable selected in Step 2; the grouping index is subject id and activity name.
* Finally, output tidy data set to local working foler as tidy_data.txt.
