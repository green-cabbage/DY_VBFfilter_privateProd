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
echo "Input Arguments (input rootfile txt file): $3"
echo "Input Arguments (output file): $4"
echo ""



seed=$(($1 + $2))


cat <<'EndOfLHE2Mini' > EndOfLHE2Mini.sh
#!/bin/bash

# Setting up CMSSW versions and configuration files
cmssw_dir="/tmp/yun79/dy_$1_$2/"
working_dir=$(pwd)
echo "cmssw_dir: ${cmssw_dir}"
echo "working_dir: ${working_dir}"


mkdir -p $cmssw_dir
cd $cmssw_dir
echo "cp -r ${working_dir}/* . "
cp -r ${working_dir}/* . 


# Setting up CMSSW versions and configuration files
step2=CMSSW_10_6_17_patch1
step2_cfg=SMP-RunIISummer20UL16SIM-00113_1_cfg_hammer.py
step2OutFile=SMP-RunIISummer20UL16SIM-00113.root
step3=CMSSW_10_6_17_patch1
step3_cfg=SMP-RunIISummer20UL16DIGIPremix-00110_1_cfg_hammer.py
step3OutFile=SMP-RunIISummer20UL16DIGIPremix-00110.root
step4=CMSSW_8_0_33_UL
step4_cfg=SMP-RunIISummer20UL16HLT-00113_1_cfg.py
step4OutFile=SMP-RunIISummer20UL16HLT-00113.root
step5=CMSSW_10_6_17_patch1
step5_cfg=SMP-RunIISummer20UL16RECO-00113_1_cfg.py 
step5OutFile=SMP-RunIISummer20UL16RECO-00113.root
step6=CMSSW_10_6_25
step6_cfg=SMP-RunIISummer20UL16MiniAODv2-00103_1_cfg.py
step6OutFile=SMP-RunIISummer20UL16MiniAODv2-00103.root
yearUL=UL2016postVFP


source /cvmfs/cms.cern.ch/cmsset_default.sh
echo "###################################################"
echo "Running step2..."
export SCRAM_ARCH=slc7_amd64_gcc700
if [ -r ${step2}/src ] ; then
    echo release ${step2} already exists
    echo deleting release ${step2}
    rm -rf ${step2}
    scram p CMSSW ${step2}
else
    scram p CMSSW ${step2}
fi
echo list files inside ${step2}
ls ${step2}
echo "--------"
cd ${step2}/src
eval `scram runtime -sh`
scram b
cd -
echo "cmsRun ${step2_cfg} inputFiles=$3"
cmsRun ${step2_cfg} inputFiles=$3
echo "list all files"
ls -ltrh

# Copy output miniAOD file to output directory
echo "Copying output miniAOD file to output directory"
echo "xrdcp -f ${step2OutFile} root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/${yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/sim_hammer/sim_$4"
# xrdcp -f ${step2OutFile} root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/${yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/sim_hammer/sim_$4
xrdcp -f ${step2OutFile} root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/${yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/gensim_test/sim_$4



echo "###################################################"
echo "Running step3..."
export SCRAM_ARCH=slc7_amd64_gcc700
if [ -r ${step3}/src ] ; then
    echo release ${step3} already exists
    echo deleting release ${step3}
    rm -rf ${step3}
    scram p CMSSW ${step3}
else
    scram p CMSSW ${step3}
fi
echo list files inside ${step3}
ls ${step3}
echo "--------"
cd ${step3}/src
eval `scram runtime -sh`
scram b
cd -
cmsRun ${step3_cfg}
echo "list all files"
ls -ltrh
echo "###################################################"
echo "Running step4..."
export SCRAM_ARCH=slc7_amd64_gcc630
if [ -r ${step4}/src ] ; then
    echo release ${step4} already exists
    echo deleting release ${step4}
    rm -rf ${step4}
    scram p CMSSW ${step4}
else
    scram p CMSSW ${step4}
fi
echo list files inside ${step4}
ls ${step4}
echo "--------"
cd ${step4}/src
eval `scram runtime -sh`
scram b
cd -
cmsRun ${step4_cfg}
echo "list all files"
ls -ltrh
echo "###################################################"
echo "Running step5..."
export SCRAM_ARCH=slc7_amd64_gcc700
if [ -r ${step5}/src ] ; then
    echo release ${step5} already exists
    echo deleting release ${step5}
    rm -rf ${step5}
    scram p CMSSW ${step5}
else
    scram p CMSSW ${step5}
fi
echo list files inside ${step5}
ls ${step5}
echo "--------"
cd ${step5}/src
eval `scram runtime -sh`
scram b
cd -
cmsRun ${step5_cfg}
echo "list all files"
ls -ltrh
echo "###################################################"
echo "Running step6..."
export SCRAM_ARCH=slc7_amd64_gcc700
if [ -r ${step6}/src ] ; then
    echo release ${step6} already exists
    echo deleting release ${step6}
    rm -rf ${step6}
    scram p CMSSW ${step6}
else
    scram p CMSSW ${step6}
fi
echo list files inside ${step6}
ls ${step6}
echo "--------"
cd ${step6}/src
eval `scram runtime -sh`
scram b
cd -
cmsRun ${step6_cfg}
echo "list all files"
ls -ltrh

# Copy output miniAOD file to output directory
echo "Copying output miniAOD file to output directory"
echo "xrdcp -f ${step6OutFile} root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/${yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/miniV2_hammer/mini_$4"
# xrdcp -f ${step6OutFile} root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/${yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/miniV2_hammer/mini_$4
xrdcp -f ${step6OutFile} root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/${yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/gensim_test/mini_$4


EndOfLHE2Mini


# Make file executable
chmod +x EndOfLHE2Mini.sh

if [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el7:amd64" ]; then
  CONTAINER_NAME="el7:amd64"
elif [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el7:x86_64" ]; then
  CONTAINER_NAME="el7:x86_64"
else
  echo "Could not find amd64 or x86_64 for el7"
  exit 1
fi
export SINGULARITY_CACHEDIR="/tmp/$(whoami)/singularity"
singularity run --no-home /cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/$CONTAINER_NAME $(echo $(pwd)/EndOfLHE2Mini.sh $1 $2 $3 $4)


# Start the Mini -> Nano process


cat <<'EndOfMini2Nano' > EndOfMini2Nano.sh

export SCRAM_ARCH=el8_amd64_gcc11

source /cvmfs/cms.cern.ch/cmsset_default.sh

# Setting up CMSSW versions and configuration files
step7=CMSSW_13_0_14
step7_cfg=PPD-RunIISummer20UL16postVFP_NanoAODv12_cfg.py
step7OutFile=PPD-RunIISummer20UL16preVFP_NanoAODv12.root
yearUL=UL2016postVFP

cmssw_dir="/tmp/yun79/dy_$1_$2/"
working_dir=$(pwd)
echo "cmssw_dir: ${cmssw_dir}"
echo "working_dir: ${working_dir}"
mkdir -p $cmssw_dir
cd $cmssw_dir
echo "cp -r ${working_dir}/* . "
cp -r ${working_dir}/* .
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
echo "xrdcp -f ${step7OutFile} root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/${yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer/$3"
# xrdcp -f ${step7OutFile} root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/${yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer/$3
xrdcp -f ${step7OutFile} root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/${yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/gensim_test/$3


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