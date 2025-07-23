from CRABClient.UserUtilities import config
config = config()

config.General.requestName = 'DY_VBF_Filter_Run2UL_GENSIM'
config.General.transferOutputs = True
config.General.transferLogs = True

config.JobType.pluginName = 'PrivateMC'
config.JobType.psetName = "SMP-RunIISummer20UL16wmLHEGENAPV-00317_1_cfg.py"

ncpus = 1 
config.JobType.numCores = ncpus
config.JobType.maxMemoryMB = 3000
config.Data.outputPrimaryDataset = "DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8" 
config.Data.outLFNDirBase = '/store/user/hyeonseo/Run2UL/UL2016preVFP/'
config.Data.splitting = 'EventBased'
config.JobType.maxJobRuntimeMin = 1440 #2750*2 ##this is in minutes

# new ext12 case start ----------------------------------------------
# config.General.workArea = 'crab_projects_gensim_crab_test'
# config.General.workArea = 'crab_projects_gensim_crab_1'
# config.General.workArea = 'crab_projects_gensim_crab_2'
# config.General.workArea = 'crab_projects_gensim_crab_3'
# config.General.workArea = 'crab_projects_gensim_crab_4'
# config.General.workArea = 'crab_projects_gensim_crab_5'
# config.General.workArea = 'crab_projects_gensim_crab_6'
# config.General.workArea = 'crab_projects_gensim_crab_7'
config.General.workArea = 'crab_projects_gensim_crab_8'


config.Data.outputDatasetTag = "gensim_crab_1"
# config.Data.outputDatasetTag = "gensim_test"
config.Data.unitsPerJob = 10000
NJOBS = 10000
# config.Data.unitsPerJob = 100
# NJOBS = 1
config.Data.publication = False # publishing two root files per job is disabled if publishing
# new ext12 case end ----------------------------------------------

config.Data.totalUnits = config.Data.unitsPerJob * NJOBS

config.Site.storageSite = 'T2_US_Purdue'
