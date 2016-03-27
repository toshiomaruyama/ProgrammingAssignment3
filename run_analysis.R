# Load Libraries
library(data.table)
library(reshape2)


# Set Working Directory
setwd("~/99.Workspace/R/ProgrammingAssignment3")

# Download File
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- file.path(getwd(), "Dataset.zip")
download.file(url, f)

# Unzip directory in Working Directory
unzip("Dataset.zip")

# Read Column Names
ColumnName <- read.table(file.path(getwd(),"UCI HAR Dataset", "features.txt"))[,2]
# Load Activity Lables
activity_labels <- read.table(file.path(getwd(),"UCI HAR Dataset", "activity_labels.txt"))[,2]


# Test 
        # Load Data
        dfX_Test  <- read.table(file.path(getwd(),"UCI HAR Dataset", "test" , "X_test.txt" ))
        dfy_Test  <- read.table(file.path(getwd(),"UCI HAR Dataset", "test" , "y_test.txt" ))
        dfSubject_Test  <- read.table(file.path(getwd(),"UCI HAR Dataset", "test", "subject_test.txt"))
        
        # Assign ColumnName
        names(dfX_Test) = ColumnName
        
        # Get Mean and Std
        dfX_Test = dfX_Test[,grepl("mean|std", ColumnName)]
        
        # Copy Activity Label to y_Test
        dfy_Test[,2] = activity_labels[dfy_Test[,1]]
        
        # Rename column Names
        names(dfy_Test) = c("Activity_ID", "Activity_Label")
        names(dfSubject_Test) = "subject"
        
        # Bind data
        dfTest <- cbind(as.data.table(dfSubject_Test), dfy_Test, dfX_Test)
        
# Train
        # Load Data
        dfX_Train  <- read.table(file.path(getwd(),"UCI HAR Dataset", "train" , "X_train.txt" ))
        dfy_Train  <- read.table(file.path(getwd(),"UCI HAR Dataset", "train" , "y_train.txt" ))
        dfSubject_Train  <- read.table(file.path(getwd(),"UCI HAR Dataset", "train", "subject_train.txt"))
        
        # Assign ColumnName
        names(dfX_Train) = ColumnName
        
        # Get Mean and Std
        dfX_Train = dfX_Train[,grepl("mean|std", ColumnName)]
        
        # Copy Activity Label to y_Test
        dfy_Train[,2] = activity_labels[dfy_Train[,1]]
        
        # Rename column Names
        names(dfy_Train) = c("Activity_ID", "Activity_Label")
        names(dfSubject_Train) = "subject"
        
        # Bind data
        dfTrain <- cbind(as.data.table(dfSubject_Train), dfy_Train, dfX_Train)
        
# Merge Test and Train Data
        data = rbind(dfTest, dfTrain)
        
        # Set variables to export and accomodate the other columns
        data_labels = setdiff(colnames(data), c("subject", "Activity_ID", "Activity_Label"))
        melt_data = melt(data, id = c("subject", "Activity_ID", "Activity_Label"), measure.vars = data_labels)
        
        # Apply mean function to dataset using dcast function
        tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
        
        # Export
        write.table(tidy_data, file = file.path(getwd(),"tidy_data.txt"))