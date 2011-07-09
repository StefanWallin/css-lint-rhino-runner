#!/bin/bash

# 	This script takes a folder and runs CSS Lint on it(www.csslint.net). 
#	It then saves the warnings to the log file and echoes the errors and 
#	returns a value equal to the number of errors.

#Set up some initial vars:
STRICTMODE=false
LOGFILE=./logs/csswarnings.log	
TMPFILE=.tmp.txt

# Init the temp file
touch ${TMPFILE}


#Loop through the arguments in STDIN
while read -t 1 line; do
	line=(${line}); 
	for (( i=0 ; i < ${#line[@]} ; i++ ))
	do 
		# Find all files that end in .css but are not minified(which ends in .min.css).
		find ${line[$i]} |grep -v '/css$' |grep '.css$' |grep -v 'min.css$' >> ${TMPFILE}
	done
done

#Loop through arguments in command line 
for (( i=1 ; i <= $#; i++ ))
do 
	case ${!i} in
		"--strict")
			STRICTMODE=true
			continue;
			;;
		"-l")
			i=$(($i+1))
			touch ${!i} >/dev/null 2>/dev/null
			if [ $? == 0 ]; then	
				LOGFILE=${!i}
				echo "Log file: ${!i}"
			else
				echo "Supplied log file path (${!i})"
			fi
			continue;
			;;
	esac
	# Find all files that end in .css but are not minified(which ends in .min.css).
	find ${!i} |grep -v '/css$' |grep '.css$' |grep -v 'min.css$' >> ${TMPFILE}
done

argc=`cat .tmp.txt|wc -l`
echo $argc
if [  $(($argc+0)) == 0 ]; then
	echo "Usage: "
	echo "	lint.sh [-l logfile] [--strict] folder [folder...]"
	echo "	pwd|lint.sh"
	exit 1;
fi

# Print which files is going to be linted
echo "CSS linting these files:"
cat ${TMPFILE}

# Find all newlines that separates the filenames and replace them with spaces
MYFILES=`cat ${TMPFILE} |tr '\n' ' '`

# Init the log file to avoid errors on nonexistant file
rm ${LOGFILE}; touch ${LOGFILE}

# Execute the linter and save the output in our log-file.
java -jar rhino.jar csslint.js $MYFILES &> ${LOGFILE}

if [ $STRICTMODE == "true" ]; then
	# Find out how many errors and warnings we had
	E=`cat ${LOGFILE} |grep " error at"|wc -l` || 0
	W=`cat ${LOGFILE} |grep " warning at"|wc -l` || 0
	
	# Print the errors to the console
	cat ${LOGFILE}

	# Print how many errors we found:
	echo "CSS linting found $E errors and $W warnings."

	#Counting up errors to the result
	R=$(($E+$W))
	
else
	# Find out how many errors we had
	E=`cat ${LOGFILE} |grep " error at"|wc -l`

	# Print the errors to the console
	cat ${LOGFILE} |grep -B 1 -A 3 " error at"

	# Print how many errors we found:
	echo "CSS linting found $E errors."

	#Counting up errors to the result
	R=$E
fi

# Remove our ${TMPFILE}-file.
rm ${TMPFILE}

#exit with the number of errors.
# exit status greater than zero should halt the following executions.
exit $R;

