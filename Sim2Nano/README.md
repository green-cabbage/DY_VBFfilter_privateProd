# DY_VBFfilter_privateProd RawSim to NAno

## Step1 get premix files
since the das path for neutrino Gun pileup files are broken right now, we need to manually into the files that we can read
```
voms-proxy-init --voms cms
python get_files_on_disk.py /Neutrino_E-10_gun/RunIISummer20ULPrePremix-UL18_106X_upgrade2018_realistic_v11_L1v1-v2/PREMIX -u <cern_username> -a T2_US_Nebraska 
```
T2_US_Nebraska was the best tier2 US base that had some premix root files at the time of writing
This will save the root file list in input_fnames/pu_filelist.txt


## Step3 input root files:
```
python organizeInRootFiles.py
``` 

## Step4 get voms proxy: 
```
voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 4
export X509_USER_PROXY=$(pwd)/voms_proxy.txt
```






# creating eos directory:

follow steps in https://www.physics.purdue.edu/Tier2/user-info/tutorials/dfs_commands.php

but gfal doesn't work on hammer or Analysis Facility, but on lxplus

ie (do this on lxplus)

```
voms-proxy-init --voms cms 
gfal-mkdir -p davs://eos.cms.rcac.purdue.edu:9000/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer
```