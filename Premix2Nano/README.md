## step1 compare SIM and Mini output files

compare the output root files from sim and mini eos hammer directories. If missing, we need to re-run those
NOTE: we automatically filter out bad files from both sim and mini outputs so the full missing list may be smaller than that you see in naked eye
```
python get_missing_files.py -mode slurm
```

This code above saves the missing numbers and saves to missing_files_slurm.txt


## Step2

Run the script. First, grid certificate:
```
voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 48
export X509_USER_PROXY=$(pwd)/voms_proxy.txt
```

```
source resubmit_slurm.sh 
```
