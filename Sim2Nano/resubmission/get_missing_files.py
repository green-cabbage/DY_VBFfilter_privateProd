import glob 


# print(out_filelist)
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

    if mode.lower() == "slurm":
        #----------------------------------------
        load_path = "/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_hammer"
        # load_path = "/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/sim_hammer"
        start_num = 12001 # hammer
        max_num = 14001 # hammer
        # start_num = 14001 # hammer
        # max_num = 15999 # hammer
        save_name = "missing_files_slurm.txt"
        #----------------------------------------

    elif mode.lower() == "condor":
        # ----------------------------------------
        # load_path = "/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/nanoV12_lxplus"
        load_path = "/eos/purdue/store/user/hyeonseo/Run2UL/UL2018/DYJetsToLL_M-105To160_VBFFilter_TuneCP5_PSweights_13TeV-amcatnloFXFX-pythia8/miniV2_lxplus"
        start_num = 5001 # lxplus
        max_num = 10000 # lxplus
        save_name = "missing_files_condor.txt"
        # ----------------------------------------

    out_filelist = glob.glob(f"{load_path}/*.root")
    missing_numberlist = []


    # max_num = 10

    for number in range(start_num,(max_num+1)): # starts at 1
        if mode.lower() == "slurm":
            outfile_name = f"out_{number}.root"
        elif mode.lower() == "condor":
            outfile_name = f"mini_out_{number}.root"
        # outfile_name = f"sim_out_{number}.root"
        outfile_exists = any(outfile_name in file for file in out_filelist)
        if not outfile_exists:
            # missing_numberlist.append(outfile_name)
            missing_numberlist.append(str(number)) # save the number only


    print(missing_numberlist)
    # save the missing list in txt file for resubmission
    with open(save_name, "w") as f:
        f.write("\n".join(missing_numberlist))

