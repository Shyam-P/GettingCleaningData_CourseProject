run_analysis <- function() {
	## The objective of the functions in this file are to create a 'tidy dataset'
	## The source files for the raw dataset are expected to be in a folder
	## named "UCI HAR Dataset" in the working directory. Else, 'rawDataPath' 
	## variable needs to be set appropriately.

	## The steps performed are as follows:
	## Read both data sets (train and test)
	## Merges the training and the test sets to create one data set.
	## Extracts only the measurements on the mean and standard deviation. 
	## Uses descriptive activity names to name the activities in the data set
	## Appropriately labels the data set with descriptive variable names. 
	## Write out the first dataset
	## A second tidy data set with the average of each variable for each activity
	## and each subject is also written out
	##
	## The files created are called: UCI HAR mean std Dataset.csv 
	##                             & UCI HAR mean std summary Dataset.csv
	## and these are stored in "UCI HAR Dataset" directory


	## Please note that all files are assumed to be available and no error 
	## checking is done for this assignment as focus is on generating the tidy
	## data set

	# Set the path for the raw data files
	rawDataPath="./UCI HAR Dataset"

	# Read the two common files: activity_labels.txt and features.txt
	fileActivityData <- file.path(rawDataPath, "activity_labels.txt")
	if (!file.exists( fileActivityData )) {
		stop( paste( "File not found: ", fileActivityData ) )
	}
	ActivityNames   <- read.table( fileActivityData, 
								  header=FALSE, 
								  colClasses=c("integer", "character"), 
								  col.names=c("ID", "ActivityName"),
								  sep=" ") 

	fileFeatureNames <- file.path(rawDataPath, "features.txt")
	if (!file.exists(fileFeatureNames)) {
		stop( paste( "File not found: ", fileFeatureNames ) )
	}
	FeatureNames   <- read.table( fileFeatureNames, 
	 							 header=FALSE, 
								 colClasses=c("integer", "character"), 
								 col.names=c("ID", "FeatureName"),
								 sep=" ") 

	# The following function shall simplify reading of the rest of the 6 files
	# It takes the file & path name components, and file mode
	# If mode is 0, file shall be read as integer vector using read.table
	# If mode is 1, file shall be read as text lines using readLines()
	readDataFromFile <- function( pathname="", folder="", filename="", mode = 0) {
		filepathname <- file.path( pathname, folder, filename )
		if (!file.exists( filepathname )) {
			stop( paste( "File not found: ", filepathname ) )
		}
		if ( !mode ) {
			data <- read.table( filepathname, header=FALSE, colClasses="integer")
		} else {
			data <- readLines( filepathname )
		}
	}

	# Read the 'train' data set files: subject_train, y_train, X_train
	subjectTrainData <- readDataFromFile(rawDataPath, "train", "subject_train.txt", 0)
	names(subjectTrainData) <- "Subject_ID"  # Set the col.name for the data frame

	yTrainData <- readDataFromFile(rawDataPath, "train", "y_train.txt", 0)
	XTrainData <- readDataFromFile(rawDataPath, "train", "X_train.txt", 1)

	# Read the 'test' data set files: subject_test, y_test, X_test
	subjectTestData <- readDataFromFile(rawDataPath, "test", "subject_test.txt", 0)
	names(subjectTestData) <- "Subject_ID"  # Set the col.name for the data frame

	yTestData <- readDataFromFile(rawDataPath, "test", "y_test.txt", 0)
	XTestData <- readDataFromFile(rawDataPath, "test", "X_test.txt", 1)

	# The X_train & X_test data has been read as Lines, as the data needs cleaning.
	# The following function shall perform the cleaning of the X_ datasets
	readXDataFromLines <- function(dataVec){
		# Trim the leading and trailing white space using grep()
		dataVec <- sub( "^ +", "", dataVec )
		dataVec <- sub( " +$", "", dataVec )
		
		# Reduce space between two numbers to a single comma
		dataVec <- gsub( " +",",", dataVec )
		
		# Split the data based on comma & convert to numeric
		dataList <- strsplit( dataVec, "," )
		dataList <- lapply( dataList, as.numeric )
		
		# Finally convert to a dataframe
		df <- data.frame(dataList)
		
		# The above is filled column wise and hence we need to transpose it
		df <- t(df)
	}

	# Get the data frames for the X-train and X_test (read as lines of text)
	X_train.df <- readXDataFromLines( XTrainData )
	X_test.df  <- readXDataFromLines( XTestData )
		
	# 2 types of merging are needed.
	# First we merge columnwise the y_train and the subject_train with X_train
	trainMerged.df <- cbind( yTrainData, subjectTrainData, X_train.df )
	testMerged.df  <- cbind( yTestData, subjectTestData, X_test.df )

	# Now merge the two (train & test) sets to get target dataframe
	Target.df <- rbind( trainMerged.df, testMerged.df)
	
	# Generate record number vector. Set colnames and rownames
	recordNumber <- seq_len( nrow( Target.df ) )
	colNames <- c("ActivityName", "Subject_ID", FeatureNames$FeatureName)
	colnames( Target.df ) <- colNames
	rownames( Target.df ) <- recordNumber
	
	# Use descriptive names for activities
	Target.df$ActivityName <- ActivityNames$ActivityName[Target.df$ActivityName]
	
	# For the first tidy data set, we need to retrieve the 'mean' & 'std' name
	rNames <- names( Target.df )
	indexShortListedNames <- grep("-mean\\(|-std\\(", rNames) # Avoid meanFreq
	FirstTidyDataSet <- Target.df[, c(1,2,indexShortListedNames)] 
	
	# Write the first tidy data set 
	outfile1 = file.path( rawDataPath, "UCI_HAR_mean_and_std_measurements.csv" )
	write.table( FirstTidyDataSet, file=outfile1, sep=",")
	
	# The second tidy data set requires that we evaluate the mean for each variable
	# in the above data set for each activity and subject. To do this, first split
	# the FirstTidyDataSet based on Activity and Subject_ID
	tmpData <- split( FirstTidyDataSet, list( FirstTidyDataSet$ActivityName, 
											  FirstTidyDataSet$Subject_ID ) )
	SecondTidyDataSet <- sapply(tmpData, function(x) colMeans(x[,c(-1,-2)]))
	SecondTidyDataSet <- t( SecondTidyDataSet )
	
	# Add the Activity Name and Subject ID columns to the data frame 
	tmpActivity <- c("LAYING", "SITTING", "STANDING", "WALKING", 
	                 "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS")
	tmpVec1 <- rep(tmpActivity,times=30)
	tmpVec2 <- rep(1:30, each=6)
	SecondTidyDataSet <- data.frame( ActivityName=tmpVec1, Subject_ID=tmpVec2,
	                                 SecondTidyDataSet )
	
	# Write out the second tidy Data set as a .csv file
	outfile2 = file.path( rawDataPath, "UCI_HAR_average_factor_values.csv" )
	write.table( SecondTidyDataSet, file=outfile2, sep=",")
}