# DY_VBFfilter_privateProd

## Step1 get voms proxy: 
voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 100
export X509_USER_PROXY=$(pwd)/voms_proxy.txt

get input_dict.json

```
python organizeInRootFiles.py
```

# Using SLURM
## Step2

production chain is taken from (pick 2017 version): https://cms-pdmv-prod.web.cern.ch/mcm/chained_requests?page=0&dataset_name=DYJetsToLL_LHEFilterPtZ-0To50_MatchEWPDG20_TuneCP5_13TeV-amcatnloFXFX-pythia8&shown=143

## Step 3

Run on hammer (cmsenv not required)
```
cd resubmission
python get_missing_files.py -mode slurm --remove_bad_nano

```

-mode slurm specfies the save path to be on slurm. --remove_bad_nano flag also checks already complete nano files and see if any of them are corrupt, and if so, add them to the list. The input root batch number is saved in missing_files_slurm.txt. Then you do

```
cd ../
sh resubmist_slurm.sh

```

Check progress on
```
squeue -u yun79

```

cancel all running jobs with
```
scancel -u yun79

```

# creating eos directory:

follow steps in https://www.physics.purdue.edu/Tier2/user-info/tutorials/dfs_commands.php

but gfal doesn't work on hammer or Analysis Facility, but on lxplus

ie

```
gfal-mkdir -p davs://eos.cms.rcac.purdue.edu:9000/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/gensim
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

To count number of files in a bash terminal
```
ls -1 <path> | wc -l

```

## setting up CMSSW again from scratch

This theorectically you need to do once, but in case it you have to do it again:
```
source /cvmfs/cms.cern.ch/cmsset_default.sh
source /cvmfs/cms.cern.ch/crab3/crab.sh
cmssw-el7 --bind /depot:/depot
voms-proxy-init -voms cms

curl -s -k https://cms-pdmv-prod.web.cern.ch/mcm/public/restapi/requests/get_fragment/HIG-RunIIFall18wmLHEGS-00874 --retry 3 --create-dirs -o Configuration/GenProduction/python/HIG-RunIIFall18wmLHEGS-00874-fragment.py

export SCRAM_ARCH=slc7_amd64_gcc700
cmsrel CMSSW_10_6_28_patch1
cd CMSSW_10_6_28_patch1/src
cmsenv

mv ../../Configuration .

scram b
```