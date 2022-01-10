# SVM Spam Classifier
Classify emails in text files as spam or not spam.

Main script to run: svmSpam_main.m

Components:

 - split the email dataset into training and test sets
 - create a vocabulary list from the training set emails
	 - list of most frequently occuring words in emails
	 - features of examples will correspond to having a word from the vocabulary list (1) or not (0)
 - create design matrix and labels for the training and test sets
 - determine best SVM hyperparameters C and gamma using repeated k-fold cross validation
 - train an SVM using LIBSVM library on training set
 - evaluate SVM performance on test set
