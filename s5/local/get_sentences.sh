# get_sentences.sh
# Author: Renee Lu
# About: This code lists all the scripted 'sentences' the children are prompted to read
#        from the CU Kids Speech Corpus. 
#        Used for kaldi Language Modelling.

CU_ROOT=$1 	# Path to CU Kids Speech Corpus
CUR_DIR=$2	# Path fo s5 directory
dir=$CU_ROOT/spk-03-034/sentences	# Path to a speaker's 'sentences' folder

# Go into $dir and output all the 25 sentences into local/sentences.txt file
cd $dir
find . -name "*.txt" -exec cat {} >> $CUR_DIR/local/sentences.txt \;
