#!/bin/bash

# cu_train_srilm.sh
# Author: Renee Lu
# About: This code is for preparing the data/local/dict directory of CU Kids Speech Corpus
#        for kaldi ASR training.
#        Should be run from s5 directory.

CU_ROOT=$1
CUR_DIR=$2

# Check that the path to the corpus is passed as the argument
if [ $# != 1 ]; then
        echo "Usage: $(basename $0) /path/to/cu_data"
        exit 1;
fi

#Make sure that srilm installed
echo $KALDI_ROOT/tools/srilm/bin/i686-m64
which ngram-count
if [ $? -ne 0 ]; then
    if [ -d $KALDI_ROOT/tools/srilm/bin/i686-m64 ]; then
        export PATH=$PATH:$KALDI_ROOT/tools/srilm/bin/i686-m64
    fi
fi

langdir=`pwd`/data/lang
dir=`pwd`/data/local/lm_srilm

#Check if dir exist, otherwise create it
[ -d $dir ] || mkdir -p $dir || exit 1

# Get story text
local/get_stories.sh $CU_ROOT $CUR_DIR
# Get sentences text, output to local/sentences.txt
local/get_sentences.sh $CU_ROOT $CUR_DIR
# Get summary text

# Concatenate all the scripted story, sentences and summary text in file $dir/scripted_txt.tmp
# Also change all text to upper case
cat local/sentences.txt tr | [:lower:] [:upper:] >> $dir/scripted_txt.tmp
