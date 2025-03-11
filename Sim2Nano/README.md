# DY_VBFfilter_privateProd RawSim to NAno

## Step1 get premix files
since the das path for neutrino Gun pileup files are broken right now, we need to manually into the files that we can read
```
voms-proxy-init --voms cms
python get_files_on_disk.py /Neutrino_E-10_gun/RunIISummer20ULPrePremix-UL18_106X_upgrade2018_realistic_v11_L1v1-v2/PREMIX -u <cern_username>
```
This will save the root file list in input_fnames/pu_filelist.txt



## Step2 get voms proxy: 
voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 4
export X509_USER_PROXY=$(pwd)/voms_proxy.txt

