## Data Preparation
# [1] Load libraries, data and surface analysis
library(ggplot2)        #Data Visualization
library(dplyr)          #Data Manipulation
library(Boruta)         #Feature Importance Analysis

#We'll start off by loading the libraries and reading the data, after that, we'll take a glimpse of the dataset and it's structure.
raw.data = read.csv(file.choose())
dim(raw.data)
glimpse(raw.data)

#It becomes clear that many variables were interpreted as factors, this is caused by the "?" inserted as placeholders for missing values, as exemplified by:
unique(raw.data$STDs..Time.since.first.diagnosis)

#Before delving any further in the dataset, I chose to check the integrity of the data, since it can mask the actual summary statistics that we are looking for.

#Missing values can come in many flavors  such as NAs, zeroes, negative vales or blank strings, so let us create a function and a plot to visualize the completude (non missingness) of the data.

# [2] Verify Dataset Integrity - NAs
prop_NA <- function(x) { mean(is.na(x))}
missdata <- sapply(raw.data, prop_NA)
missdata <- data.frame(Variables = names(missdata), Proportion = missdata, Completude = 1 - missdata)
missdata <- missdata[order(desc(missdata$Proportion)),]

#[3] Data Visualization: Completude vs NAs
ggplot(missdata, aes(x = Variables, y = Completude))+
geom_bar(stat = "identity", fill = "lawngreen")+
theme(axis.text.x = element_text(angle = 45, hjust = 1))+
labs(title = "Proportion of non NA Values")+
theme(plot.title = element_text(hjust = 0.5))

#[4] Verify Dataset Integrity - Blanks and Zeroes
prop_NullZero <- function(x) { mean(x == "" | x == 0)}
nullzerodata <- sapply(raw.data, prop_NullZero)
nullzerodata <- data.frame(Variables = names(nullzerodata), Proportion = nullzerodata, Completude = 1 - nullzerodata)
nullzerodata <- nullzerodata[order(desc(nullzerodata$Completude)),]

#[5] Data Visualization: Completude vs blanks and zeroes 
ggplot(nullzerodata, aes(x = Variables, y = Completude))+
geom_bar(stat = "identity", fill = "deepskyblue2")+
theme(axis.text.x = element_text(angle = 45, hjust = 1))+
labs(title = "Proportion of non Zero or Blank Values")+
theme(plot.title = element_text(hjust = 0.5))