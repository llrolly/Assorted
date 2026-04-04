#!/bin/bash

path1=$1
path2=$2
directory=$3

echo "-----------------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------------"
echo "-----Inputs:"
echo "-----------------------------------------------------------------------------------------"
echo "File A: $path1"
echo "File B: $path2"

echo "" > matched-sha.txt
echo "" > failed-match-sha.txt


#mkdir -m 755 $directory

echo "-----------------------------------------"
echo "compare 1-2 & 1-3"
cat $path1 | while IFS= read -r varfull; do
	if [[ ${#varfull} -gt 5 ]]; then
	varsha=${varfull%% *}
	#echo "SHA256SUM: $varsha"
	varfile=${varfull#* }
	#echo "VARFILE: $varfile"
# compare 1-2
	cat $path2 | while IFS= read -r checkfull1; do
		
		varsha1=${checkfull1%% *}
		if [[ "$varsha1" == "$varsha" ]]; then
			echo "$varfull" >> matched-sha.txt
			echo "$checkfull1" >> matched-sha.txt
		else
			varfile1=${checkfull1#* }
			Bfilename=$(basename "$varfile")
			Afilename=$(basename "$varfile1")
			if [[ "$Afilename" == "$Bfilename" ]]; then
				echo "-----------------------------------------" >> diffed-files.txt
				echo "FILE A: $varfull" >> diffed-files.txt
				echo "FILE B: $checkfull1" >> diffed-files.txt
				diff $varfile $varfile1 >> diffed-files.txt
				echo "-----------------------------------------" >> diffed-files.txt
			fi
		fi

	done
# compare 1-3
	cat $path3 | while IFS= read -r checkfull1; do
		
		varsha1=${checkfull1%% *}
		if [[ "$varsha1" == "$varsha" ]]; then
			echo "$varfull" >> matched-sha.txt
			echo "$checkfull1" >> matched-sha.txt
		else
			varfile1=${checkfull1#* }
			Bfilename=$(basename "$varfile")
			Afilename=$(basename "$varfile1")
			if [[ "$Afilename" == "$Bfilename" ]]; then
				echo "-----------------------------------------" >> diffed-files.txt
				echo "FILE A: $varfull" >> diffed-files.txt
				echo "FILE B: $checkfull1" >> diffed-files.txt
				diff $varfile $varfile1 >> diffed-files.txt
				echo "-----------------------------------------" >> diffed-files.txt
			fi
		fi
	done
	fi
done

# compare 2-3
echo "-----------------------------------------"
echo "compare 2-3"
cat $path2 | while IFS= read -r varfull; do
	if [[ ${#varfull} -gt 5 ]]; then
		varsha=${varfull%% *}
		varfile=${varfull#* }
		cat $path3 | while IFS= read -r checkfull1; do
			varsha1=${checkfull1%% *}
			if [[ "$varsha1" == "$varsha" ]]; then
				echo "$varfull" >> matched-sha.txt
				echo "$checkfull1" >> matched-sha.txt
			else
				varfile1=${checkfull1#* }
				Bfilename=$(basename "$varfile")
				Afilename=$(basename "$varfile1")
				if [[ "$Afilename" == "$Bfilename" ]]; then
					echo "-----------------------------------------" >> diffed-files.txt
					echo "FILE A: $varfull" >> diffed-files.txt
					echo "FILE B: $checkfull1" >> diffed-files.txt
					diff $varfile $varfile1 >> diffed-files.txt
					echo "-----------------------------------------" >> diffed-files.txt
				fi
			fi
		done
	fi
done

