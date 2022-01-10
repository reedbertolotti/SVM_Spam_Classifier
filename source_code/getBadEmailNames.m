# ***
# NOTE: this file is no longer needed after changing encoding from UTF-8 
#   to ISO-8859-1, which solved the problem
# ***

%{ 
 Get the names of emails that cannot be processed.
 @param allEmailNames    Row cell array of string paths to emails 
  in text files.
 @return badEmailNames    Row cell array of string paths to emails that
  cannot be processed.
%}
function badEmailNames = getBadEmailNames(allEmailNames)
  
  badEmailNames = {};
  
  % iterate over each email name in allEmailNames
  for emNm = allEmailNames
    
    fprintf("email name: %s\n", emNm{1}); % print email name
    
    % read the email file's contents
    email_contents = readFile(emNm{1});
    
    % find and remove the email header (\n\n) 
    hdrstart = strfind(email_contents, ([char(10) char(10)]));
    email_contents = email_contents(hdrstart(1):end);

    % check for error with processing email
    % "error: regexprep: the input string is invalid UTF-8"
    try
      email_contents = regexprep(email_contents, '<[^<>]+>', ' ');
    catch
      %fprintf("bad email name: %s\n", emNm{1}); % print bad email name
      
      % if an error occurs, add this email's name to badEmailNames
      badEmailNames = [badEmailNames, emNm{1}];      
    end_try_catch
    
  endfor
  
endfunction
