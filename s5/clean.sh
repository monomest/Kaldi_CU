# clean.sh
# Author: Renee
# About: This code deletes all the new files created in the 
#        kaldi_CU/s5 directory after executing run.sh
#        To be run in the s5 directory.

CUR_DIR=$(pwd)	# Path to s5 directory
#CU_ROOT=/media/renee/Windows/Users/rslaj/Documents/02_Work/2019_2020_Taste-of-Research/CU_Kids_Corpus   # Path to CU Kids Speech Corpus
CU_ROOT=/srv/scratch/z5160268/2020_TasteofResearch/CU_Kids_Corpus	# Path to CU Kids Speech Corpus in supercomputer

# Array of all files to remove
allfiles=( local/spkrs.txt local/uttInfo.txt local/uniqchar.txt local/tags.txt )
alldir=( data exp )

# Array of files to remove to re-split data and re-train models
splitfiles=( local/uniqchar.txt local/tags.txt )
splitdir=( data exp )

# Array of files to remove while keeping train, test and dev portions the same
portion=(  )
echo "Do you want to:"
read -r -p "(1) Remove all files and directories BUT keep the train, test and dev portions the same (2) Remove enough files so you can re-split the data and re-train the models (3) Remove literally ALL files and directories created by the scripts (including .wav files) [1/2/3] " response
	if [[ "$response" =~ ^([3])$ ]]
        then
                echo "Removing ALL files created by the scripts..."
		for file in "${allfiles[@]}"
		do
 			 echo "Removing the file $file..."
 			 rm $file
		done
		echo "Removing ALL directories created by the scripts..."
		for dir in "${alldir[@]}"
		do
			echo "Removing the directory $dir..."
			rm -r $dir
		done
		echo "Removing all .wav files..."
		cd $CU_ROOT
		find . -name "*.wav" -exec rm {} \;
	elif [[ "$response" =~ ^([2])$ ]]
	then
                echo "Removing files to enable re-splitting data and re-training models..."
		for file in "${splitfiles[@]}"
		do
			echo "Removing the file $file..."
			rm $file
		done
		
		for dir in "${splitdir[@]}"
		do 
			echo "Removing the directory $dir..."
			rm -r $dir
		done
	elif [[ "$response" =~ ^([1])$ ]]
	then
		echo "Removing files but keeping data split portions the same... "
	else
		echo "Your response is invalid. Please enter either '1' or '2' or '3' corresponding to which action you want to take."
		
	fi
echo "DONE"
