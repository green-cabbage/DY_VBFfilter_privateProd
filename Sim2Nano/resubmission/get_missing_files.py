import glob 

load_path = "/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer"
out_filelist = glob.glob(f"{load_path}/*.root")
# print(out_filelist)

missing_numberlist = []

max_num = 5000
# max_num = 10

for number in range(1,(max_num+1)): # starts at 1
    outfile_name = f"out_{number}.root"
    outfile_exists = any(outfile_name in file for file in out_filelist)
    if not outfile_exists:
        # missing_numberlist.append(outfile_name)
        missing_numberlist.append(str(number)) # save the number only


# print(missing_numberlist)
# save the missing list in txt file for resubmission
save_name = "missing_files.txt"
with open(save_name, "w") as f:
    f.write("\n".join(missing_numberlist))

