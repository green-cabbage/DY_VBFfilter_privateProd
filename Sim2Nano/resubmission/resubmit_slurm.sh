#!/bin/bash

# missing files, overrides the array
file="missing_files.txt"
missing_fnames=""

while IFS= read -r line; do
    if [[ -n "$missing_fnames" ]]; then
        missing_fnames+=","
    fi
    missing_fnames+="$line"
done < "$file"

# echo "$missing_fnames"

echo "sbatch ../slurm_setup.sub --array=${missing_fnames}"
sbatch ../slurm_setup.sub --array=${missing_fnames}