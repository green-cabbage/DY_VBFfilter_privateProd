#!/bin/bash

# Binds for singularity containers
# Mount /afs, /eos, /cvmfs, /etc/grid-security for xrootd
export APPTAINER_BINDPATH='/afs,/cvmfs,/cvmfs/grid.cern.ch/etc/grid-security:/etc/grid-security,/eos,/etc/pki/ca-trust,/run/user,/var/run/user'

#############################################################
#   This script is used by McM when it performs automatic   #
#  validation in HTCondor or submits requests to computing  #
#                                                           #
#      !!! THIS FILE IS NOT MEANT TO BE RUN BY YOU !!!      #
# If you want to run validation script yourself you need to #
#     get a "Get test" script which can be retrieved by     #
#  clicking a button next to one you just clicked. It will  #
# say "Get test command" when you hover your mouse over it  #
#      If you try to run this, you will have a bad time     #
#############################################################

# cd /afs/cern.ch/cms/PPD/PdmV/work/McM/submit/SMP-RunIISummer20UL16wmLHEGENAPV-00317/

# Make voms proxy
# voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 4
export X509_USER_PROXY=$(pwd)/voms_proxy.txt

# # Download fragment from McM
# curl -s -k https://cms-pdmv-prod.web.cern.ch/mcm/public/restapi/requests/get_fragment/SMP-RunIISummer20UL16wmLHEGENAPV-00317 --retry 3 --create-dirs -o Configuration/GenProduction/python/SMP-RunIISummer20UL16wmLHEGENAPV-00317-fragment.py
# [ -s Configuration/GenProduction/python/SMP-RunIISummer20UL16wmLHEGENAPV-00317-fragment.py ] || exit $?;

# Dump actual test code to a SMP-RunIISummer20UL16wmLHEGENAPV-00317_test.sh file that can be run in Singularity
cat <<'EndOfTestFile' > SMP-RunIISummer20UL16wmLHEGENAPV-00317_test.sh
#!/bin/bash

export SCRAM_ARCH=slc7_amd64_gcc700

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_6_28_patch1/src ] ; then
  echo release CMSSW_10_6_28_patch1 already exists
else
  scram p CMSSW CMSSW_10_6_28_patch1
fi
cd CMSSW_10_6_28_patch1/src
eval `scram runtime -sh`

mv ../../Configuration .
scram b
cd ../..

# Maximum validation runtime: 28800s
# Minimum validation runtime: 600s
# Output events to run for the validation job (from application's setting): 100
# Event efficiency: Computed using the request efficiency and its error.
# Event efficiency: `efficiency - (2 * efficiency_error)`: `0.102 - (2 * 0.0372)` = 0.0273
# Input events: `int(output_events / event_efficiency)`: `int(100 / 0.0273)` = 3668
# Time per event (s): Computed adding all the time_per_event values on every sequence
# Time per event (s): 2.08
# Target input events: 3668
# Target output events: 100
# This validation will be computed based on the target output events!
EVENTS=100


# cmsDriver command
# cmsDriver.py Configuration/GenProduction/python/SMP-RunIISummer20UL16wmLHEGENAPV-00317-fragment.py --eventcontent RAWSIM,LHE --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN,LHE --conditions 106X_mcRun2_asymptotic_preVFP_v8 --beamspot Realistic25ns13TeV2016Collision --step LHE,GEN --geometry DB:Extended --era Run2_2016_HIPM --python_filename SMP-RunIISummer20UL16wmLHEGENAPV-00317_1_cfg.py --fileout file:SMP-RunIISummer20UL16wmLHEGENAPV-00317.root --number 3668 --number_out 100 --no_exec --mc || exit $? ;
cmsDriver.py Configuration/GenProduction/python/SMP-RunIISummer20UL16wmLHEGENAPV-00317-fragment_4VBFFilter.py --eventcontent RAWSIM,LHE --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN,LHE --conditions 106X_mcRun2_asymptotic_preVFP_v8 --beamspot Realistic25ns13TeV2016Collision --step LHE,GEN --geometry DB:Extended --era Run2_2016_HIPM --python_filename SMP-RunIISummer20UL16wmLHEGENAPV-00317_1_cfg.py --fileout file:SMP-RunIISummer20UL16wmLHEGENAPV-00317.root --number 3668 --number_out 100 --no_exec --mc || exit $? ;

# End of SMP-RunIISummer20UL16wmLHEGENAPV-00317_test.sh file
EndOfTestFile

# Make file executable
chmod +x SMP-RunIISummer20UL16wmLHEGENAPV-00317_test.sh

if [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el7:amd64" ]; then
  CONTAINER_NAME="el7:amd64"
elif [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el7:x86_64" ]; then
  CONTAINER_NAME="el7:x86_64"
else
  echo "Could not find amd64 or x86_64 for el7"
  exit 1
fi
export SINGULARITY_CACHEDIR="/tmp/$(whoami)/singularity"
singularity run --no-home /cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/$CONTAINER_NAME $(echo $(pwd)/SMP-RunIISummer20UL16wmLHEGENAPV-00317_test.sh)
