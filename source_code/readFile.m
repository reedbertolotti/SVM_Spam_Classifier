%{ 
 Read a file and get its contents.
 @param fileName    String path to text file to read.
 @return fileContents    String contents of fileName. 
%}
function [fileContents, tt] = readFile(fileName)
      
  fid = fopen(fileName);

  # if there was not an error opening fileName, read the file
  if fid != -1
    fileContents = fscanf(fid, '%c', inf);
    fclose(fid);
  else
    error('Unable to open %s\n', fileName);
  endif

endfunction
