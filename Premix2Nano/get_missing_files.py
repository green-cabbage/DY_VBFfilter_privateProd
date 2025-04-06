import glob 
import os
import re 


"""
This code compares outfiles in n
"""

def getFileNumbers(load_path):
    filelist = glob.glob(f"{load_path}/*.root")
    filelist = [os.path.basename(fname) for fname in filelist]
    numbers = [re.search(r"out_(\d+)\.root", f).group(1) for f in filelist if re.search(r"out_(\d+)\.root", f)]
    # print(numbers)
    return numbers


# get sim step output numbers
sim_load_path = "/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/sim_hammer"
simOut_numbers = getFileNumbers(sim_load_path)
print(f"simOut_numbers: {simOut_numbers}")


# get mini step output numbers
mini_load_path = "/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/miniV2_hammer"
miniOut_numbers = getFileNumbers(mini_load_path)
print(f"miniOut_numbers: {miniOut_numbers}")

# get missing numbers
missing_numbers = list(set(simOut_numbers) - set(miniOut_numbers))
print(f"missing_numbers: {missing_numbers}")


# # max_num = 10

# for number in range(start_num,(max_num+1)): # starts at 1
#     outfile_name = f"out_{number}.root"
#     outfile_exists = any(outfile_name in file for file in out_filelist)
#     if not outfile_exists:
#         # missing_numberlist.append(outfile_name)
#         missing_numberlist.append(str(number)) # save the number only


# # print(missing_numberlist)
# # save the missing list in txt file for resubmission
# with open(save_name, "w") as f:
#     f.write("\n".join(missing_numberlist))

