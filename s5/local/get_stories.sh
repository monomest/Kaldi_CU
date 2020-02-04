# get_stories.sh
# Author: Renee Lu
# About: This code is for getting all the text from the stories read aloud
#        by the children in CU Kids Speech Corpus.
#        Used for kaldi Language Modelling.

#CU_ROOT=$1
#CUR_DIR=$2

CUR_DIR=/media/renee/Windows/Users/rslaj/Documents/02_Work/2019_2020_Taste-of-Research/kaldi/egs/Kaldi_CU/s5  # Path to current s5 directory
CU_ROOT=/media/renee/Windows/Users/rslaj/Documents/02_Work/2019_2020_Taste-of-Research/CU_Kids_Corpus   # Path to CU Kids Speech Corpus

allIDs=$CUR_DIR/local/storyIDs.txt
storiesfile=$CUR_DIR/local/stories.txt

noname=0

touch $allIDs
cd $CU_ROOT

# Find a list of all folders of speakers and loop through them
spkrs=$(find . -type d -name "spk*")
for spkr in $spkrs; do
	cd $spkr/story
	# If .txt files exist, then use them
	txt=$(find . -name "*.txt")
	trs=$(find . -name "*.trs")
	if [ -n "$txt" ]; then
		# Get the storyID
		storyID=$(grep -rnw -e 'STORY ID' | sed 's@.*> @@'| sort -u)
		# If the storyID has already been recorded then skip this speaker
		# Else, record the story ID and get all the text from the story
		if grep -q "$storyID" $allIDs; then
 			: # Do nothing
		 else
			# Record the storyID
			echo "$storyID" >> $allIDs
			name=$(echo ${storyID// /_})
			storytmp=$CUR_DIR/local/storytmp_$name.txt
			touch $storytmp
			# Iterate through every .txt file and write the text to local/storytmp_$storyID.txt file
			for txtfile in $txt; do
				totlines=$(wc -l < "$txtfile")
				for ((line=14;line<totlines;line++)); do
        				sed "${line}q;d" $txtfile >> $storytmp
				done
			done	
			# Remove all new lines from local/storytmp_$storyID.txt file
			sed -i ':a;N;$!ba;s/\n/ /g' $storytmp
			# Concatenate the contents of local/storytmp_$storyID.txt file into the
			# total list of story text file, called $storiesfile
			cat $storytmp >> $storiesfile
		fi
	# Else if .trs files exist, use them
	elif [ -n "$trs" ]; then
		# Get the story ID
		FILE=../story-name
		if [ -f "$FILE" ]; then
			storyID=$(cat ../story-name)
		else 
			echo "WARNING: story-name file does not exist in '$(pwd)'"
			echo "Giving the story the name '$noname'."
			storyID=$noname
			noname=$((noname+1))
		fi
		# If the storyID has already been recorded then skip this speaker
                # Else, record the story ID and get all the text from the story
                if grep -q "$storyID" $allIDs; then
                        : # Do nothing
                else
                        # Record the storyID
                        echo "$storyID" >> $allIDs
                        name=$(echo ${storyID// /_})
                        storytmp=$CUR_DIR/local/storytmp_$name.txt
                        touch $storytmp
                        # Iterate through every .trs file and write the text to local/storytmp_$storyID.txt file
                        for trsfile in $trs; do
 	                	start=0
				while IFS= read -r line
				do
					# When the transcription starts
                                	if [[ $line == *"<Turn startTime"* ]]; then
                                        	start=1
                                    	fi
					# Get the transcription
                                 	if [[ $line != *"<"* ]] && [[ start -eq 1 ]]; then
                                        	trans=$line
						trans=$(echo "$trans" | tr -d '\r')
                				# Convert transcription into all UPPERCASE
                				trans=$(echo ${trans^^})
						# Replace '&LT;' with '<'
                				trans=$(echo ${trans//&LT;/<})
                				# Replace '&GT;' with '>'
                				trans=$(echo ${trans//&GT;/>})
                				# If transcription has event label, remove the label
						array=( "<DISCARD>" "<MP>" "<B>" "<BR>" "<COUGH>" "<GARB>" "<SIL>" "<UU>" )
						for remove in "${array[@]}"
						do
                					trans=$(printf '%s\n' "${trans//$remove/}")
						done
                				# Replace all ? with apostrophe since transcription has words like 'couldn?t' and 'didn?t'
                				trans=$(echo $trans | sed "s/?/'/")
                                    		echo "$trans" >> $storytmp	
					fi
				done < "$trsfile"
			done
                        # Remove all new lines from local/storytmp_$storyID.txt file
                        sed -i ':a;N;$!ba;s/\n/ /g' $storytmp

                        # Concatenate the contents of local/storytmp_$storyID.txt file into the
                        # total list of story text file, called $storiesfile
                        cat $storytmp >> $storiesfile
                fi
	fi
	# Else, no transcription exists so move on.
	cd ../../	
done
# DONE Go into the 'story' folder for each speaker
	# DONE If .txt files exist, use them
		# DONE Get the story ID
		# DONE If the story ID has not been recorded
			# DONE Record the story ID
			# DONE Get all the text from the story
		# DONE Else if the story ID has been recorded
			# DONE Move onto next speaker	
	# DONE Else if .trs files exist, use
		# DONE Get the story ID
		# DONE If the story ID has not been recorded
			# DONE Record story ID
			# DONE Get all the text from the story
		# DONE Else if the story ID has been recorded
			# DONE Move onto next speaker
	# Else, no transcription exists
		# Move onto the next speaker
# Finally, convert lower case to upper case and normalise etc.
