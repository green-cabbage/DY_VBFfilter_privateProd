
export SCRAM_ARCH=el8_amd64_gcc11

source /cvmfs/cms.cern.ch/cmsset_default.sh

# Setting up CMSSW versions and configuration files
step7=CMSSW_13_0_14
step7_cfg=PPD-Run3Summer23NanoAODv12-00008_1_cfg.py

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
echo "xrdcp -f SMP-RunIISummer20UL18NanoAODv12-00008.root root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer/$3"
xrdcp -f SMP-RunIISummer20UL18NanoAODv12-00008.root root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer/$3
# xrdcp -f SMP-RunIISummer20UL18NanoAODv12-00008.root root://eos.cms.rcac.purdue.edu//store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nano_test/$3


cd ..
echo "Current directory: $(pwd)"
echo "removing directory: rm -r ${cmssw_dir}"
rm -r ${cmssw_dir}
echo "Job finished on " $(date)


