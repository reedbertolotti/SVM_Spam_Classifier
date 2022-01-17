%{ 
 Create design matrix and labels for a dataset of emails.
 @param emailNames    Email dataset.  Row cell array of string paths to emails 
  in text files.
 @param vocabList    Column cell array of the most frequent string tokens from
  training set emails.
 @return X    Design matrix for email dataset.
 @return y    Column vector of class labels for email dataset 
  (spam = 1, ham = 0)
%}
function [X, y] = createDesignMatrixAndLabels(emailNames, vocabList)
    
  X = [];
  y = [];

  i = 1;
  m = length(emailNames);
  
  % for each email name in emailNames, create and add its features to the 
  %   design matrix X
  for emNm = emailNames
    
    fprintf("%d out of %d: %s (creating design matrix)\n", i++, m, emNm{1});
   
    % read the contents of current email
    fileContents = readFile(emNm{1});
    % get indices of words in vocabList that appear in the email's contents
    wordIndices = processEmail(fileContents, vocabList);
    
    % creature the feature vector for the email
    n = length(vocabList);
    x = zeros(1, n);
    % x(i) = 1 if email contains vocabList word with index i
    x(wordIndices) = 1; 
    
    % add the feature vector to X as a row
    X = [X; x];
    
    % remove path from the email name string
    nmNoPath = strsplit(emNm{1}, "/"){end};
    
    % spam emails have names beginning with "s" in the main part of the 
    %   name (not including path)
    if nmNoPath(1) == "s"
      % label email as spam
      y = [y; 1];
    else
      % label email as ham (aka not spam)
      y = [y; 0];
    endif
    
  endfor
    
endfunction
