import glob 
import argparse
import concurrent.futures
import os
import re 
import uproot

yearUL="UL2016postVFP"

def getBadFile(fname):
    try:
        up_file = uproot.open(fname) 
        # up_file["Events"]["Muon_pt"].array() # check that you could read branches
        if len(up_file.keys()) > 0:
            return "" # good file
        else:
            return fname # bad file
    except Exception as e:
        print( f"An error occurred with file {fname}: {e}")
        return fname # bad fileclient

def getBadFileParallelize(filelist, max_workers=120):
    with concurrent.futures.ProcessPoolExecutor(max_workers=max_workers) as executor:
        # Submit each file check to the executor
        results = list(executor.map(getBadFile, filelist))
    # print(f"results: {results}")
    bad_file_l = []
    for result in results:
        if result != "":
            # print(result)
            bad_file_l.append(result)
    print(f"bad_file_l: {len(bad_file_l)}")
    # print(f"bad_file_l: {(bad_file_l)}")
    # raise ValueError
    return bad_file_l

def getBadFiles(filelist):
    bad_filelist = getBadFileParallelize(filelist)
    print(f"bad_filelist: {len(bad_filelist)}")

    return bad_filelist


def getFileNumbers(load_path):
    filelist = glob.glob(f"{load_path}/*.root")
    filelist = getBadFiles(filelist) # remove bad file numbers
    filelist = [os.path.basename(fname) for fname in filelist] # just extract the filenames
    numbers = [re.search(r"out_(\d+)\.root", f).group(1) for f in filelist if re.search(r"out_(\d+)\.root", f)]
    # print(numbers)
    return numbers

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
    "-mode",
    "--mode",
    dest="mode",
    default=None,
    action="store",
    help="mode: 'slurm' or 'condor'",
    )
    parser.add_argument(
    "--remove_bad_nano",
    dest="remove_bad_nano",
    default=False, 
    action=argparse.BooleanOptionalAction,
    help="If true, also pick out bad nano files and add to resubmission list",
    )
    args = parser.parse_args()
    mode = args.mode
    if (mode != "slurm" ) and (mode != "condor" ):
        print("ERROR! invalid mode given")
        raise ValueError

    if mode.lower() == "slurm":
        #----------------------------------------
        load_path = f"/eos/purdue/store/user/hyeonseo/Run2UL/{yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer"
        # load_path = f"/eos/purdue/store/user/hyeonseo/Run2UL/{yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/sim_hammer"
        start_num = 1 # hammer
        max_num = 7000 # hammer
        save_name = "missing_files_slurm.txt"
        nano_load_path = f"/eos/purdue/store/user/hyeonseo/Run2UL/UL2017/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer"

        #----------------------------------------

    elif mode.lower() == "condor":
        # ----------------------------------------
        load_path = f"/eos/purdue/store/user/hyeonseo/Run2UL/{yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_lxplus"
        # load_path = f"/eos/purdue/store/user/hyeonseo/Run2UL/{yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/miniV2_lxplus"
        start_num = 5001 # lxplus
        max_num = 10000 # lxplus
        save_name = "missing_files_condor.txt"
        nano_load_path = f"/eos/purdue/store/user/hyeonseo/Run2UL/UL2017/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_lxplus"
        # ----------------------------------------

    out_filelist = glob.glob(f"{load_path}/*.root")
    missing_numberlist = []


    # max_num = 10

    for number in range(start_num,(max_num+1)): # starts at 1
        if mode.lower() == "slurm":
            outfile_name = f"out_{number}.root"
        elif mode.lower() == "condor":
            # outfile_name = f"mini_out_{number}.root"
            outfile_name = f"out_{number}.root"
        # outfile_name = f"sim_out_{number}.root"
        outfile_exists = any(outfile_name in file for file in out_filelist)
        if not outfile_exists:
            # missing_numberlist.append(outfile_name)
            missing_numberlist.append(str(number)) # save the number only


    print(f"missing_numberlist: {missing_numberlist}")

    if args.remove_bad_nano:
        # get nano step output numbers
        bad_nanoOut_numbers = getFileNumbers(nano_load_path)
        # print(f"nano_load_path: {nano_load_path}")
        print(f"bad_nanoOut_numbers: {bad_nanoOut_numbers}")
        missing_numberlist = missing_numberlist + bad_nanoOut_numbers


    # save the missing list in txt file for resubmission
    with open(save_name, "w") as f:
        f.write("\n".join(missing_numberlist))

