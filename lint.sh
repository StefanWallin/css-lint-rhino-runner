#!/bin/bash

# 	This script takes a folder and runs CSS Lint on it(www.csslint.net). 
#	It then saves the warnings to the log file and echoes the errors and 
#	returns a value equal to the number of errors.

#Set up some initial vars:
STRICTMODE=false



# Init the temp file
touch .tmp.txt

#Loop through the arguments in STDIN
while read line; do
	line=(${line}); 
	for (( i=0 ; i < ${#line[@]} ; i++ ))
	do 
		# Find all files that end in .css but are not minified(which ends in .min.css).
		find ${line[$i]} |grep -v '/css$' |grep '.css$' |grep -v 'min.css$' >> .tmp.txt
	done
done

#Loop through arguments in command line 
for (( i=1 ; i <= $#; i++ ))
do 
	case ${!i} in
		"-s")
			STRICTMODE=true
			continue;
			;;
	esac
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

if [ $STRICTMODE == "true" ]; then
	# Find out how many errors and warnings we had
	E=`cat logs/csswarnings.log |grep " error at"|wc -l` || 0
	W=`cat logs/csswarnings.log |grep " warning at"|wc -l` || 0
	
	# Print the errors to the console
	cat logs/csswarnings.log

	# Print how many errors we found:
	echo "CSS linting found $E errors and $W warnings."

	#Counting up errors to the result
	R=$(($E+$W))
	
else
	# Find out how many errors we had
	E=`cat logs/csswarnings.log |grep " error at"|wc -l`

	# Print the errors to the console
	cat logs/csswarnings.log |grep -B 1 -A 3 " error at"

	# Print how many errors we found:
	echo "CSS linting found $E errors."

	#Counting up errors to the result
	R=$E
fi

# Remove our .tmp.txt-file.
rm .tmp.txt

#exit with the number of errors.
# exit status greater than zero should halt the following executions.
exit $R;

