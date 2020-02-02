# format.sh
# Author: Renee Lu
# About: This code removes all the blank white spaces in the .trs transcription files
#        in the CU Kids Speech Corpus. Only need to run once. 

CU_ROOT=$1
cd $CU_ROOT

echo "Formatting all .trs transcription files..."
files=$(find . -name "*.trs")
for file in $files; do
	sed -i '/^[[:space:]]*$/d' $file	
	dos2unix -q $file
	sed -i '/^$/d' $file
done
