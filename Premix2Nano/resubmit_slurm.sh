#!/bin/bash

# This script breaks down the output numbers that's missing from the input_file and 
# breaks into chunks of 10 so that sbatch could safely handle it.

input_file="missing_files_slurm.txt"   # Change this to your actual input file
script_to_run="slurm_setup.sub"  # Change this to your actual script

chunk_size=10
count=0
chunk=""

# run the missing file script for slurm. this saves the missing numbers to missing_files_slurm.txt
# python3 python3 get_missing_files.py -mode slurm 


# while IFS= read -r line; do
#     # Append line to chunk with a comma
#     if [[ -z "$chunk" ]]; then
#         chunk="$line"
#     else
#         chunk="$chunk,$line"
#     fi

#     ((count++))

#     # If 10 lines are collected, process them
#     if (( count % chunk_size == 0 )); then
#         echo "Processing: $chunk"
#         echo "sbatch --array=${chunk} $script_to_run"
#         sbatch "--array=${chunk}" $script_to_run # Pass as argument to the script
#         chunk=""  # Reset chunk
#     fi
# done < "$input_file"

# # Process any remaining lines (less than 10)
# if [[ -n "$chunk" ]]; then
#     echo "Processing: $chunk"
#     echo "sbatch --array=${chunk} $script_to_run"
#     sbatch "--array=${chunk}" $script_to_run # Pass as argument to the script
# fi


# Read each line into an array
mapfile -t numbers < ${input_file}

# Chunk size
chunk_size=10
total=${#numbers[@]}

# Loop through in chunks of 10
for (( i=0; i<$total; i+=chunk_size )); do
    chunk=("${numbers[@]:i:chunk_size}")
    joined=$(IFS=','; echo "${chunk[*]}")

    # Call your Python script with comma-separated chunk
    # python3 myscript.py "$joined"
    echo "Processing: $joined"
    echo "sbatch --array=${joined} $script_to_run"
    sbatch "--array=${joined}" $script_to_run # Pass as argument to the script
done
