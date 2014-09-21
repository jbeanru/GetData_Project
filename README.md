Project Submission for Getting and Cleaning Data
=====================================
Author: JBean (https://github.com/jbeanru/GetData_Project)

Background
--------------------------
This is the submission for project of the Coursera course "Getting and Cleaning Data". The purpose of the project is to demonstrate students' ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis.

Please find in the following link for the detailed project requirements:

* https://class.coursera.org/getdata-007/


File List
--------------------------
The repository contains those files:

    * README.md - this document.

    * TidyData.txt - a tidy dataset which is required by the course project.

    * CodeBook.md - the code book of the data set which explains the dataset.

    * run_analysis.R - the R script to get, clean data and generate the tidy data set required.


Explanation of run_analysis.R
--------------------------

run_analysis.R is the R script required by the project, which will get, clean data and generate the tidy data set required.

### Usage:
In order to run the script run_analysis.R, you need to do nothing beforehand but just open and run it in your RStudio.

The script is self-contained. It will prepare all prerequisites if necessary (e.g. download and extract the data file if not existing), and generate the tidy data file in your working directory.


### Steps:
The script run_analysis.R do the following tasks as required:
 
 
    0. Do necessary preparations, such as: downloading and extracting the data file if needed, etc.
 	
    1. Merge the training and the test sets to create one data set.
    
    2. Extract only the measurements on the mean and standard deviation. 
	
    3. Use descriptive activity names to name the activities.
    
    4. Label the data set with descriptive variable names appropriately. 
    
    5. Create a tidy data set with the average of each variable for each activity and each subject, 
    from the data set in step 4.
    
Please find the comments in the run_analysis.R script for details. The code comments explain every line of the code nearly, as well as the thoughts and considerations of the script logic.

###Outputs:

The script will give the following outputs:
    
    1. An in-Memory data frame of RStudio(If using it, others are similiar here) which stores the 
    tidy data required.
    
    2. A text file named 'TidyData.txt' is saved in the working directory. The file is the saving result
    of the 'tidyData' data frame. The file is created with write.table() using row.name=FALSE.

 
References
---------------------------
    1. https://class.coursera.org/getdata-007/
    2. https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
    3. http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
    4. http://en.wikipedia.org/wiki/CamelCase


Acknowledgments
---------------------------
 	1. Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and 
	Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using 
	a Multiclass Hardware-Friendly Support Vector Machine. International 
	Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, 
	Spain. Dec 2012
	
	2. The online markdown editor: http://jbt.github.io/markdown-editor/
