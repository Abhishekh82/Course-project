# Course-project #
# Install the dplyr package#
install.packages("dplyr")
library("dplyr")

#create the Course4dat file in current dir#

if (!file.exists("Course4dat")) {
  dir.create("Course4dat")
}
#change the work directory to Course4dat dir#

setwd(paste(getwd(), "Course4dat", sep = "/"))

#download course data and unzip file#

myurl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(myurl, paste(getwd(), "data.zip", sep = "/"))
unzip("data.zip")

# Set the right work directory where the data is stored for test#
setwd(paste(getwd(), "UCI HAR Dataset/test", sep = "/"))

# As the file is a text file read through read.table #
# Read Subject_test/train, X_test/train, Y_test/train files #
# Upload the data in R #

subject_test<- read.table("subject_test.txt")
X_test<- read.table("X_test.txt")
Y_test<- read.table("Y_test.txt")
setwd('..')

# Set the right work directory where the data is stored for train#

setwd(paste(getwd(), "train", sep = "/"))
subject_train<- read.table("subject_train.txt")
X_train<- read.table("X_train.txt")
Y_train<- read.table("Y_train.txt")

# Set the right work directory where the data is stored for activity labels and features #
# read activity labels and featues files through read.table #

setwd('..')
activity_labels<- read.table("activity_labels.txt")
features<- read.table("features.txt")

# Join test/train data for activity numbers with activity labels, without sorting, using inner_join. This is solution to problem 3 of the course project#
Y1_test<- inner_join(Y_test, activity_labels)

# Rename the columns with label and labeldesc names for test and train files#

Y1_test<- rename(Y1_test, label = "V1", labeldesc = "V2")

# Rename test Subject file column to Subject#

subject_test<- rename(subject_test, Subject = "V1")
Y1_train<- inner_join(Y_train, activity_labels)
Y1_train<- rename(Y1_train, label = "V1", labeldesc = "V2")
subject_train<- rename(subject_train, Subject = "V1")

# combine the columns for Subject_test files, modified Y1_test file and X_test files, repeat this for train file as well; store the data in train and test objects#

test<- cbind(subject_test, Y1_test, X_test)
train<- cbind(subject_train, Y1_train, X_train)

# use rbind to combine the rows for train and test in the data object #
# This is solution to the Question 1 problem#

data<- rbind(train, test)

# select all the variable elements containing the word "mean" and "std" as the 2 point in the problem requests to pull measurements which relate to mean and std deviation#

sel<- c(grep("mean", features$V2), grep("std", features$V2))

# Rename the columns (V1:V561) in the data set with features names using rename_at; This is solution to problem 4 of the project#

data1<- rename_at(data, vars(V1:V561), ~features$V2)

# create new vector, called sel1, with column numbers of sel with colmns 1 to 3 included as data has 3 extra columns in the beginning#

sel1<- c(1:3, sel+3)

# Selected column numbers of sel1 object from data1 object and store the information in data2#

data2<- data1[,sel1]

# group data2 by Subject and labeldesc column and store the information in data3 object, then summarize information of data3 by mean in data4#

data3<- group_by(data2, Subject, labeldesc)
data4<- summarize_all(data3, mean)

# Store information of data4 in tidy object. This is the tidy data set as per 5th question of course project#

tidy<- data4
