#!/bin/bash

path1=$1
path2=$2
path3=$3

echo "-----------------------------------------------------------------------------------------"
echo "-----PATH INPUTS:"
echo "-----------------------------------------------------------------------------------------"
echo "PATH1 A: $path1"
echo "PATH2 B: $path2"
echo "PATH3 C: $path3"

echo "-----------------------------------------------------------------------------------------"
echo "-----PATH IDENTIFICATION"
echo "-----------------------------------------------------------------------------------------"
find "$path1" -type d -print > test-path-1.txt
find "$path2" -type d -print > test-path-2.txt
echo "Path1: $path1"
echo "Path2: $path2"
echo ""

echo "-----------------------------------------------------------------------------------------"
echo "----find all files"
echo "-----------------------------------------------------------------------------------------"
find "$path1" -type f > path1-files.txt
find "$path2" -type f > path2-files.txt
find "$path3" -type f > path3-files.txt

echo ""

echo "-----------------------------------------------------------------------------------------"
echo "----get sha256: $path1"
echo "-----------------------------------------------------------------------------------------"
echo "" > path1-files-sha256.txt
cat path1-files.txt | while IFS= read -r pathFile1; do
	echo "$(sha256sum $pathFile1)" >> path1-files-sha256.txt
done

echo "-----------------------------------------------------------------------------------------"
echo "----get sha256: $path2"
echo "-----------------------------------------------------------------------------------------"
echo "" > path2-files-sha256.txt
cat path2-files.txt | while IFS= read -r pathFile2; do
	echo "$(sha256sum $pathFile2)" >> path2-files-sha256.txt
done
echo ""

echo "-----------------------------------------------------------------------------------------"
echo "----get sha256: $path3"
echo "-----------------------------------------------------------------------------------------"
echo "" > path3-files-sha256.txt
cat path3-files.txt | while IFS= read -r pathFile3; do
	echo "$(sha256sum $pathFile3)" >> path3-files-sha256.txt
done

echo "-----------------------------------------------------------------------------------------"
echo "----get meta data: $path1"
echo "-----------------------------------------------------------------------------------------"
echo "" > path1-files-meta.txt
echo "" > path1-files-type.txt
cat path1-files.txt | while IFS= read -r pathFile1; do
	echo "$(stat $pathFile1)" >> path1-files-meta.txt
	echo "$(file $pathFile1)" >> path1-files-type.txt
done

echo "-----------------------------------------------------------------------------------------"
echo "----get meta data: $path2"
echo "-----------------------------------------------------------------------------------------"
echo "" > path2-files-meta.txt
echo "" > path2-files-type.txt
cat path2-files.txt | while IFS= read -r pathFile2; do
	echo "$(stat $pathFile2)" >> path2-files-meta.txt
	echo "$(file $pathFile2)" >> path2-files-type.txt
done
echo ""

echo "-----------------------------------------------------------------------------------------"
echo "----get meta data: $path3"
echo "-----------------------------------------------------------------------------------------"
echo "" > path3-files-meta.txt
echo "" > path3-files-type.txt
cat path3-files.txt | while IFS= read -r pathFile3; do
	echo "$(stat $pathFile3)" >> path3-files-meta.txt
	echo "$(file $pathFile3)" >> path3-files-type.txt
done

