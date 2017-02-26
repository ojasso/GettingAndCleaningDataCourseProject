rm(list = ls())
cat("\f")

colnames <- read.table("./features.txt")

# ##########################################
values <- read.table("./test/X_test.txt", 
                          col.names = colnames$V2)
t <- read.table("./train/X_train.txt", 
                col.names = colnames$V2)
values <- rbind(values,t)

person <- read.table("./test/subject_test.txt",
                          col.names = c("PersonId"))
t <- read.table("./train/subject_train.txt", 
                col.names = c("PersonId"))
person <- rbind(person,t)

labels <- read.table("./test/y_test.txt",
                          col.names = c("ActivityId"))
t <- read.table("./train/y_train.txt", 
                col.names = c("ActivityId"))
labels <- rbind(labels,t)



#test triaxial body acceleration signal
body_acc_x <- read.table("./test/Inertial\ Signals/body_acc_x_test.txt")
t <- read.table("./train/Inertial\ Signals/body_acc_x_train.txt")
body_acc_x <- rbind(body_acc_x,t)
body_acc_x$mean <- rowMeans(body_acc_x[,1:128])

body_acc_y <- read.table("./test/Inertial\ Signals/body_acc_y_test.txt")
t <- read.table("./train/Inertial\ Signals/body_acc_y_train.txt")
body_acc_y <- rbind(body_acc_y,t)
body_acc_y$mean <- rowMeans(body_acc_y[,1:128])

body_acc_z <- read.table("./test/Inertial\ Signals/body_acc_z_test.txt")
t <- read.table("./train/Inertial\ Signals/body_acc_z_train.txt")
body_acc_z <- rbind(body_acc_z,t)
body_acc_z$mean <- rowMeans(body_acc_z[,1:128])

body_acc   <- data.frame(body_acc_x =body_acc_x$mean, 
                              body_acc_y =body_acc_y$mean,
                              body_acc_z =body_acc_z$mean)

# triaxial angular velocity
body_gyro_x <- read.table("./test/Inertial\ Signals/body_gyro_x_test.txt")
t<- read.table("./train/Inertial\ Signals/body_gyro_x_train.txt")
body_gyro_x <-rbind(body_gyro_x,t)
body_gyro_x$mean <- rowMeans(body_gyro_x[,1:128])

body_gyro_y <- read.table("./test/Inertial\ Signals/body_gyro_y_test.txt")
t<- read.table("./train/Inertial\ Signals/body_gyro_y_train.txt")
body_gyro_y <-rbind(body_gyro_y,t)
body_gyro_y$mean <- rowMeans(body_gyro_y[,1:128])

body_gyro_z <- read.table("./test/Inertial\ Signals/body_gyro_z_test.txt")
t<- read.table("./train/Inertial\ Signals/body_gyro_z_train.txt")
body_gyro_z <-rbind(body_gyro_z,t)
body_gyro_z$mean <- rowMeans(body_gyro_z[,1:128])

body_gyro   <- data.frame(body_gyro_x =body_gyro_x$mean, 
                               body_gyro_y =body_gyro_y$mean,
                               body_gyro_z =body_gyro_z$mean)

#test triaxial total acceleration
total_acc_x <- read.table("./test/Inertial\ Signals/total_acc_x_test.txt")
t<- read.table("./train/Inertial\ Signals/total_acc_x_train.txt")
total_acc_x <- rbind(total_acc_x,t)
total_acc_x$mean <- rowMeans(total_acc_x[,1:128])

total_acc_y <- read.table("./test/Inertial\ Signals/total_acc_y_test.txt")
t<- read.table("./train/Inertial\ Signals/total_acc_y_train.txt")
total_acc_y <- rbind(total_acc_y,t)
total_acc_y$mean <- rowMeans(total_acc_y[,1:128])

total_acc_z <- read.table("./test/Inertial\ Signals/total_acc_z_test.txt")
t<- read.table("./train/Inertial\ Signals/total_acc_z_train.txt")
total_acc_z <- rbind(total_acc_z,t)
total_acc_z$mean <- rowMeans(total_acc_z[,1:128])

total_acc   <- data.frame(total_acc_x =total_acc_x$mean, 
                               total_acc_y =total_acc_y$mean,
                               total_acc_z =total_acc_z$mean)

#1 Merges the training and test  sets to create one data set
#print(1)
all_data <- data.frame(person,labels,body_gyro,total_acc, body_gyro,values)

#2 Extracts only the measurements on the mean and standard deviation for each measurement.
#print(2)
a<- all_data[,grep("Id$|[mM]ean|std",names(all_data))]

#3 uses descriptive activity names to name the activities in the dataset
#print(3)
n <- names(a)
n <- gsub("\\(|\\)|-|,|\\.","_",n)
n <- gsub("__","",n)
n <- gsub("_$","",n)
n <- gsub("^t","time",n)
n <- gsub("^f","frequency",n)
n <- gsub("Gyro","Gyroscope",n)
n <- gsub("Acc","Acceleration",n)
b<-a
names(b) <-n
names(b)

#4 Appropriately labels the data set with descriptive variable names.
#print(4)
activities <- read.table("activity_labels.txt",col.names = c("ActivityId","Activity"))
c <- merge(activities,b, by = intersect(names(b),names(activities)))

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
g<- group_by(c,PersonId,Activity) 
d<-summarise_at(g, .cols = 4:89, .funs = c(Mean="mean"))

write.csv(d,"tidy_dataset.csv")



