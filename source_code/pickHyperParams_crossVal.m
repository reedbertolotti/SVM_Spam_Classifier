%{ 
 Determine optimal hyperparameters for SVM with RBF kernel by training multiple
 models on the training set and evaluating on the cross validation set.
 @param X    Design matrix of training set.
 @param y    Column vector of labels for training set.
 @param Xval    Design matrix of cross validation set.
 @param yval    Column vector of labels for cross validation set.
 @return C    Optimal value of hyperparameter C.
 @return g    Optimal value of hyperparameter gamma.
%}
function [C, g] = pickHyperParams_crossVal(X, y, Xval, yval)
  
  % values of C and g to try:

  % extensive
  ##Cvals = [0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100];
  ##gvals = [0, 1e-5, 3e-5, 1e-4, 3e-4, 1e-3, 3e-3, 1e-2, 3e-2, ...
  ##         1e-1, 3e-1, 1, 3, 10, 30, 100];
         
  % narrowed down based on a previous run
  Cvals = [0.3, 1, 3, 10, 30];
  gvals = [1e-3, 3e-3, 1e-2, 3e-2, 1e-1];
  
  accuraciesAndParams = [];

  i = 1;
  totalModels = length(Cvals) * length(gvals);
  
  % train and evaluate a model for each combination of C and g (gamma)
  %  as given by the values in Cvals and gVals
  for Ccur = Cvals
  
    for gcur = gvals
      
      fprintf('model %d out of %d\n', i++, totalModels);
      
      % svm options for C and gamma and also options for quiet mode and 
      %   cache memory size of 5GB
##      optionsStr = ["-c " num2str(Ccur) " -g " num2str(gcur) " -q"];
      optionsStr = ["-c " num2str(Ccur) " -g " num2str(gcur) " -q -m 5000"];
      
      % train the current model on the training set
      model = svmtrain(y, X, optionsStr);
      
      % make predictions using the model on the cross validation set
      [predictedLabel, accuracyCur, decisionValues] = svmpredict(yval, Xval, ...
                                                                  model);      
      
      % add the current accuracy, C value, and gamma value
      %  as a row to accuraciesAndParams matrix
      accuraciesAndParams = [accuraciesAndParams; [accuracyCur(1) Ccur gcur]];
      
    endfor
    
  endfor

  % get the C and gamma values corresponding to the highest
  %  accuracy model
  [maxAccuracy, maxAccIdx] = max(accuraciesAndParams(:,1));

  fprintf('max accuracy model: %d\n', maxAccuracy);

  C = accuraciesAndParams(maxAccIdx, 2);
  g = accuraciesAndParams(maxAccIdx, 3);

endfunction