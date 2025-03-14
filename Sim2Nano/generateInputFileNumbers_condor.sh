#!/bin/bash

# Define starting and ending numbers
starting_number=5001  # Change this as needed
ending_number=7000  # Change this as needed
# ending_number=5002 # test

# Output file
output_file="input_fileNumbers_condor.txt"

# Clear the file if it exists
> "$output_file"

# Write numbers to the file
for ((i=starting_number; i<=ending_number; i++)); do
    echo "$i" >> "$output_file"
done

echo "Numbers from $starting_number to $ending_number have been saved to $output_file."
