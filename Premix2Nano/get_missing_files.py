import glob 
import os
import re 
import argparse
import uproot
import concurrent.futures

"""
This code compares outfiles in n
"""






def getBadFile(fname):
    try:
        up_file = uproot.open(fname) 
        # up_file["Events"]["Muon_pt"].array() # check that you could read branches
        if len(up_file.keys()) > 0:
            return "" # good file
        else:
            return fname # bad file
    except Exception as e:
        # return f"An error occurred with file {fname}: {e}"
        return fname # bad fileclient

def getBadFileParallelize(filelist, max_workers=20):
    # print(filelist)
    with concurrent.futures.ProcessPoolExecutor(max_workers=max_workers) as executor:
        # Submit each file check to the executor
        results = list(executor.map(getBadFile, filelist))
    # print(f"results: {results}")
    bad_file_l = []
    for result in results:
        if result != "":
            # print(result)
            bad_file_l.append(result)
    print(f"bad_file_l: {bad_file_l}")
    # raise ValueError
    return bad_file_l

# def getBadFileParallelizeDask(filelist):
#     """
#     We assume that the dask client has already been initialized
#     """
#     lazy_results = []
#     for fname in filelist:
#         lazy_result = dask.delayed(getBadFile)(fname)
#         lazy_results.append(lazy_result)
#     results = dask.compute(*lazy_results)

#     bad_file_l = []
#     for result in results:
#         if result != "":
#             # print(result)
#             bad_file_l.append(result)
#     return bad_file_l


def removeBadFiles(filelist):
    bad_filelist = getBadFileParallelize(filelist)
    clean_filelist = list(set(filelist) - set(bad_filelist))
    return clean_filelist


def getFileNumbers(load_path):
    filelist = glob.glob(f"{load_path}/*.root")
    filelist = removeBadFiles(filelist) # remove bad file numbers
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
    args = parser.parse_args()
    mode = args.mode
    if (mode != "slurm" ) and (mode != "condor" ):
        print("ERROR! invalid mode given")
        raise ValueError
    save_path_name = "hammer" if (mode == "slurm") else "lxplus"


    # get sim step output numbers
    sim_load_path = f"/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/sim_{save_path_name}"
    simOut_numbers = getFileNumbers(sim_load_path)
    # print(f"simOut_numbers: {simOut_numbers}")


    # get mini step output numbers
    mini_load_path = f"/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/miniV2_{save_path_name}"
    miniOut_numbers = getFileNumbers(mini_load_path)
    # print(f"miniOut_numbers: {miniOut_numbers}")

    # get missing numbers
    missing_numbers = list(set(simOut_numbers) - set(miniOut_numbers))
    print(f"missing_numbers: {missing_numbers}")

    save_name = f"missing_files_{mode}.txt"

    with open(save_name, "w") as f:
        f.write("\n".join(missing_numbers))