# Analyzing-the-risk-factors-for-cervical-cancer
Developing a machine learning model to analyze the factors affecting cervical cancer.

Typical ways to resolve the issue of imbalanced data come in two major forms: random resampling methods and modification of balanced classification algorithms. SMOTE (Synthetic Minority Oversampling Technique) helps mitigate the potential problem of overfitting associated with random oversampling, by generating similar-but-not-identical minority-class data in the training set.

Boruta analysis was used to improve the model by feeding in only those features that are uncorrelated and non-redundant.  

Models like Random Forest Classifier, Decicision Tree Classifier, SVM, Kernel SVM, Logistic Regression and k-Nearest Neighbours were compared to select the best model with the maximium accuracy. 

Model:	Accuracy
Random Forest Classifier:	0.928042328
Decision Tree Classifier:	0.8867724868
Kernel SVM:	0.7724867725
SVM:	0.6571428571
Logistic Regression:	0.5936507937
k-Nearest Neighbour:	0.8825396825
