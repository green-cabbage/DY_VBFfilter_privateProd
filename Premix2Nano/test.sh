#!/bin/bash

input_file="missing_files_slurm.txt"
mapfile -t numbers < ${input_file}

# Read each line into an array
# mapfile -t numbers < missing_files_slurm.txt

# Chunk size
chunk_size=10
total=${#numbers[@]}

# Loop through in chunks of 10
for (( i=0; i<$total; i+=chunk_size )); do
    chunk=("${numbers[@]:i:chunk_size}")
    joined=$(IFS=','; echo "${chunk[*]}")

    # Call your Python script with comma-separated chunk
    # python3 myscript.py "$joined"
    echo "$joined"
done
