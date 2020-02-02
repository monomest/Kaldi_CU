# Kaldi_CU

Kaldi recipe for CU Kids Speech Corpus data model building

**Steps**:
Make sure kaldi is installed first before proceeding.
1.  Download the CU Kids Speech Corpus dataset
2.  In ```run.sh``` modify CU_ROOT to point to the main directory of the dataset
3.  ```./run.sh```  **This will build the HMM-GMM model**
4.  After completed successfully run ```local/nnet3/run_tdnn_delta.sh```  **for the TDNN model**

**Install Kaldi**:
Refer to: https://kaldi-asr.org/doc/tutorial_setup.html

1. ```git clone https://github.com/kaldi-asr/kaldi.git```
2. Look at the ```kaldi/INSTALL``` file and follow the instructions there
3. Download SRILM by running ```kaldi/tools/install_srilm.sh```

**Initialising katana**:

To execute the steps using the supercomputer katana.

1. ```ssh zID@katana1.restech.unsw.edu.au``` in terminal. Or, use the alias ```katana```.
2. Create a new screen using ```screen -S nameOfSession```.
3. Request an interactive GPU node using ```qsub -I -l select=1:ngpus=2:ncpus=16:mem=80gb,walltime=10:00:00```. Once the node is ready, you are now in the node. The terminal will show (zID@kxx), where kxx is your node. 
4. Now you are inside the screen, and inside the GPU node. Run whatever process you need. 

**Leaving katana**
Asumming you are inside a screen, and inside a requested GPU node. 
1. ```CtrlA D``` to detach from the screen session.
2. ```Ctrl D``` to logout of the GPU node ssh session. 
3. ```Ctrl D``` to logout of the katana session.

**Returning to katana**
1. ```ssh zID@katana1.restech.unsw.edu.au``` in terminal. Or, use the alias ```katana```.
2. Go back to the GPU node ```ssh kxxx```, log in with ZPass e.g. ssh k103
3. Go back to your screen ```screen -r nameOfSession``` eg. screen -r ogi

**Useful katana screen things**
- To create a new window (tab) within a screen, use ```CtrlA C```
- To go to next and previous windows, use ```CtrlA N``` and ```CtrlA P``` respectively.
