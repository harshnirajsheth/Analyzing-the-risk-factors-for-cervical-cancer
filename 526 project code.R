raw.data = read.csv(file.choose())

install.packages('Boruta')
library(ggplot2)        #Data Visualization
library(dplyr)          #Data Manipulation
library(Boruta)         #Feature Importance Analysis

dim(raw.data)
glimpse(data)

# [2] Verify Dataset Integrity - NAs
prop_NA <- function(x) { mean(is.na(x))}
missdata <- sapply(raw.data, prop_NA)
missdata <- data.frame(Variables = names(missdata), Proportion = missdata, Completude = 1 - missdata)
missdata <- missdata[order(desc(missdata$Proportion)),]


# [6] Create function to identify all columns that need repair
find_cols = function(x){
  cols = vector()
  for (i in 1:ncol(x)){
    if (sum(x[,i] == "?") > 0){
      cols = c(cols,i)
    }  
  }
  return(cols)
}


# [7] Create function to fix missing values
fix_columns = function(x,cols) {
  for (j in 1:length(cols)) {
    x[,cols[j]] = as.character(x[,cols[j]])
    x[which(x[,cols[j]] == "?"),cols[j]] = "-1.0"
    x[,cols[j]] = as.numeric(x[,cols[j]])
  }
  return(x)
}

# [8] Apply functions
cols_to_fix = find_cols(raw.data)
raw.data = fix_columns(raw.data,cols_to_fix)

# [9] Create target variable
raw.data$CervicalCancer = raw.data$Hinselmann + raw.data$Schiller + raw.data$Citology + raw.data$Biopsy
raw.data$CervicalCancer = factor(raw.data$CervicalCancer, levels=c("0","1","2","3","4"))

# [10] Explore target variable distribution
round(prop.table(table(raw.data$CervicalCancer)),2)

# [14] Create copy of the original dataset, Remove medical results columns
train = raw.data
train[,c("Hinselmann","Schiller","Citology","Biopsy")] = NULL

write.csv(train, file = "526.csv")
#############################################################################################

#over sampling
install.packages('DMwR')
library(DMwR)
smoted_data <- SMOTE(CervicalCancer~., train, perc.over=100)
summary(smoted_data)
summary(train$CervicalCancer)

`1# [15] Perform Boruta Analysis on the training set
set.seed(1407)
boruta_analysis = Boruta(CervicalCancer ~ ., data=train, maxRuns=200)

boruta_analysis
summary(boruta_analysis)


# [16] Finding the correlation between the factors
install.packages('ISLR')
library(ISLR)
install.packages('corrplot')
library(corrplot)
correlations <- cor(train[,1:32])
corrplot(correlations, method="number")

# [17] Splitting data into training set and test set
install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(raw.data$CervicalCancer, SplitRatio = 0.8)
training_set = subset(train, split == TRUE)
test_set = subset(train, split == FALSE)

install.packages('foreign')
install.packages('nnet')
install.packages('ggplot2')
install.packages('reshape2')
library(foreign)
library(nnet)
library(ggplot2)
library(reshape2)

# [18] Fitting multinomial logistic regression model
log_model <- multinom(formula = CervicalCancer ~., data = train)
preds <- predict(log_model)
summary(preds)
summary(train$CervicalCancer)

library(lattice)
library(caret)
