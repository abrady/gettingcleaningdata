# run_analysis.R
setwd("~/ocw/data_science/getting_and_cleaning_data_coursera/project");

# NOTE:
# please see README.md before running this script as there are some steps that must
# be performed before this script will operate properly


# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# 1. get and merge data
# 17 spaces, 561
# may need to run this: install.packages('LaF')
# LaF can handle large fixed width files efficiently
library(LaF)
library(data.table)
data_dirname <- 'data'

#this functon makes the activity names more readable form the supplied file
# original from http://stackoverflow.com/questions/11672050/how-to-convert-not-camel-case-to-camelcase-in-r
camel <- function(x){ #function for camel case
  capit <- function(x) paste0(toupper(substring(x, 1, 1)), tolower(substring(x, 2, nchar(x))))
  cam <- function(x) paste(capit(x), collapse="")
  t2 <- strsplit(x, "\\_")
  sapply(t2, cam)
}

# load a data set, label the columns from the provided features, and combine with the
# activities as named in the provided file
load_file <- function(subdir) {
  features = fread(file.path(data_dirname,'features.txt'))
  fn <- file.path(data_dirname,subdir,sprintf('X_%s.txt',subdir))
  d <- laf_open_fwf(fn,column_widths=rep(16,561),column_types=rep('double',561),column_names = features$V2)[,]
  
  # label activities
  activity_names <- fread(file.path(data_dirname,'activity_labels.txt'))
  activity_names <- lapply(activity_names$V2, camel)
  activity_type <- fread(file.path(data_dirname,subdir,sprintf('y_%s.txt',subdir)))
  Activity <- factor(activity_type$V1, labels=activity_names)
  d <- cbind(d,Activity)
  
  # add subjects
  Subject <- fread(file.path(data_dirname,subdir,sprintf('subject_%s.txt',subdir)))$V1
  d <- cbind(d,Subject)
}

d_test <- load_file('test')
d_train <- load_file('train')
d_combined <- rbind(d_test,d_train)

# 2. extract only mean and std of each measure
col_names <- names(d_combined)
cols <- col_names[grep('\\.(mean|std)\\.',col_names)]
cols <- c(c('Subject', 'Activity'),cols)
d_cols <- d_combined[,cols]

# 3. Uses descriptive activity names to name the activities in the data set

# done in load_file already

# 4. Appropriately labels the data set with descriptive variable names. 
readable_col_names <- c(
           "BodyAccelerationMeanX",
           "BodyAccelerationMeanY",
           "BodyAccelerationMeanZ",
           "BodyAccelerationStandardDeviationX",
           "BodyAccelerationStandardDeviationY",
           "BodyAccelerationStandardDeviationZ",
           "GravityAccelerationMeanX",
           "GravityAccelerationMeanY",
           "GravityAccelerationMeanZ",
           "GravityAccelerationStandardDeviationX",
           "GravityAccelerationStandardDeviationY",
           "GravityAccelerationStandardDeviationZ",
           "BodyAccelerationJerkMeanX",
           "BodyAccelerationJerkMeanY",
           "BodyAccelerationJerkMeanZ",
           "BodyAccelerationJerkStandardDeviationX",
           "BodyAccelerationJerkStandardDeviationY",
           "BodyAccelerationJerkStandardDeviationZ",
           "BodyGyroscopeMeanX",
           "BodyGyroscopeMeanY",
           "BodyGyroscopeMeanZ",
           "BodyGyroscopeStandardDeviationX",
           "BodyGyroscopeStandardDeviationY",
           "BodyGyroscopeStandardDeviationZ",
           "BodyGyroscopeJerkMeanX",
           "BodyGyroscopeJerkMeanY",
           "BodyGyroscopeJerkMeanZ",
           "BodyGyroscopeJerkStandardDeviationX",
           "BodyGyroscopeJerkStandardDeviationY",
           "BodyGyroscopeJerkStandardDeviationZ",
           "BodyAccelerationMagnitudeMean",
           "BodyAccelerationMagnitudeStandardDeviation",
           "GravityAccelerationMagnitudeMean",
           "GravityAccelerationMagnitudeStandardDeviation",
           "BodyAccelerationJerkMagnitudeMean",
           "BodyAccelerationJerkMagnitudeStandardDeviation",
           "BodyGyroscopeMagnitudeMean",
           "BodyGyroscopeMagnitudeStandardDeviation",
           "BodyGyroscopeJerkMagnitudeMean",
           "BodyGyroscopeJerkMagnitudeStandardDeviation",
           "FFTBodyAccelerationMeanX",
           "FFTBodyAccelerationMeanY",
           "FFTBodyAccelerationMeanZ",
           "FFTBodyAccelerationStandardDeviationX",
           "FFTBodyAccelerationStandardDeviationY",
           "FFTBodyAccelerationStandardDeviationZ",
           "FFTBodyAccelerationJerkMeanX",
           "FFTBodyAccelerationJerkMeanY",
           "FFTBodyAccelerationJerkMeanZ",
           "FFTBodyAccelerationJerkStandardDeviationX",
           "FFTBodyAccelerationJerkStandardDeviationY",
           "FFTBodyAccelerationJerkStandardDeviationZ",
           "FFTBodyGyroscopeMeanX",
           "FFTBodyGyroscopeMeanY",
           "FFTBodyGyroscopeMeanZ",
           "FFTBodyGyroscopeStandardDeviationX",
           "FFTBodyGyroscopeStandardDeviationY",
           "FFTBodyGyroscopeStandardDeviationZ",
           "FFTBodyAccelerationMagnitudeMean",
           "FFTBodyAccelerationMagnitudeStandardDeviation",
           "FFTBodyAccelerationJerkMagnitudeMean",
           "FFTBodyAccelerationJerkMagnitudeStandardDeviation",
           "FFTBodyGyroscopeMagnitudeMean",
           "FFTBodyGyroscopeMagnitudeStandardDeviation",
           "FFTBodyGyroscopeJerkMagnitudeMean",
           "FFTBodyGyroscopeJerkMagnitudeStandardDeviation")
first_col_names <- c("Subject","Activity")
readable_names <- c(first_col_names,
                    readable_col_names)
                    
names(d_cols) <- readable_names


# 5. Creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject. 

# convert to data.table for efficient subsetting
d <- data.table(d_cols)
d_tidy <- d[,lapply(.SD,mean),by=list(Subject,Activity)]
tidy_col_names <- lapply(readable_col_names, function(n) sprintf("Mean%s",n))
setnames(d_tidy, names(d_tidy), unlist(c(first_col_names, tidy_col_names)))

# write data out without line numbers
write.table(d_tidy,file = 'tidy_data.txt', row.names=F)
