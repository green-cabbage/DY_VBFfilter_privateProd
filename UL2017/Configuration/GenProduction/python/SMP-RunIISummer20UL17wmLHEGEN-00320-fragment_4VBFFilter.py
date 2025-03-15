import FWCore.ParameterSet.Config as cms

externalLHEProducer = cms.EDProducer("ExternalLHEProducer",
    args = cms.vstring('/cvmfs/cms.cern.ch/phys_generator/gridpacks/2017/13TeV/madgraph/V5_2.4.2/dymumu012j_5f_NLO_FXFX_M105to160/v1/dymumu012j_5f_NLO_FXFX_M105to160_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz'),
    nEvents = cms.untracked.uint32(5000),
    numberOfParameters = cms.uint32(1),
    outputFile = cms.string('cmsgrid_final.lhe'),
    scriptName = cms.FileInPath('GeneratorInterface/LHEInterface/data/run_generic_tarball_cvmfs.sh'),
    generateConcurrently = cms.untracked.bool(True)
)

import FWCore.ParameterSet.Config as cms

from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.MCTunes2017.PythiaCP5Settings_cfi import *
from Configuration.Generator.PSweightsPythia.PythiaPSweightsSettings_cfi import *
from Configuration.Generator.Pythia8aMCatNLOSettings_cfi import *

generator = cms.EDFilter("Pythia8ConcurrentHadronizerFilter",
                         maxEventsToPrint = cms.untracked.int32(1),
                         pythiaPylistVerbosity = cms.untracked.int32(1),
                         pythiaHepMCVerbosity = cms.untracked.bool(False),
                         comEnergy = cms.double(13000.),
                         PythiaParameters = cms.PSet(
        pythia8CommonSettingsBlock,
        pythia8CP5SettingsBlock,
        pythia8PSweightsSettingsBlock,
        pythia8aMCatNLOSettingsBlock,
        processParameters = cms.vstring(
            'JetMatching:setMad = off',
            'JetMatching:scheme = 1',
            'JetMatching:merge = on',
            'JetMatching:jetAlgorithm = 2',
            'JetMatching:etaJetMax = 999.',
            'JetMatching:coneRadius = 1.',
            'JetMatching:slowJetPower = 1',
            'JetMatching:qCut = 30.', #this is the actual merging scale
            'JetMatching:doFxFx = on',
            'JetMatching:qCutME = 10.',#this must match the ptj cut in the lhe generation step
            'JetMatching:nQmatch = 5', #4 corresponds to 4-flavour scheme (no matching of b-quarks), 5 for 5-flavour scheme
            'JetMatching:nJetMax = 2', #number of partons in born matrix element for highest multiplicity
            'TimeShower:mMaxGamma = 4.0',
        ),
        parameterSets = cms.vstring('pythia8CommonSettings',
                                    'pythia8CP5Settings',
                                    'pythia8PSweightsSettings',
                                    'pythia8aMCatNLOSettings',
                                    'processParameters',
                                    )
        )
)


vbfGenJetFilterD = cms.EDFilter("VBFGenJetFilter",

  inputTag_GenJetCollection = cms.untracked.InputTag('ak4GenJetsNoNu'),

  leadJetsNoLepMass         = cms.untracked.bool  (    True),  # Require the cut on the mass of the leading jets
  minPt                     = cms.untracked.double(       0), # Minimum dijet jet_pt
  minEta                    = cms.untracked.double(-99999.0), # Minimum dijet jet_eta
  maxEta                    = cms.untracked.double( 99999.0), # Maximum dijet jet_eta
  minLeadingJetsInvMass     = cms.untracked.double(   350.0), # Minimum dijet invariant mass
  deltaRNoLep               = cms.untracked.double(     0.3), # Maximum dijet invariant mass

)

# Getting necessary generator jet filters
from PhysicsTools.HepMCCandAlgos.genParticles_cfi import genParticles
from RecoJets.Configuration.GenJetParticles_cff import genParticlesForJetsNoNu
from RecoJets.Configuration.RecoGenJets_cff import ak4GenJetsNoNu

ProductionFilterSequence = cms.Sequence(
  generator*
  cms.SequencePlaceholder("pgen")*
  genParticlesForJetsNoNu*
  ak4GenJetsNoNu*
  vbfGenJetFilterD
)

SimFilterSequence = cms.Sequence(
  generator*
  genParticlesForJetsNoNu*
  ak4GenJetsNoNu*
  vbfGenJetFilterD*
  cms.SequencePlaceholder("psim")
)

