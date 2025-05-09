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

# cd /afs/cern.ch/cms/PPD/PdmV/work/McM/submit/HIG-RunIIFall18wmLHEGS-00419/

# Make voms proxy
# voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 4
export X509_USER_PROXY=$(pwd)/voms_proxy.txt

# Download fragment from McM
curl -s -k https://cms-pdmv-prod.web.cern.ch/mcm/public/restapi/requests/get_fragment/HIG-RunIIFall18wmLHEGS-00419 --retry 3 --create-dirs -o Configuration/GenProduction/python/HIG-RunIIFall18wmLHEGS-00419-fragment.py
[ -s Configuration/GenProduction/python/HIG-RunIIFall18wmLHEGS-00419-fragment.py ] || exit $?;

# Dump actual test code to a HIG-RunIIFall18wmLHEGS-00419_test.sh file that can be run in Singularity
cat <<'EndOfTestFile' > HIG-RunIIFall18wmLHEGS-00419_test.sh
#!/bin/bash

export SCRAM_ARCH=slc6_amd64_gcc700

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_2_6/src ] ; then
  echo release CMSSW_10_2_6 already exists
else
  scram p CMSSW CMSSW_10_2_6
fi
cd CMSSW_10_2_6/src
eval `scram runtime -sh`

mv ../../Configuration .
scram b
cd ../..

# Maximum validation runtime: 28800s
# Minimum validation runtime: 600s
# Output events to run for the validation job (from application's setting): 100
# Event efficiency: Computed using the request efficiency and its error.
# Event efficiency: `efficiency - (2 * efficiency_error)`: `0.0184 - (2 * 0.008)` = 0.0024
# Input events: `int(output_events / event_efficiency)`: `int(100 / 0.0024)` = 41666
# Time per event (s): Computed adding all the time_per_event values on every sequence
# Time per event (s): 3.75
# Initial target input events: 41666
# Initial target output events: 100
# Validation runtime out of limits, truncating the time
# Target input events changed to: `maximum_runtime / time_per_event * number_of_threads`: `2.88e+04 / 3.75 * 1` = 7.67e+03
# Target output events change to: `target_input_events * event_efficiency`: `7.67e+03 * 0.0024` = 18.4
# Final target input events: 7674
# Final target output events: 18
# This validation will be computed based on the target output events!
EVENTS=18

# Random seed between 1 and 100 for externalLHEProducer
SEED=$(($(date +%s) % 100 + 1))


# cmsDriver command
cmsDriver.py Configuration/GenProduction/python/HIG-RunIIFall18wmLHEGS-00419-fragment.py --eventcontent RAWSIM,LHE --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM,LHE --conditions 102X_upgrade2018_realistic_v11 --beamspot Realistic25ns13TeVEarly2018Collision --customise_commands process.RandomNumberGeneratorService.externalLHEProducer.initialSeed="int(${SEED})" --step LHE,GEN,SIM --geometry DB:Extended --era Run2_2018 --python_filename HIG-RunIIFall18wmLHEGS-00419_1_cfg.py --fileout file:HIG-RunIIFall18wmLHEGS-00419.root --number 7674 --number_out 18 --no_exec --mc || exit $? ;

# End of HIG-RunIIFall18wmLHEGS-00419_test.sh file
EndOfTestFile

# Make file executable
chmod +x HIG-RunIIFall18wmLHEGS-00419_test.sh

if [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/slc6:amd64" ]; then
  CONTAINER_NAME="slc6:amd64"
elif [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/slc6:x86_64" ]; then
  CONTAINER_NAME="slc6:x86_64"
else
  echo "Could not find amd64 or x86_64 for slc6"
  exit 1
fi
export SINGULARITY_CACHEDIR="/tmp/$(whoami)/singularity"
singularity run --no-home /cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/$CONTAINER_NAME $(echo $(pwd)/HIG-RunIIFall18wmLHEGS-00419_test.sh)