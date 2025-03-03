# DY_VBFfilter_privateProd

## Step1 get voms proxy: 
voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 4
export X509_USER_PROXY=$(pwd)/voms_proxy.txt


# Using SLURM
## Step2



production chain is taken from: https://cms-pdmv-prod.web.cern.ch/mcm/chained_requests?contains=SMP-RunIISummer20UL18MiniAODv2-00110&page=0&shown=15

fragment file for 2018 is taken from: https://cms-pdmv-prod.web.cern.ch/mcm/public/restapi/requests/get_setup/HIG-RunIIFall18wmLHEGS-00874


## Step 3

Run on hammer (cmsenv not required)
```
sbatch slurm_setup.sh 

```

Check progress on
```
squeue -u yun79

```

cancel all running jobs with
```
scancel -u yun79

```

# Using Condor
## Step 2
Run on lxplus (cmsenv not required)
```
condor_submit condor_sub.sub 
```
Check progress on
```
condor_q
```

## Step 3
cancel all running jobs with
```
condor_rm
```

# creating eos directory:

follow steps in https://www.physics.purdue.edu/Tier2/user-info/tutorials/dfs_commands.php

but gfal doesn't work on hammer or Analysis Facility, but on lxplus

ie

```
gfal-mkdir -p davs://eos.cms.rcac.purdue.edu:9000/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/gensim
```

The -p mode generate the parent directories if doesn't exist

