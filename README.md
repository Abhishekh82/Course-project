# Course-project
Getting and cleaning data course project
## Install the dplyr package##
install.packages("dplyr") 
library("dplyr")
## Set the right work directory where the data is stored for test##
setwd("~/Coursera/data/UCI HAR Dataset/test") 
## As the file is a text file read through read.table##
## Read Subject_test/train, X_test/train, Y_test/train files ##
subject_test<- read.table("subject_test.txt")
X_test<- read.table("X_test.txt")
Y_test<- read.table("Y_test.txt")
## Set the right work directory where the data is stored for train##
setwd("~/Coursera/data/UCI HAR Dataset/train")
subject_train<- read.table("subject_train.txt")
X_train<- read.table("X_train.txt")
Y_train<- read.table("Y_train.txt")
## ## Set the right work directory where the data is stored for activity labels and features ##
setwd("~/Coursera/data/UCI HAR Dataset")
activity_labels<- read.table("activity_labels.txt")
features<- read.table("features.txt")
Y1_test<- inner_join(Y_test, activity_labels)
Y1_test<- rename(Y1_test, label = "V1", labeldesc = "V2")
subject_test<- rename(subject_test, Subject = "V1")
Y1_train<- inner_join(Y_train, activity_labels)
Y1_train<- rename(Y1_train, label = "V1", labeldesc = "V2")
subject_train<- rename(subject_train, Subject = "V1")
test<- cbind(subject_test, Y1_test, X_test)
train<- cbind(subject_train, Y1_train, X_train)
data<- rbind(train, test)
sel<- c(grep("mean", features$V2), grep("std", features$V2))
data1<- rename_at(data, vars(V1:V561), ~features$V2)
sel1<- c(1:3, sel+3)
data2<- data1[,sel1]
data3<- group_by(data2, Subject, labeldesc)
data4<- summarize_all(data3, mean)
tidy<- data4
