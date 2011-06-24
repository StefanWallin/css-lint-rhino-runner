#!/bin/bash

# 	This script takes a folder and runs CSS Lint on it(www.csslint.net). 
#	It then saves the warnings to the log file and echoes the errors and 
#	returns a value equal to the number of errors.



# Which folders should we look in: 
CSSDIR=/Users/stefan/Desktop/css

# Find all files that end in .css but are not minified(which ends in .min.css).
find $CSSDIR |grep -v '/css$' |grep '.css$' |grep -v 'min.css$' > .tmp.txt

# Print which files is going to be linted
echo "CSS linting these files:"
cat .tmp.txt

# Find all newlines that separates the filenames and replace them with spaces
MYFILES=`cat .tmp.txt |tr '\n' ' '`

# Execute the linter and save the output in our log-file.
java -jar rhino.jar csslint.js $MYFILES > logs/csswarnings.log

# Find out how many errors we had
E=`cat logs/csswarnings.log |grep " error at"|wc -l`

# Print the errors to the console
cat logs/csswarnings.log |grep -B 1 -A 3 " error at"

# Print how many errors we found:
echo "CSS linting found $E errors."

# Remove our .tmp.txt-file.
rm .tmp.txt

#exit with the number of errors.
# exit status greater than zero should halt the following executions.
exit $E;
