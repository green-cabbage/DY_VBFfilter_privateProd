#!/bin/bash

# Define starting and ending numbers
# starting_number=7001  # Change this as needed
# ending_number=10000  # Change this as needed
# ending_number=7002 # test

starting_number=7001  # Change this as needed
ending_number=10000  # Change this as needed

# Output file
output_file="input_fileNumbers_condor.txt"

# Clear the file if it exists
> "$output_file"

# Write numbers to the file
for ((i=starting_number; i<=ending_number; i++)); do
    echo "$i" >> "$output_file"
done

echo "Numbers from $starting_number to $ending_number have been saved to $output_file."
