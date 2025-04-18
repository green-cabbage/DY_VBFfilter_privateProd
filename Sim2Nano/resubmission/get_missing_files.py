import glob 


# print(out_filelist)

#----------------------------------------
load_path = "/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer"
# start_num = 12001 # hammer
# max_num = 14000 # hammer
start_num = 1 # hammer
max_num = 5000 # hammer
save_name = "missing_files_slurm.txt"
#----------------------------------------

#----------------------------------------
# load_path = "/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_lxplus"
# start_num = 5001 # lxplus
# max_num = 7000 # lxplus
# save_name = "missing_files_condor.txt"
#----------------------------------------

out_filelist = glob.glob(f"{load_path}/*.root")
missing_numberlist = []


# max_num = 10

for number in range(start_num,(max_num+1)): # starts at 1
    outfile_name = f"out_{number}.root"
    outfile_exists = any(outfile_name in file for file in out_filelist)
    if not outfile_exists:
        # missing_numberlist.append(outfile_name)
        missing_numberlist.append(str(number)) # save the number only


print(missing_numberlist)
# save the missing list in txt file for resubmission
with open(save_name, "w") as f:
    f.write("\n".join(missing_numberlist))

