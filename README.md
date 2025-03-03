# DY_VBFfilter_privateProd

## Step1 get voms proxy: 
voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 4

## Step2



production chain is taken from: https://cms-pdmv-prod.web.cern.ch/mcm/chained_requests?contains=SMP-RunIISummer20UL18MiniAODv2-00110&page=0&shown=15

fragment file for 2018 is taken from: https://cms-pdmv-prod.web.cern.ch/mcm/public/restapi/requests/get_setup/HIG-RunIIFall18wmLHEGS-00874


## Step 3

Run on hammer (not cmsenv required)
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

## creating eos directory:

follow steps in https://www.physics.purdue.edu/Tier2/user-info/tutorials/dfs_commands.php

but gfal doesn't work on hammer or Analysis Facility, but on lxplus