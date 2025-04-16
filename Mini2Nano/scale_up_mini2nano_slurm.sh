#!/bin/bash

# Binds for singularity containers
# Mount /afs, /eos, /cvmfs, /etc/grid-security for xrootd
export APPTAINER_BINDPATH='/cvmfs,/cvmfs/grid.cern.ch/etc/grid-security:/etc/grid-security,/etc/pki/ca-trust,/run/user,/var/run/user'

# Make voms proxy
# voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 48
export X509_USER_PROXY=$(pwd)/voms_proxy.txt

echo "Job started..."
echo "Starting job on " $(date)
echo "Running on: $(uname -a)"
echo "System software: $(cat /etc/redhat-release)"
# source /cvmfs/cms.cern.ch/cmsset_default.sh
# export SCRAM_ARCH=slc7_amd64_gcc700
echo "###################################################"
echo "#    List of Input Arguments: "
echo "###################################################"
echo "Input Arguments (Cluster ID): $1"
echo "Input Arguments (Proc ID): $2"
echo "Input Arguments (input rootfile txt file): $3"
echo "Input Arguments (output file): $4"
echo ""



seed=$(($1 + $2))


# Start the Mini -> Nano process


cat <<'EndOfMini2Nano' > EndOfMini2Nano.sh

export SCRAM_ARCH=el8_amd64_gcc11

source /cvmfs/cms.cern.ch/cmsset_default.sh

# Setting up CMSSW versions and configuration files
step7=CMSSW_13_0_14
step7_cfg=PPD-Run3Summer23NanoAODv12-00008_1_cfg.py

cmssw_dir="/tmp/yun79/dy_$1_$2/"
working_dir=$(pwd)
echo "cmssw_dir: ${cmssw_dir}"
echo "working_dir: ${working_dir}"
cd $cmssw_dir
curr_dir=$(pwd)
echo "current directory: ${curr_dir}"

echo "###################################################"
echo "Running step7..."
if [ -r ${step7}/src ] ; then
    echo release ${step7} already exists
    echo deleting release ${step7}
    rm -rf ${step7}
    scram p CMSSW ${step7}
else
    scram p CMSSW ${step7}
fi
echo list files inside ${step7}
ls ${step7}
echo "--------"
cd ${step7}/src
eval `scram runtime -sh`
scram b
cd -
cmsRun ${step7_cfg}
echo "list all files"
ls -ltrh

# Copy output nanoAOD file to output directory
echo "Copying output nanoAOD file to output directory"
ls -ltrh
echo "xrdcp -f SMP-RunIISummer20UL18NanoAODv12-00008.root root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer/$3"
xrdcp -f SMP-RunIISummer20UL18NanoAODv12-00008.root root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer/$3
# xrdcp -f SMP-RunIISummer20UL18NanoAODv12-00008.root root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nano_test/$3


cd ..
echo "Current directory: $(pwd)"
echo "removing directory: rm -r ${cmssw_dir}"
rm -r ${cmssw_dir}
echo "Job finished on " $(date)


EndOfMini2Nano


# Make file executable
chmod +x EndOfMini2Nano.sh

if [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el8:amd64" ]; then
  CONTAINER_NAME="el8:amd64"
elif [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el8:x86_64" ]; then
  CONTAINER_NAME="el8:x86_64"
else
  echo "Could not find amd64 or x86_64 for el8"
  exit 1
fi
export SINGULARITY_CACHEDIR="/tmp/$(whoami)/singularity"
singularity run --no-home /cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/$CONTAINER_NAME $(echo $(pwd)/EndOfMini2Nano.sh $1 $2 $4)