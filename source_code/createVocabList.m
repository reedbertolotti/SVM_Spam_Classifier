%{ 
 Create the vocabulary list of most frequent string tokens (words) in emails.
 @param trainEmailNames    Training set emails.  Row cell array of string paths 
  to emails in text files.
 @param minOccurances    The minimum times a word must occur in the training set
  emails to include it in vocabList.
 @return vocabList    Column cell array of the most frequent string tokens from
  training set emails.  Contains string tokens that occured at least 
  minOccurances times in emails after preprocessing.
%}
function vocabList = createVocabList(trainEmailNames, minOccurances)

  vocabList = {};

  % struct to hold all tokens from emails (as fields) and their total number of 
  %  occurances in all emails (as values)
  % note: containers.Map is not faster than struct for this purpose
  tokenStruct = struct;

  i = 1;
  m = length(trainEmailNames)

  % iterate over each training email example
  for emNm = trainEmailNames

    fprintf("%d out of %d: %s (creating vocab list)\n", i++, m, emNm{1});
     
    % read the contents of current email
    fileContents = readFile(emNm{1});
    
    % preprocess the current email and get its word tokens
    tokens = preprocTokenize(fileContents);
    
    % iterate over all the word tokens from the preprocessed email
    for token = tokens
      
      % if in tokenStruct, increase count of occurances
      if isfield(tokenStruct, token{1})
       % add 1 to value mapped by token
       tokenStruct.(token{1})++; 
      % add to tokenStruct if not in struct
      else
        % create a new entry for the token
        tokenStruct.(token{1}) = 1;
      endif
      
    endfor
    
  endfor

  % sort fields in alphabetical order
  tokenStruct = orderfields(tokenStruct);

  % add all tokens with mapped values >= minOccurances to vocabList
  for [val, key] = tokenStruct
    
    if val >= minOccurances
      vocabList = [vocabList; key];
    endif
    
  endfor

endfunction
