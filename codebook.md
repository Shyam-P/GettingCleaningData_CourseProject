# ==================================================================
# Human Activity Recognition Using Smartphones Dataset
# Version 1.0
# ==================================================================

A total of 10299 experiments were conducted on 30 subjects within the age group of 19-48 years. Measurements were done, when each person performed one in 6 activities, using the accelerometer and gyroscope on the Samsung Galaxy S II smartphone. The data from these measurements have been processed into the following tables:

#### 1. Mean and standard deviation measurements - UCI_HAR_mean_and_std_measurements.csv

This table contains 68 fields, and lists the mean and std deviation measurements for various factors. There are a total of 10299 records.

> 1. ActivityName: Is one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING. Type=character.
> 2. Subject_ID: Lists the serial number of the subject (from 1 to 30) from whom measurements were taken. Type=Integer.

> 3. to 68. These fields have values of the following factors:

> > *  "fBodyAcc"
> > *  "fBodyAccJerk"
> > *  "fBodyAccMag"
> > *  "fBodyBodyAccJerkMag"
> > *  "fBodyBodyGyroJerkMag"
> > *  "fBodyBodyGyroMag"
> > *  "fBodyGyro"
> > *  "tBodyAcc"
> > *  "tBodyAccJerk"
> > *  "tBodyAccJerkMag"
> > *  "tBodyAccMag"
> > *  "tBodyGyro"
> > *  "tBodyGyroJerk"
> > *  "tBodyGyroJerkMag"
> > *  "tBodyGyroMag"
> > *  "tGravityAcc"
> > *  "tGravityAccMag" 

The measurements in each of the fields from 3 to 68 are either for the "mean" or the "standard deviation" for one of the above factors. The factor name is suffixed respectively with a ".mean" or a ".std".

Further, some factors may have a X, Y or Z component. The corresponding name (which would already be having a ".mean" or ".std" suffix) is again suffixed with a "..X", "..Y" or "..Z". For example, *"tBodyGyroJerk.mean...X", "tBodyGyroJerk.mean...Y" or "tBodyGyroJerk.mean...Z"*.

All values for the factors are normalized and bounded within [-1,1]

The exact names of 66 factors are (Type=numeric):

***
##### *tBodyAcc.mean...X, tBodyAcc.mean...Y, tBodyAcc.mean...Z, tBodyAcc.std...X, tBodyAcc.std...Y, tBodyAcc.std...Z*           
##### *tGravityAcc.mean...X, tGravityAcc.mean...Y, tGravityAcc.mean...Z, tGravityAcc.std...X, tGravityAcc.std...Y, tGravityAcc.std...Z*      
##### *tBodyAccJerk.mean...X, tBodyAccJerk.mean...Y, tBodyAccJerk.mean...Z, tBodyAccJerk.std...X, tBodyAccJerk.std...Y, tBodyAccJerk.std...Z*      
##### *tBodyGyro.mean...X, tBodyGyro.mean...Y, tBodyGyro.mean...Z, tBodyGyro.std...X, tBodyGyro.std...Y, tBodyGyro.std...Z*         
##### *tBodyGyroJerk.mean...X, tBodyGyroJerk.mean...Y, tBodyGyroJerk.mean...Z, tBodyGyroJerk.std...X, tBodyGyroJerk.std...Y, tBodyGyroJerk.std...Z*     
##### *tBodyAccMag.mean.., tBodyAccMag.std..*      
##### *tGravityAccMag.mean.., tGravityAccMag.std..*
##### *tBodyAccJerkMag.mean.., tBodyAccJerkMag.std..*      
##### *tBodyGyroMag.mean.., tBodyGyroMag.std..*
##### *tBodyGyroJerkMag.mean.., tBodyGyroJerkMag.std..*
##### *fBodyAcc.mean...X, fBodyAcc.mean...Y, fBodyAcc.mean...Z, fBodyAcc.std...X, fBodyAcc.std...Y, fBodyAcc.std...Z*
##### *fBodyAccJerk.mean...X, fBodyAccJerk.mean...Y, fBodyAccJerk.mean...Z, fBodyAccJerk.std...X, fBodyAccJerk.std...Y, fBodyAccJerk.std...Z*
##### *fBodyGyro.mean...X, fBodyGyro.mean...Y, fBodyGyro.mean...Z, fBodyGyro.std...X, fBodyGyro.std...Y, fBodyGyro.std...Z*
##### *fBodyAccMag.mean.., fBodyAccMag.std..*          
##### *fBodyBodyAccJerkMag.mean.., fBodyBodyAccJerkMag.std..*
##### *fBodyBodyGyroMag.mean.., fBodyBodyGyroMag.std..*
##### *fBodyBodyGyroJerkMag.mean.., fBodyBodyGyroJerkMag.std..*
***


#### 2. Average factor values - UCI_HAR_average_factor_values.csv
This table has the same number of fields as in table #1 and with exactly the same description and meaning. The values in the records, however, shows the average values for the factors in each field. Averaging has been done for each activity and subject from the above table to provide a summary result. As there are 6 activities and 30 subjects, the total number of records in this table is 6 * 30 = 180

NOTE
----

The data for the above tables has been derived from the raw data set provided at the following URL:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

From the above data set, the following common files have been used:
* activity_labels.txt which list the activity names with code
* features.txt which has the factor names for the 561 feature vector.

The following files from the "train" and "test" sub-folders have been used:
X_Train.txt & X_test.txt: Measurements for the 561 feature vector per record
y_train.txt & y_test.txt:  The id of the activity for each record in X_train & X_test respectively
subject_train.txt and subject_test.txt: Id of the subject for each record in in X_train & X_test respectively

The following steps were performed to arrive at each data set:
#### 1. UCI_HAR_mean_and_std_measurements.csv
The source files for this is the raw data set described above.

##### a. Cleaning
All the 561 features in each record within X_train and X_test files are listed as space/tab separated values. The leading /trailing blanks are inconsistent across records, as also is the space between values. An "as-is" processing would therefore lead to different values being read per record. Hence, the following steps were conducted for each record:
a.1 Leading blanks were trimmed
a.2 Trailing blanks were trimmed
a.3 Spaces between numbers were replaced by a single ","
a.4 Each of the values were extracted and converted to a number

##### b. Merging
b.1 Each of the measurement in the X_train and X_test file corresponds to an activity and subject, which are listed in the corresponding row in the y_train.txt/y_test.txt and subject_train.txt/subject_test.txt files. The records were concatenated column-wise so that each record now has the activity id and the subject id too alongwith the 561 feature numbers. This was done for the train and test data sets separately.
b.2 The test and train datasets were then combined into one single data set.

##### c. Labelling
The column names in the dataset were provided with meaningful/original feature names.
Rows were provided with record numbers.

##### d. Output
Dataset was written as comma-separated fields per record with header listing field names.
This resulted in *UCI_HAR_mean_and_std_measurements.csv* file getting generated.

#### 2. UCI_HAR_average_factor_values.csv
The source file for this is the output of the first data processing: *UCI_HAR_mean_and_std_measurements.csv* file

##### a. Splitting
The file is split based on activity and subject, so as to get a set of records for each activity & subject id. There are 6 activities and 30 subjects leading to 180 combinations.

##### b. Evaluating Mean
Column mean for each of the 66 factors in the source file were evaluated for each of the split groups. 

##### c. Output
The data for the means per group was combined with the respective activity id & subject id to generate a comma-separated values per record in the file *UCI_HAR_average_factor_values.csv*