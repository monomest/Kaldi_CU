# stories.sh
# Author: Renee Lu
# About: This code lists all the unique stories in the CU Kids'
#        Speech Corpus.
# Output: local/stories.txt

CU_ROOT=$1	# Path to CU Kids Speech Corpus
CUR_DIR=$2	# Path to s5 directory

cd $CU_ROOT

# Find all the unique stories from Grade 1-2 and list them in local/stories.txt
grep -rnw -e 'STORY ID' | sed 's@.*> @@' | sort | uniq > $CUR_DIR/local/stories.txt 

# Find all the unique stories from Grade 3-5 and then list them in local/stories.txt
find . -name 'story-name' -exec cat {} \; | sort | uniq >> $CUR_DIR/local/stories.txt

echo "SUCCESS: Created a list of all stories in the speech corpus in 'local/stories.txt'"
