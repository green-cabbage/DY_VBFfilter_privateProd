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
    total_filelilst = []
    for date in dates:
        date_out_dict = {}
        dir_path = f"{base_path}/{date}/*/*.root"
        # print(f"dir_path: {dir_path}")
        filelist = glob.glob(dir_path)
        # Filter out strings that contain "inLHE"
        filelist = [s for s in filelist if "inLHE" not in s]
        # remove /eos/purdue
        filelist = [s.replace("/eos/purdue","root://eos.cms.rcac.purdue.edu/") for s in filelist]
        # print(f"len(filelist): {len(filelist)}")
        total_filelilst += filelist
    total_file_dict = {}
    # break the list into smaller list with each size of the given chunksize
    chunks = chunk_list_iter(total_filelilst, size=chunksize)
    for ix in range(len(chunks)):
        chunk_input_rootfiles = chunks[ix]
        unique_output_fname = f"input_fnames/inputFnames/out_{ix+1}.txt" # index start at 1
        date_out_dict[unique_output_fname] = chunk_input_rootfiles
        # print(f"len(chunk_input_rootfiles): {len(chunk_input_rootfiles)}")
    # print(f"date_out_dict.keys(): {date_out_dict.keys()}")
    total_file_dict["gensimRootFiles"] = date_out_dict
    return total_file_dict

yearUL="UL2017"
base_path = f"/eos/purdue/store/user/hyeonseo/Run2UL/{yearUL}/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/gensim_crab_1"

dates = [ # order of which the jobs succeeded with 100% completion
    "250316_220541", # SLURM out_1 to out_973
    "250316_231734", # SLURM out_974 to out_1955
    "250317_012352", # SLURM out_1956 to out_2941
    "250317_022751", # SLURM out_2942 to out_out_3929
    "250317_124704", # SLURM out_3930 to out_out_4920
    "250317_173737", # SLURM out_4921 to out_5918
    "250317_174401", # SLURM out_5919 to out_6914
    "250317_175653", # SLURM out_6915 to out_7911
    "250417_181016", # SLURM out_7912 to out_8911
]

# TODO: make a dictionary of certain crab runs that's stuck and give the maximum length

chunksize = 10 
file_dict = getCrabGensimFiledict(base_path, dates, chunksize=chunksize)
# print(len(file_dict))
# print(file_dict.keys())
# print(file_dict)

# # for SLURM
# for date_file_dict in file_dict.values():
#     for outfile_name, input_root_files in date_file_dict.items():
#         # print(f"outfile_name: {outfile_name}")
#         directory = os.path.dirname(outfile_name)
#         # print(f"directory: {directory}")
#         os.makedirs(directory, exist_ok=True) 
#         with open(outfile_name, "w") as f:
#             f.write("\n".join(input_root_files))

# for condor
import pickle
import re



# Sample dictionary
dict2save = {}

for date_file_dict in file_dict.values():
    for outfile_name, input_root_files in date_file_dict.items():
        # Extract the number after "out_" and before ".txt"
        match = re.search(r'out_(\d+)\.txt$', outfile_name)
        number = match.group(1)
        # print(f"outfile_name: {outfile_name}")
        # print(f"number: {number}")
        dict2save[number] = input_root_files

# print(f"dict2save: {dict2save}")

import json
with open("input_dict.json", "w") as fout:
    json.dump(dict2save, fout)
