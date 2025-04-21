## step1 compare Mini and Nano output files

compare the output root files from mini and nano eos hammer directories. If missing, we need to re-run those
NOTE: we automatically filter out bad files from both mini and nano outputs so the full missing list may be smaller than that you see in naked eye
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
