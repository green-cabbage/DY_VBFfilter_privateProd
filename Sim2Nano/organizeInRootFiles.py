import glob
import os
from itertools import islice

"""
This code is specifically made for genSim outputs from crab submissions, from the genSim stage.
SLURM and Condor jobs are different
"""
def chunk_list_iter(lst, size=5):
    return [list(islice(lst, i, i + size)) for i in range(0, len(lst), size)]


def getCrabGensimFiledict(base_path: str, dates: list, chunksize=500) -> dict:
    """
    return: a filedict with output name as key and list of input root files as value
    """
    total_file_dict = {}
    for date in dates:
        date_out_dict = {}
        dir_path = f"{base_path}/{date}/*/*.root"
        # print(f"dir_path: {dir_path}")
        filelist = glob.glob(dir_path)
        # Filter out strings that contain "inLHE"
        filelist = [s for s in filelist if "inLHE" not in s]
        # remove /eos/purdue
        filelist = [s.replace("/eos/purdue","") for s in filelist]
        # print(f"len(filelist): {len(filelist)}")

        # break the list into smaller list with each size of the given chunksize
        chunks = chunk_list_iter(filelist, size=chunksize)
        for ix in range(len(chunks)):
            chunk_input_rootfiles = chunks[ix]
            unique_output_fname = f"input_fnames/{date}/out_{date}_{ix}.txt"
            date_out_dict[unique_output_fname] = chunk_input_rootfiles
            # print(f"len(chunk_input_rootfiles): {len(chunk_input_rootfiles)}")
        print(f"date_out_dict.keys(): {date_out_dict.keys()}")
        total_file_dict[date] = date_out_dict

    return total_file_dict


base_path = "/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/gensim_crab_1"

dates = [
    "250307_134706", 
    "250308_023802",
]
chunksize = 500
file_dict = getCrabGensimFiledict(base_path, dates, chunksize=chunksize)
# print(len(file_dict))
# print(file_dict.keys())
# print(file_dict)
for date_file_dict in file_dict.values():
    for outfile_name, input_root_files in date_file_dict.items():
        print(f"outfile_name: {outfile_name}")
        directory = os.path.dirname(outfile_name)
        print(f"directory: {directory}")
        os.makedirs(directory, exist_ok=True) 
        with open(outfile_name, "w") as f:
            f.write(", ".join(input_root_files))


# divide the filelist into chunksizes

