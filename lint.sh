#!/bin/bash

# 	This script takes a folder and runs CSS Lint on it(www.csslint.net). 
#	It then saves the warnings to the log file and echoes the errors and 
#	returns a value equal to the number of errors.

# Init the temp file
touch .tmp.txt

# Loop through the argument folders: 
for (( i=1 ; i < $#; i++ ))
do 
	# Find all files that end in .css but are not minified(which ends in .min.css).
	find ${!i} |grep -v '/css$' |grep '.css$' |grep -v 'min.css$' >> .tmp.txt
done


# Print which files is going to be linted
echo "CSS linting these files:"
cat .tmp.txt

# Find all newlines that separates the filenames and replace them with spaces
MYFILES=`cat .tmp.txt |tr '\n' ' '`

# Init the log file to avoid errors on nonexistant file
touch ./logs/csswarnings.log

# Execute the linter and save the output in our log-file.
java -jar rhino.jar csslint.js $MYFILES &> ./logs/csswarnings.log

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

