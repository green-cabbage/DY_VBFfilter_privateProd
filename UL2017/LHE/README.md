# DY_VBFfilter_privateProd

## Step1 get voms proxy: 
voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 48
export X509_USER_PROXY=$(pwd)/voms_proxy.txt



# creating eos directory:

follow steps in https://www.physics.purdue.edu/Tier2/user-info/tutorials/dfs_commands.php

but gfal doesn't work on hammer or Analysis Facility, but on lxplus

ie

```
gfal-mkdir -p davs://eos.cms.rcac.purdue.edu:9000/store/user/hyeonseo/Run2UL/UL2017/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/gensim
```

The -p mode generate the parent directories if doesn't exist

# Using Crab

## step 1

Assuming you have CMSSW and necessaryu portions pre-installed already (in genSim case, that's CMSSW_10_6_28_patch1):

```
source /cvmfs/cms.cern.ch/cmsset_default.sh
source /cvmfs/cms.cern.ch/crab3/crab.sh
cmssw-el7 --bind /depot:/depot
voms-proxy-init -voms cms

export SCRAM_ARCH=slc7_amd64_gcc700
cd CMSSW_10_6_28_patch1/src
cmsenv
scram b 
cd ../../


crab submit -c crab_genSim.py --dryrun
crab submit -c crab_genSim.py 

```

For resubmission, use the resubmission script (assuming the proper CMSSW is setup)
```
sh crab_resubmission.sh
```