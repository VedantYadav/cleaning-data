#reading file

activity <- read.table("activity_labels.txt")
activity[[2]] <- factor(activity[[2]])
subj <- read.table("train/subject_train.txt")
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subj_1 <- read.table("test/subject_test.txt")
xtest <-read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
fea <- read.table("features.txt")

#feature selection ...

fea_1 <- grep("mean|std",fea$V2)
fea = fea[fea_1,]
    #for cleaning 
fea$V2 <- gsub("-std","_Std",fea$V2)
fea$V2 <- gsub("-mean","_Mean",fea$V2)
fea_2 <- gsub("\\(\\)","",fea_2$V2)
fea_2$V2 <- gsub("-","_",fea_2$V2)

# a,b,c,d are intermediatesss for step by step understanding...
    
    # a = reshaping and naming train.txt file
a <- xtrain[,fea_1]
colnames(a) <- fea_2
    # b = including subject and activity column
b <- data.frame(subj,ytrain,a)
colnames(b)[1] <- "subject"
colnames(b)[2] <- "activity"
    # c&d = renaming the activity column
c <- as.factor(b$activity)
levels(c) <- activity$V2
d <- b
d$activity <- c 
train <- d

# a_1,b_1,c_1,d_1 are intermediatesss ...

a_1 <- xtest[,fea_1]
colnames(a_1) <- fea_2
b_1 <- data.frame(subj_1,ytest,a_1)
colnames(b_1)[1] <- "subject"
colnames(b_1)[2] <- "activity"
c_1 <- as.factor(b_1$activity)
levels(c_1) <- activity$V2
d_1 <- b_1
d_1$activity <- c_1 
test <- d_1

# combining the test and train data

total <- rbind(train,test)

# recasting the data
total.melt <- melt(total,id = c("subject","activity"))
total.mean <- dcast(total.melt,subject + activity ~ variable,mean)

#write back
write.table(total.mean,"tidy.txt",row.names = F,quote = F)
