
% SVM Spam Classifier
% by Reed Bertolotti

% ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
% project file structure requirements:
% - LIBSVM library in same directory as this script
% - directory of dataset emails one directory above script's directory
% ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *****  

% note: sections are commented out for one of two reasons
% 1) there are two ways to run this script: one uses repeated k fold cross
%      validation to pick hyperparameters and the other uses a cross validation
%      set to pick hyperparameters. One of the two ways is always commented out.
% 2) code for loading data from files is commented out. Uncomment this code to
%      load previously saved data and not recompute it with preceding steps.



% add path to SVM library to Octave's load path
addpath(genpath("./libsvm-3.25/matlab"));

% get the names of all email files to use as the dataset

% note: has to end in /
pathToEmails = "../raw_datasets/exEmailsOneDir/"; 
#pathToEmails = "../raw_datasets/legacy_SpamAssassinEmails/exEmailsOneDir_all/";
% note: fileNames is a column cell array (dimensions m x 1)
fileNames = glob(strcat(pathToEmails, "*"));
m = length(fileNames);



% ***** ***** ***** ***** ***** ***** *****
% divide files names into train and test sets
% or 
% divide file names into train, cross validation, and test sets
% ***** ***** ***** ***** ***** ***** *****

% percentage split for train and test sets
trainPercent = 0.80;
testPercent = 0.20;

% percentage split for train, CV, and test sets
##trainPercent = 0.60;
##crossValPercent = 0.20;
##testPercent = 0.20;

% get cell arrays of email names for each set
[trainEmailNames, testEmailNames] = splitData(...
  fileNames, trainPercent, testPercent);
  
##[trainEmailNames, crossValEmailNames, testEmailNames] = splitData(...
##  fileNames, trainPercent, crossValPercent, testPercent);



% ***** ***** ***** ***** ***** ***** *****
% create the vocabulary list 
% ***** ***** ***** ***** ***** ***** *****

##load "../saved_data/emailNameSets.mat"
minOccurances = 100;

vocabList = createVocabList(trainEmailNames', minOccurances);



% ***** ***** ***** ***** ***** ***** *****
% create X, y and Xtest, ytest matrices
% or
% create X, y and Xval, yval and Xtest, ytest matrices
% ***** ***** ***** ***** ***** ***** *****

##load "../saved_data/vocabList.mat"

[X, y] = createDesignMatrixAndLabels(trainEmailNames', vocabList);

[Xtest, ytest] = createDesignMatrixAndLabels(testEmailNames', vocabList);

##[Xval, yval] = createDesignMatrixAndLabels(crossValEmailNames', vocabList);
 


% ***** ***** ***** ***** ***** ***** *****
% determine best hyperparameters C and gamma
% ***** ***** ***** ***** ***** ***** *****

% for each combination of C and gamma, do k fold cross validation
% pick the C and gamma that result in the highest cross validation accuracy

##load "../saved_data/designMatricesAndLabels.mat"

% best hyperparameters 
% only SpamAssassin data: C = 10 and g = 3e-3 (98.3254% accuracy)
% all data: C = 3 and g = 1e-2 (98.3803% accuracy)
[C, g] = pickHyperParams_kfold(X, y);

% or 

% for each combination of C and gamma, train an SVM on the training set X, y
% evaluate each SVM on the cross validation set Xval, yval
% pick the C and gamma that result in the highest cross validation accuracy

% best hyperparameters
% only SpamAssassin data: C = 10, g = 3e-3 (98.6766% accuracy)
##[C, g] = pickHyperParams_crossVal(X, y, Xval, yval);



% ***** ***** ***** ***** ***** ***** *****
% train model with best hyperparameters C and gamma
% ***** ***** ***** ***** ***** ***** *****

##load "../saved_data/bestCAndGamma.mat"

% if did train/test/cross validation split, train final model on all 
%   nontest data
##X = [X; Xval];
##y = [y; yval];

% -c and -g for C and gamma, -q for quiet 
optionsStr = ["-c " num2str(C) " -g " num2str(g) " -q"];
model = svmtrain(y, X, optionsStr);



% ***** ***** ***** ***** ***** ***** *****
% make predictions on test set to confirm that the
%  accuracy is close to that found by cross validation
% ***** ***** ***** ***** ***** ***** *****

% model accuracy 
% only SpamAssassin data, repeated k-fold cross val for hyperparameters: 97.9322% 
% all data, repeated k-fold cross val for hyperparameters: 98.1665% 
% only SpamAssassin data, cross validation set for hyperparameters: 98.0976% 
[predictedLabel, accuracy, decisionValues] = svmpredict(ytest, Xtest, ...
                                                         model);
fprintf("final model accuracy: %d\n", accuracy(1));                                                         
