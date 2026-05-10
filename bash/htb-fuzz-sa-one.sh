#!/bin/bash

# Fuzzer for HTB Binary Fuzzing sa-one

while true; do
	echo "a" | radamsa -n 1 --output-template "<<in<<%f" > fuzz.txt;
	./sa-one < fuzz.txt;

	if [[ $? -eq 1 ]]; then
		cat fuzz.txt > output-fuzz.txt;
		break;
	fi;
done

