%{ 
 Preprocess the contents of an email and turn it into tokens.
 @param emailContents    String contents of an email.
 @return emailTokens    Row cell array of word tokens from emailContents.
%}
function emailTokens = preprocTokenize(emailContents)

  emailTokens = {};

  % find and remove the headers (\n\n) 
  % uncomment the following lines if working with raw emails with the
  %   full headers
  hdrStart = strfind(emailContents, ([char(10) char(10)]));
  emailContents = emailContents(hdrStart(1):end);

  % lower case
  emailContents = lower(emailContents);

  % strip all HTML
  % looks for any expression that starts with < and ends with > 
  %   and does not have any < or > in the tag and replace it with a space
  emailContents = regexprep(emailContents, '<[^<>]+>', ' ');

  % handle numbers
  % look for one or more characters between 0-9
  emailContents = regexprep(emailContents, '[0-9]+', 'number');

  % handle URLS
  % look for strings starting with http:// or https://
  emailContents = regexprep(emailContents, ...
                             '(http|https)://[^\s]*', 'httpaddr');
                             
  % handle email addresses
  % look for strings with @ in the middle
  emailContents = regexprep(emailContents, '[^\s]+@[^\s]+', 'emailaddr');

  % handle $ sign
  emailContents = regexprep(emailContents, '[$]+', 'dollar');

  % tokenize email
  while ~isempty(emailContents)

    % get next token, delimited on punctuation
    [str, emailContents] = ...
      strtok(emailContents, ...
             [' `~\^|@$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);

    % replace any non alphanumeric characters with empty string
    str = regexprep(str, '[^a-zA-Z0-9]', '');

    % stem the word 
    % try catch block since the porterStemmer sometimes has issues
    try 
      str = porterStemmer(strtrim(str)); 
    catch 
      str = ""; continue;
    end_try_catch;

    % skip the word if it is too short
    if length(str) < 1
      continue;
    endif

    % add word token to emailTokens
    emailTokens = [emailTokens, str];
      
  endwhile

endfunction
