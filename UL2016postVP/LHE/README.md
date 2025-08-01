# DY_VBFfilter_privateProd

## Step1 get voms proxy: 
voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 48
export X509_USER_PROXY=$(pwd)/voms_proxy.txt

## Step2


production chain is taken from (pick 2016postVFP version): https://cms-pdmv-prod.web.cern.ch/mcm/chained_requests?page=0&dataset_name=DYJetsToLL_LHEFilterPtZ-0To50_MatchEWPDG20_TuneCP5_13TeV-amcatnloFXFX-pythia8&shown=143


We needed to add the gridpack from RERECO DY VBF-filtered sample plus the VBF-filter definition in the fragment file. The fragment file used for GEN production of 2017 UL is saved at ../Configuration/GenProduction/python/SMP-RunIISummer20UL17wmLHEGEN-00320-fragment_4VBFFilter.py

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

Assuming you have CMSSW and necessaryu portions pre-installed already (in genSim 2016postVFP case, that's CMSSW_10_6_28):

```
source /cvmfs/cms.cern.ch/cmsset_default.sh
source /cvmfs/cms.cern.ch/crab3/crab.sh
cmssw-el7 --bind /depot:/depot
voms-proxy-init -voms cms --hours 100

export SCRAM_ARCH=slc7_amd64_gcc700
cd CMSSW_10_6_28/src
cmsenv
scram b 
cd ../../


crab submit -c crab_genSim.py --dryrun
crab submit -c crab_genSim.py 

```

NOTE: Before you actually submit, please hard code Nevents parameter in the cfg python file if you haven't done so, and paste them wherever they seem relevant. Compare already made cfg files from other years for reference.


For resubmission, use the resubmission script (assuming the proper CMSSW is setup)
```
sh crab_resubmission.sh
```
