library(reshape2)

#merge training and test sets
subjects_train <- read.table("subject_train.txt")
subjects_test <- read.table("subject_test.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")

names(subjects_train) <- "sid"
names(subjects_test) <- "sid"

# add feature names
features <- read.table("features.txt")
names(X_train) <- features$V2
names(X_test) <- features$V2

# merge sets
train <- cbind(subjects_train, y_train, X_train)
test <- cbind(subjects_test, y_test, X_test)
combined <- rbind(train, test)

# mean and standard deviation 
musd <- grepl("mean\\(\\)", names(combined)) | grepl("std\\(\\)", names(combined))

# remove others
combined <- combined[, musd]

# factorize activity
labs = c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
combined$activity <- factor(combined$activity, labels = labs)

# TIDY!
melted <- melt(combined, id = c("sid", "activity"))
tidy <- dcast(melted, subjectID + activity ~ variable, mean)

# write it out 
write.csv(tidy, "tidy.csv", row.names=FALSE)
