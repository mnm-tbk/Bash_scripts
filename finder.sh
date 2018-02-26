#!/bin/bash
# hw1

NUM_LINK=0
NUM_DIR=0
NUM_FILE=0
FILE_SEQ=()

err=0
V_B=false
T_B=false
H_B=false
Z_B=false
N_B=false

while getopts  "hvzn" OPTION &> /dev/null

do
	case $OPTION in 
		h)
			echo "the purpose of this script is to find path to files/directories/symlinks sent as an input"
			echo "4 options: -h for help; 
			-v for total number of inputs;
			-z for making new tar.gz from all the files exluding links at the end of the script; 
			-v for number of every file;
			-n to print number of each item in order"
			exit 0
			;;
		v)
			
			V_B=true
			;;
	
		n)
			
			N_B=true
			;;
		z)
			
			Z_B=true
			;;
		*)
			exit 2

	esac

done	




while read line
do
	if [[ $line = "FILE "* ]]; then
    	FILE=${line:5}

    	
    	if [[ -h "$FILE" ]]; then
    		((++NUM_LINK))

    		if [[ "$N_B" = true ]]; then
    			echo "LINK $NUM_LINK '$FILE' '$(readlink $FILE)'"
 			else
    			echo "LINK '$FILE' '$(readlink $FILE)'"
    		fi
    	
    	elif [[ -f "$FILE" ]]; then
    		((++NUM_FILE))
    		NUM_LINES=$(wc -l < "$FILE")
    		FIRST_LINE=$(head -n 1 "$FILE")
    		FILE_SEQ+=("$FILE")

    		if [[ "$N_B" = true ]]; then
    			echo "FILE $NUM_FILE '$FILE' $NUM_LINES '$FIRST_LINE'"
    		else
    			echo "FILE '$FILE' $NUM_LINES '$FIRST_LINE'"	
    		fi
    		
    	elif [[ -d "$FILE" ]]; then
    		((++NUM_DIR))

    		if [[ "$N_B" = true ]]; then
    			echo "DIR $NUM_DIR '$FILE'"
    		
    		else 
    			echo "DIR '$FILE'"
    		fi
    	else
    		echo "ERROR '$FILE'" >&2
    		err=1
    	fi
	fi
done

if [[ $V_B = true ]]; then
		echo "$NUM_FILE"
		echo "$NUM_DIR"
		echo "$NUM_LINK"
fi

if [[ $Z_B = true ]]; then
	tar czf output.tgz "${FILE_SEQ[@]}"
fi

exit $err
                                                        
