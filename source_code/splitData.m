%{ 
 Split email dataset into train, cross validation, and test sets.
 @param allEmailNames    Column cell array of string paths to emails 
  in text files to be split.
 @param trainPercent    Percent of allEmailNames to put in trainEmailNames as a
  decimal.
 @param testPercent    Percent of allEmailNames to put in testEmailNames as a
  decimal.
 @param (optional) crossValPercent    Percent of allEmailNames to put in 
  crossValEmailNames as a decimal.
 @note: if crossValPercent is supplied, 
  trainPercent + crossValPercent + testPercent must = 1,
  otherwise trainPercent + testPercent must = 1
 @return trainEmailNames    Column cell array of string email names for training
  set.
 @return testEmailNames    Column cell array of string email names for test set.
 @return crossValEmailNames    Column cell array of string email names for cross 
  validation set.  Returned only if crossValPercent is supplied.
%}
function [trainEmailNames, testEmailNames, crossValEmailNames] = ...
  splitData(allEmailNames, trainPercent, testPercent, crossValPercent)

  % if only allEmailNames, trainPercent, and testPercent are passed 
  %   (3 arguments only), then split allEmailNames into train and test sets
  % otherwise, split into train, cross validation, and test sets
  trainTestSplit = false;
  if nargin == 3
    trainTestSplit = true;
  endif
  
  if (nargin == 3 && nargout != 2) || (nargin == 4 && nargout != 3)
    error("Invalid number of outputs requested (%d) for %d inputs given\n", ...
            nargout, nargin);
  endif
  
  m = length(allEmailNames);
  
  % create a vector from the permutation of 1 to m
  % represents the shuffled indices of allEmailNames
  sel = randperm(m);
  
  % train / test split is requested (no cross validation)
  if trainTestSplit
    trainStart = 1;
  % if cross validation set is requested 
  else
    % divide up the cross validation set
    crossValStop = floor(m * crossValPercent);
    sel_crossVal = sel(1:crossValStop);
    crossValEmailNames = allEmailNames(sel_crossVal);
    
    % training set will start after cross validation set
    trainStart = crossValStop + 1;
  endif
 
  % divide up the training set
  trainStop = trainStart + floor(m * trainPercent);
  sel_train = sel(trainStart:trainStop);
  trainEmailNames = allEmailNames(sel_train);
  
  % divide up the test set
  testStart = trainStop + 1;
  sel_test = sel(testStart:end);
  testEmailNames = allEmailNames(sel_test);
  
endfunction
