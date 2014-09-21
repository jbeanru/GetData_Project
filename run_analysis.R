
# Description:
#	run_analysis.R for Getting and Cleaning Data Course Project.
#
# Usage:
#	just open and run this script in you RStudio. It will prepare all
#	prerequisites if necessary (e.g. download and extract the data file), 
#	and generate the tidy data file in your working directory.
#
# Steps:
# 	1. Merge the training and the test sets to create one data set.
#	2. Extract only the measurements on the mean and standard deviation. 
#	3. Use descriptive activity names to name the activities.
#	4. Label the data set with descriptive variable names appropriately. 
#	5. Create a tidy data set with the average of each variable for each 
#	   activity and each subject, from the data set in step 4.


## Step 0: Preparation:
#	Data preparation and functions definition

# ensure the project data existing in the working directory
#	if not, download and extract the data.
if(!file.exists("UCI HAR Dataset")) { 
	if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")){
		url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
		
		# not use method="curl" argument, because I run on Windows OS
		download.file(url, mode = "wb", destfile = "getdata-projectfiles-UCI HAR Dataset.zip")
	}
	
	# extract the zip file, and get the project data
	unzip("getdata-projectfiles-UCI HAR Dataset.zip", overwrite = TRUE)
}

# function to format string into "Mixed Case" Capitalizing (Upper Camel Case)
#	I prefer 'UpperCamelCase' Naming convention for meaningful names
#	The function will be used in Step 3 and Step 4. Examples:
#		"it iS an example" to "ItIsAnExample"
#		"it_IS(),  aN-EXAMPLE" to "ItIsAnExample"
#		
tocamel <- function(s, strict = TRUE) {
	cap <- function(s) 
		paste(
			toupper(substring(s, 1, 1)),
			{
				s <- substring(s, 2); 
				{if(strict) tolower(s) else s} 
				},
			sep = "", 
			collapse = ""
			)
	
	# the split is all special characters in the project data
	sapply(strsplit(s, split = "( |_|-|\\(|\\)|,)+"), cap, 
	       USE.NAMES = !is.null(names(s)))
}


## Step 1： Merge the training and the test data sets to create one big data set.

# merge the training and test data set
# 	'data.frame':	10299 obs. of  561 variables
mergedSet <- rbind(
	read.table("./UCI HAR Dataset/train/X_train.txt"),
	read.table("./UCI HAR Dataset/test/X_test.txt")
)


## Step 2： Extract only the measurements on mean and standard deviation.	
#	The course instruction is a little vague here. 
#	I only select those columns whose name contains 'mean()' or 'std()', 
#	other classmates may retrieve the columns whose name contains 'main' 
#	or std". I'll consider both solutions are acceptable.

# load the names of the measurements
#	'data.frame':	561 obs. of  2 variables
features <- read.table("./UCI HAR Dataset/features.txt")

# get a vector of boolean to indicate which columns are selected measurements.
#	'logical':  [1:561]
measurementSelectionRule <- grepl("(mean|std)\\(\\)", features[,2])

# get a set only contains the measurements on mean and stand deviation.
#	'data.frame':	10299 obs. of  66 variables
selectedSet <- mergedSet[,measurementSelectionRule]


## Step 3: Use descriptive activity names to name the activities in the data set.

# load the activity labels of the data set
#	'data.frame':	10299 obs. of  1 variable
activityLabels <- rbind(
	read.table("./UCI HAR Dataset/train/y_train.txt"),
	read.table("./UCI HAR Dataset/test/y_test.txt")
)

# load the labels-names mappings of activities
# 	'data.frame':	6 obs. of  2 variables
labelNameMappings <- read.table("./UCI HAR Dataset/activity_labels.txt")

# get activity names in Camel Case(e.g. 'WALKING_UPSTAIRS' to 'WalkingUpstairs')
#	Factor: 10299 obs. of  1 variable
#	Levels: Walking, WalkingUpstairs, WalkingDownstairs, Sitting, Standing, Laying
activities <- factor(activityLabels[,1], 
		     labels = tocamel(as.character(labelNameMappings[, 2])))

