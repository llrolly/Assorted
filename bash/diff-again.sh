#!/bin/bash

path1=$1
path2=$2

echo "-----------------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------------"
echo "-----PATH INPUTS:"
echo "-----------------------------------------------------------------------------------------"
echo "PATH1 A: $path1"
echo "PATH2 B: $path2"

echo "-----------------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------------"
echo "-----PATH IDENTIFICATION"
echo "-----------------------------------------------------------------------------------------"
find "$path1" -type d -print > test-path-1.txt
find "$path2" -type d -print > test-path-2.txt
echo "Path1: $path1"
echo "Path2: $path2"

echo "-----------------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------------"
echo "-----RECURSIVE MATCHING PATH GENERATION"
echo "-----------------------------------------------------------------------------------------"



echo "" > matched-dirs.txt

cat < "test-path-1.txt" | while IFS= read -r pathline1; do
	dirname1=$(dirname "$pathline1")
	basename1=$(basename $dirname1)
	cat < "test-path-2.txt" | while IFS= read -r pathline2; do
		dirname2=$(dirname "$pathline2")
		TESTVAR="$dirname2"
		TESTBASE=$(basename "$TESTVAR")
		if [ "$basename1" == "$TESTBASE" ]; then
			#echo "dirname 1:  '$dirname1'"
			#echo "basename 1: $basename1"
			#echo "dirname 2:  '$dirname2'"
			#echo "basename 2: $TESTBASE"
	
			echo "$dirname1?$dirname2" >> matched-dirs.txt
		fi
	done
done

echo "----SAVED MATCHED DIRS TO: matched-dirs.txt"

echo "-----------------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------------"
echo "----DIFF FILES AND CREATE UNIQUE LIST"
echo "-----------------------------------------------------------------------------------------"
echo "" > formatted-files.txt

cat matched-dirs.txt | while IFS=? read -r matcheddir1 matcheddir2; do
	# identify diffed files
	#echo "+++++++++++++++++++++"
	#echo "MATCH 1: $matcheddir1"
	#echo "MATCH 2: $matcheddir2"
	#echo "---------------------"
	diff -ry "$matcheddir1" "$matcheddir2" | grep "ry " | sed 's/-ry /\n\n/g' | sed 's/ "\n//g' | sed 's/diff/\n/g' | sed 's/"//g' | sed 's/sY@//g' | sed 's/grep: (standard input): binary file matches\n//g' > current-matched-single.txt
	
	

	cat current-matched-single.txt | while IFS= read -r fullline; do
		echo $fullline | sed 's/ \//?\//g' >> formatted-files.txt
	done


	echo "formatted-files.txt"


	#echo "Generated matched single txt"
	# split diffed dirs with multiple files into seperate lines


#START OF COMMENT BLOCK
# uncomment if you need to split line on commas
		<<COMMENT


	cat current-matched-single.txt | while IFS= read -r line; do
		#echo $line



		if [[ "$line" == *","* ]]; then
			# line1A -> line1B
			# create line 1A
			line1A=$(echo "$line" | cut -d ',' -f 1)
			# Create line 1B
			line1Bwip=$(echo "$line" | cut -d ',' -f 2)
			#remove leading content from line 1B
			delim=" \/"
			line1B=$(echo "$line1Bwip" | sed "s/.*${delim}//")
			#echo "line 1b FINISHED: $line1B"
			# add line1A and line1B into output file
			echo "$line1A?$line1B" >> formatted-files.txt
			
			# line2A -> line2B, these need additional formatting to work properly
			# generate line 2A
			#echo "MATCHED line: $line"
			fileA=$(echo "$line" | cut -d ',' -f 2 | cut -d ' ' -f 1)
			dirA=$(echo "$line1A" | sed 's![^/]*$!!')
			# Final output:
			line2A=$(echo "$dirA$fileA")
			#echo "LINE 2A: $line2A"
			# Generate 2B
			#
			fileB=$(echo "$line" | cut -d ',' -f 3)
			#echo "FILE B: $fileB"
			dirB=$(echo "$line1B" | sed 's![^/]*$!!')
			line2B=$(echo "$dirB$fileB")
			#echo "LINE 2B: $line2B"
			echo "$line2A?$line2B" >> formatted-files.txt

			# generate line 2B
		#else 
		#	echo ""
		#	# this line should be fine to add to txt file
		fi
	
	done

COMMENT
# END OF COMMENT BLOCK
done

echo "----SAVED FORMATTED FILES TO: formatted-files.txt"


echo "-----------------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------------"
echo "----META DATA"
echo "-----------------------------------------------------------------------------------------"
echo "" > meta-info-file.txt
echo "" > meta-sha256sum.txt

# output meta data for each file
cat formatted-files.txt | while IFS=? read -r filepathA filepathB; do
	# Get all files within A
	# get meta data for all files
	if [ ${#filepathA} -gt 9 ]; then
		echo "--------------------------" >> meta-info-file.txt
		echo "----Writing  meta data $filepathA"
		echo "----Writing  meta data $filepathB"
		echo "--------------------------" >> meta-info-file.txt
		echo "META-DATA:" >> meta-info-file.txt
	        echo "$filepathA" >> meta-info-file.txt
		echo "" >> meta-info-file.txt
		echo "META ls:	$(ls $filepathA | xargs -n 1 basename)" >> meta-info-file.txt
		echo "" >> meta-info-file.txt
		echo "META stat: $(stat $filepathA)" >> meta-info-file.txt
		echo "" >> meta-info-file.txt
		echo "META file: $(file $filepathA)" >> meta-info-file.txt
		echo "--------------------------"
		echo "----Writing SHA256SUM"
		echo "--------------------------"
		echo "SHA256SUM A:$(sha256sum "$filepathA")" >> meta-sha256sum.txt
		echo "SHA256SUM B:$(sha256sum "$filepathB")" >> meta-sha256sum.txt

	fi
done

echo "----SAVED META INFO TO: meta-info-file.txt"
echo "----SAVED SHA256SUM TO: meta-sha256sum.txt"
