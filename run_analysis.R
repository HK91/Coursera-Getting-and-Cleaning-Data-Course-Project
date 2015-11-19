# Step 1 
# Merge the training and test sets to create one data set 
############################################################################### 

train_x <- read.table("train/x_train.txt") 
train_y <- read.table("train/y_train.txt") 
subject_train <- read.table("train/subject_train.txt") 

test_x <- read.table("test/X_test.txt") 
test_y <- read.table("test/y_test.txt") 
subject_test <- read.table("test/subject_test.txt") 

# create 'x' data set 
data_x <- rbind(train_x,test_x) 

# create 'y' data set 
data_y <- rbind(train_y, test_y) 

# create 'subject' data set 
subject_data <- rbind(subject_train, subject_test) 

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

features <- read.table("features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
data_x <- data_x[, mean_and_std_features]

# correct the column names
names(data_x) <- features[mean_and_std_features, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table("activity_labels.txt")

# update values with correct activity names
data_y[, 1] <- activities[data_y[, 1], 2]

# correct column name
names(data_y) <- "activity"

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
data_all <- cbind(data_x, data_y, subject_data)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(data_all, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)