# name the activities in the data set
#	'data.frame':	10299 obs. of  67 variables
#	activities	V1		V2         	V3		......
#	Standing	0.2885845	-0.02029417 	-0.1329051	......
#	Standing 	0.2885845 	-0.02029417 	-0.1329051	......
descriptiveSet <- cbind(activities, selectedSet)


## Step 4: Label the data set with descriptive variable names appropriately.

# load the subjects
# 	'data.frame':	10299 obs. of  1 variable
subjects <- rbind(
	read.table("./UCI HAR Dataset/train/subject_train.txt"),
	read.table("./UCI HAR Dataset/test/subject_test.txt")
)

# combine the subjects with the set
#	'data.frame':	10299 obs. of  1 variable
step4Dataset <- cbind(subjects, descriptiveSet)

# get the original names of selected measurements 
#	the measurements selection rule is generaged in step 2.
#	'factor': 66 obs.
selectedMeasureNames <- features[measurementSelectionRule, 2]

# convert prefix 't' in names to 'Time'. 
#	e.g. 'tBodyGyro-mean()-X' to 'TimeBodyGyro-mean()-X'
selectedMeasureNames <- sub("^t", "Time", selectedMeasureNames)

# convert prefix 'f' in names to 'Frequency'
selectedMeasureNames <- sub("^f", "Frequency", selectedMeasureNames)

# convert 'BodyBody' in names to 'Body'
selectedMeasureNames <- sub("BodyBody", "Body", selectedMeasureNames)

# convert the abbreviations
#	'Acc' to 'Acceleration'
#	'Gyro' to 'Gyroscope'
#	'Mag' to 'Magnitude'
#	'Std' - don't convert it.
selectedMeasureNames <- sub("Acc", "Acceleration", selectedMeasureNames)
selectedMeasureNames <- sub("Gyro", "Gyroscope", selectedMeasureNames)
selectedMeasureNames <- sub("Mag", "Magnitude", selectedMeasureNames)

# convert to Camel  Case Naming Convertions
selectedMeasureNames <- tocamel(as.character(selectedMeasureNames), strict = FALSE)

# set descriptive names for columns of the step 4 data set
colnames(step4Dataset)  <- c("Subjects", "Activities", selectedMeasureNames)

# get the Step 4 final result
#	'data.frame':	10299 obs. of  68 variables
#	the 68 variables(columns) are: Subjects + Activities + 66 Measurements
step4Dataset


## Step 5: Create the tidy data - averages groupped activities and subjects.

library(dplyr)

# create the tidy data. 	
tidyData <- group_by(step4Dataset, Subjects, Activities) %>% 
	summarise_each(funs(mean))

# add prefix 'Average' to the 66 measurements names.
#	e.g. 'TimeBodyAccelerationMagnitudeMean' to 'AverageTimeBodyAccelerationMagnitudeMean'
colnames(tidyData)  <- c("Subjects", "Activities", 

			 sub("^" , "Average", selectedMeasureNames))

# DONE!!!
#
#	tidyData is the tidy data set required.	Where:
#		Final Result: 180 observes of  68 variables (180 * 68)
#		68 variables = Subjects Col + Activities Col + 66 Measurements
#

# SAVE the the tidy data to text file TidyData.txt
write.table(tidyData, file = "TidyData.txt", row.name=FALSE)


## References:
#	[1] https://class.coursera.org/getdata-007/human_grading/view/courses/972585/assessments/3/submissions
#	[2] https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#	[3] http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#	[4] http://en.wikipedia.org/wiki/CamelCase
#
#
## Acknowledgments:
# 	[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and 
#	Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using 
#	a Multiclass Hardware-Friendly Support Vector Machine. International 
#	Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, 
#	Spain. Dec 2012