%{ 
 Get the vocabulary list indices of words that are in both vocabList
 and emailContents.  Used to make a feature vector for an email example.
 @param emailContents    String contents of an email.
 @param vocabList    Column cell array of the most frequent string tokens from
  training set emails.
 @return wordIndices    Column vector of indices of words in vocabList that 
  are also words in emailContents.
%}
function wordIndices = processEmail(emailContents, vocabList)

  wordIndices = [];

  % tokenize the email contents into a cell array of words
  wordTokens = preprocTokenize(emailContents);

  % check if each word token is in vocabList
  % if it is, add that word's index in vocabList to wordIndices
  for word = wordTokens
    
      % compares word to every string in vocabList
      % match contains a vector the length of vocabList
      %   of 0's (no match) and 1's (match in vocabList)
      match = strcmp(word, vocabList);
      
      % returns all indices that are non-zero
      % since there are no duplicates in vocabList, index will
      %   either contain one or zero indices
      index = find(match);
      
      % check to see if an index was found for word in vocabList
      if length(index) ~= 0
        % add the index to wordIndices
        wordIndices = [wordIndices; index];
      endif
      
  endfor

endfunction
