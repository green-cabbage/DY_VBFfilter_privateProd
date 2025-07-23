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

cd /afs/cern.ch/cms/PPD/PdmV/work/McM/submit/SMP-RunIISummer20UL16MiniAODv2-00103/

# Make voms proxy
# voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 4
export X509_USER_PROXY=$(pwd)/voms_proxy.txt


# Dump actual test code to a SMP-RunIISummer20UL16MiniAODv2-00103_test.sh file that can be run in Singularity
cat <<'EndOfTestFile' > SMP-RunIISummer20UL16MiniAODv2-00103_test.sh
#!/bin/bash

export SCRAM_ARCH=slc7_amd64_gcc700

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_6_25/src ] ; then
  echo release CMSSW_10_6_25 already exists
else
  scram p CMSSW CMSSW_10_6_25
fi
cd CMSSW_10_6_25/src
eval `scram runtime -sh`

mv ../../Configuration .
scram b
cd ../..

# Maximum validation runtime: 28800s
# Minimum validation runtime: 600s
# Output events to run for the validation job (from application's setting): 100
# Event efficiency: Computed using the request efficiency and its error.
# Event efficiency: `efficiency - (2 * efficiency_error)`: `1 - (2 * 0)` = 1
# Input events: `int(output_events / event_efficiency)`: `int(100 / 1)` = 100
# Time per event (s): Computed adding all the time_per_event values on every sequence
# Time per event (s): 0.621
# Initial target input events: 100
# Initial target output events: 100
# Validation runtime will not run for long enough than expected, extending the time
# Target input events changed to: `minimum_runtime / time_per_event * number_of_threads`: `600 / 0.621 * 1` = 966
# Target output events changed to: `target_input_events * event_efficiency`: `966 * 1` = 966
# Final target input events: 965
# Final target output events: 965
# This validation will be computed based on the target output events!
EVENTS=965


# cmsDriver command
cmsDriver.py  --eventcontent MINIAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier MINIAODSIM --conditions 106X_mcRun2_asymptotic_v17 --step PAT --procModifiers run2_miniAOD_UL --geometry DB:Extended --era Run2_2016 --python_filename SMP-RunIISummer20UL16MiniAODv2-00103_1_cfg.py --fileout file:SMP-RunIISummer20UL16MiniAODv2-00103.root --filein "dbs:/DYJetsToLL_LHEFilterPtZ-0To50_MatchEWPDG20_TuneCP5_13TeV-amcatnloFXFX-pythia8/RunIISummer20UL16RECO-106X_mcRun2_asymptotic_v13-v2/AODSIM" --number 965 --number_out 965 --runUnscheduled --no_exec --mc || exit $? ;

# End of SMP-RunIISummer20UL16MiniAODv2-00103_test.sh file
EndOfTestFile

# Make file executable
chmod +x SMP-RunIISummer20UL16MiniAODv2-00103_test.sh

if [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el7:amd64" ]; then
  CONTAINER_NAME="el7:amd64"
elif [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el7:x86_64" ]; then
  CONTAINER_NAME="el7:x86_64"
else
  echo "Could not find amd64 or x86_64 for el7"
  exit 1
fi
export SINGULARITY_CACHEDIR="/tmp/$(whoami)/singularity"
singularity run --no-home /cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/$CONTAINER_NAME $(echo $(pwd)/SMP-RunIISummer20UL16MiniAODv2-00103_test.sh)
