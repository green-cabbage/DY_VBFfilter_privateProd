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

# cd /afs/cern.ch/cms/PPD/PdmV/work/McM/submit/SMP-RunIISummer20UL17wmLHEGEN-00320/

# Make voms proxy
voms-proxy-init --voms cms --out $(pwd)/voms_proxy.txt --hours 4
export X509_USER_PROXY=$(pwd)/voms_proxy.txt

# We assume fragment.py file was made and uploaded

# Dump actual test code to a SMP-RunIISummer20UL17wmLHEGEN-00320_test.sh file that can be run in Singularity
cat <<'EndOfTestFile' > SMP-RunIISummer20UL17wmLHEGEN-00320_test.sh
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

# Maximum validation duration: 28800s
# Margin for validation duration: 30%
# Validation duration with margin: 28800 * (1 - 0.30) = 20160s
# Time per event for each sequence: 4.0000s
# Threads for each sequence: 1
# Time per event for single thread for each sequence: 1 * 4.0000s = 4.0000s
# Which adds up to 4.0000s per event
# Single core events that fit in validation duration: 20160s / 4.0000s = 5040
# Produced events limit in McM is 10000
# According to 0.1016 efficiency, validation should run 10000 / 0.1016 = 98425 events to reach the limit of 10000
# Take the minimum of 5040 and 98425, but more than 0 -> 5040
# It is estimated that this validation will produce: 5040 * 0.1016 = 512 events
EVENTS=5040


# cmsDriver command
cmsDriver.py Configuration/GenProduction/python/SMP-RunIISummer20UL17wmLHEGEN-00320-fragment_4VBFFilter.py --eventcontent RAWSIM,LHE --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN,LHE --conditions 106X_mc2017_realistic_v6 --beamspot Realistic25ns13TeVEarly2017Collision --step LHE,GEN --geometry DB:Extended --era Run2_2017 --python_filename SMP-RunIISummer20UL17wmLHEGEN-00320_1_cfg.py --fileout file:SMP-RunIISummer20UL17wmLHEGEN-00320.root --no_exec --mc -n $EVENTS || exit $? ;

# End of SMP-RunIISummer20UL17wmLHEGEN-00320_test.sh file
EndOfTestFile

# Make file executable
chmod +x SMP-RunIISummer20UL17wmLHEGEN-00320_test.sh

if [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el7:amd64" ]; then
  CONTAINER_NAME="el7:amd64"
elif [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el7:x86_64" ]; then
  CONTAINER_NAME="el7:x86_64"
else
  echo "Could not find amd64 or x86_64 for el7"
  exit 1
fi
export SINGULARITY_CACHEDIR="/tmp/$(whoami)/singularity"
singularity run --no-home /cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/$CONTAINER_NAME $(echo $(pwd)/SMP-RunIISummer20UL17wmLHEGEN-00320_test.sh)