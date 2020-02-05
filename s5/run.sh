#!/bin/bash

# run.sh
# Author: Renee Lu
# About: This code is for using the CU Kids' Speech Corpus for kaldi ASR training.

. ./cmd.sh	# Setting local system jobs (local CPU - no external clusters)
. ./path.sh	# Setting paths
set -e

n=15	# Number of jobs
CUR_DIR=$(pwd)	# Path to current s5 directory
#CU_ROOT=/media/renee/Windows/Users/rslaj/Documents/02_Work/2019_2020_Taste-of-Research/CU_Kids_Corpus	# Path to CU Kids Speech Corpus
CU_ROOT=/srv/scratch/z5160268/2020_TasteofResearch/CU_Kids_Corpus	# Path to CU Kids Speech Corpus on supercomputer

echo
echo "===== PREPARING RAW DATA ====="
echo

# format.sh only needs to be run once, in the first time after unzipping speech corpus file 
echo "Formatting transcription files (e.g. removing all empty spaces)..."
. ./format.sh $CU_ROOT
cd $CUR_DIR

# fix.sh only needs to be run once, in the first time after unzipping speech corpus file
echo "Applying some fixes to the data to remove edge cases..."
. ./fix.sh $CU_ROOT

echo "Converting .raw audio files into .wav formatted files..."
. ./raw2wav.sh $CU_ROOT
cd $CUR_DIR

echo
echo "===== PREPARING ACOUSTIC DATA ====="
echo

# Check if data has already been split into train, test and dev data portions
# and also print out the number of train, test and dev speakers and utterances
# Depending on whether data has already been split or not, either resplit and keep
# the existing split data.
local/cu_data_check.sh $CU_ROOT $CUR_DIR

echo
echo "===== EXTRACTING FEATURES ====="
echo

# Create feats.scp file in data/train, data/test and data/dev
echo "Creating 'feats.scp' in 'data/train' 'data/test' and 'data/dev'..."
    for part in train test dev; do
        mfccdir=data/$part/mfcc
        mfcclog=exp/make_mfcc/$part
        mkdir -p $mfccdir $mfcclog
        steps/make_mfcc.sh --nj $n --cmd "$train_cmd" data/$part $mfcclog $mfccdir      # Making feats.scp files for training
        steps/compute_cmvn_stats.sh data/$part $mfcclog $mfccdir        		# Making cmvn.scp files for training
	
	utils/validate_data_dir.sh data/$part	# Validate the data and check for errors
	utils/fix_data_dir.sh data/$part	# Fix the errors
	done

echo 
echo "===== PREPARING LANGUAGE DATA ====="
echo
# Prepare dict directory
# lexicon.txt               [ <word> <phone 1> <phone 2> ... ]
# nonsilence_phones.txt     [<phone>]
# silence_phones.txt        [<phone>]
# optional_silence.txt      [<phone>]

# Prepare the dict
local/cu_dict_prep.sh $CU_ROOT || exit 1  #I'm using set -e in the begining not sure if exit 1 needed
#Prepare lang directory
utils/prepare_lang.sh data/local/dict "<UNK>" data/local/lang data/lang || exit 1

echo
echo "===== CREATING LANGUAGE MODEL ====="
echo

# Train bigram LM
echo "Training Language Model (LM)..."
local/cu_train_srilm.sh $CU_ROOT $CUR_DIR

echo
echo "===== SUCCESS: run.sh has completed. ====="
