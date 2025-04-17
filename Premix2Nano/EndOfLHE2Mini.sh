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
step1=CMSSW_10_6_28_patch1
step1_cfg=SMP-RunIISummer20UL18wmLHEGEN-00314_1_cfg.py
step2=CMSSW_10_6_17_patch1
step2_cfg=SMP-RunIISummer20UL18SIM-00112_1_cfg_hammer.py
step3=CMSSW_10_6_17_patch1
step3_cfg=SMP-RunIISummer20UL18DIGIPremix-00114_1_cfg_hammer.py
step4=CMSSW_10_2_16_UL
step4_cfg=SMP-RunIISummer20UL18HLT-00114_1_cfg.py
step5=CMSSW_10_6_17_patch1
step5_cfg=SMP-RunIISummer20UL18RECO-00114_1_cfg.py 
step6=CMSSW_10_6_20
step6_cfg=SMP-RunIISummer20UL18MiniAODv2-00110_1_cfg.py



source /cvmfs/cms.cern.ch/cmsset_default.sh

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
echo "cmsRun ${step3_cfg} inputFiles=$3"
cmsRun ${step3_cfg} inputFiles=$3
echo "list all files"
ls -ltrh
echo "###################################################"
echo "Running step4..."
export SCRAM_ARCH=slc7_amd64_gcc530
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
echo "xrdcp -f SMP-RunIISummer20UL18MiniAODv2-00110.root root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/miniV2_hammer/mini_$4"
xrdcp -f SMP-RunIISummer20UL18MiniAODv2-00110.root root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/miniV2_hammer/mini_$4
# xrdcp -f SMP-RunIISummer20UL18MiniAODv2-00110.root root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nano_test/mini_$4


