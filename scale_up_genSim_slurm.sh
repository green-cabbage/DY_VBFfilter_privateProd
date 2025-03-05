#!/bin/bash

# Binds for singularity containers
# Mount /afs, /eos, /cvmfs, /etc/grid-security for xrootd
export APPTAINER_BINDPATH='/cvmfs,/cvmfs/grid.cern.ch/etc/grid-security:/etc/grid-security,/etc/pki/ca-trust,/run/user,/var/run/user'

# Make voms proxy
# voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 4
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
echo "Input Arguments (Output Dir): $3"
echo ""





cat <<'EndOfLHE' > EndOfLHE.sh
#!/bin/bash

# Setting up CMSSW versions and configuration files
cmssw_dir="/tmp/yun79/dy_$1_$2/"
working_dir=$(pwd)
echo "working_dir: ${working_dir}"
step1=CMSSW_10_6_28_patch1
step1_cfg=SMP-RunIISummer20UL18wmLHEGEN-00314_1_cfg.py
step2=CMSSW_10_6_17_patch1
step2_cfg=SMP-RunIISummer20UL18SIM-00112_1_cfg.py
step3=CMSSW_10_6_17_patch1
step3_cfg=SMP-RunIISummer20UL18DIGIPremix-00114_1_cfg.py
step4=CMSSW_10_2_16_UL
step4_cfg=SMP-RunIISummer20UL18HLT-00114_1_cfg.py
step5=CMSSW_10_6_17_patch1
step5_cfg=SMP-RunIISummer20UL18RECO-00114_1_cfg.py 
step6=CMSSW_10_6_20
step6_cfg=SMP-RunIISummer20UL18MiniAODv2-00110_1_cfg.py


seed=$(($1 + $2))

echo "seed: $seed"
export SCRAM_ARCH=slc7_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
echo "CMSSW directory: $cmssw_dir"
mkdir -p $cmssw_dir
cd $cmssw_dir
echo "###################################################"
echo "Running step1..."
export SCRAM_ARCH=slc7_amd64_gcc700
if [ -r ${step1}/src ] ; then
    echo release ${step1} already exists
    echo deleting release ${step1}
    # rm -rf ${step1}
    # scram p CMSSW ${step1}
else
    scram p CMSSW ${step1}
fi
echo list files inside ${step1}
ls ${step1}
echo "--------"
cd ${step1}/src
eval `scram runtime -sh`
scram b
cd -
# cd $working_dir
# echo "working_dir: ${working_dir}"
echo "cp ${working_dir}/${step1_cfg} . "
cp ${working_dir}/${step1_cfg} . 
echo "Current directory: $(pwd)"
echo "cmsRun ${step1_cfg} seedval=${seed} outputFile=root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Test/genSim_$1_$2.root"
# cmsRun ${step1_cfg} seedval=${seed} outputFile=root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Test/genSim_$1_$2.root
cmsRun ${step1_cfg} seedval=${seed} outputFile=root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/gensim_hammer/genSim_$1_$2.root # hammer


echo "list all files"
ls -ltrh

# Copy output nanoAOD file to output directory
echo "Copying output nanoAOD file to output directory"
ls -ltrh
# echo "cp -f RunIISummer20UL18wmLHEGEN-00314_inLHE.root $3/genSim_$1_$2.root"
# cp -f RunIISummer20UL18wmLHEGEN-00314_inLHE.root $3/genSim_$1_$2.root

cd ..
echo "Current directory: $(pwd)"
echo "removing directory: rm -r ${cmssw_dir}"
rm -r ${cmssw_dir}
echo "Job finished on " $(date)

EndOfLHE


# Make file executable
chmod +x EndOfLHE.sh

if [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el7:amd64" ]; then
  CONTAINER_NAME="el7:amd64"
elif [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el7:x86_64" ]; then
  CONTAINER_NAME="el7:x86_64"
else
  echo "Could not find amd64 or x86_64 for el7"
  exit 1
fi
export SINGULARITY_CACHEDIR="/tmp/$(whoami)/singularity"
singularity run --no-home /cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/$CONTAINER_NAME $(echo $(pwd)/EndOfLHE.sh $1 $2 $3)


