#!/bin/bash
#SBATCH --job-name=nanoAOD_array       # Name of the job array
#SBATCH --output=/home/shar1172/CustomNanoAOD/logs_24FebChangeRedirectory_UL16/nanoAOD_%A_%a.out   # Output file for each task (%A is the job array ID, %a is the task ID)
#SBATCH --error=/home/shar1172/CustomNanoAOD/logs_24FebChangeRedirectory_UL16/nanoAOD_%A_%a.err    # Error file for each task
#SBATCH --account=cms
#SBATCH --partition=cpu
#SBATCH --qos=standby
#SBATCH --array=1-2316                    # Task array range (modify this according to your input file count): Total 10948 files
#SBATCH --ntasks=1                     # Number of tasks per job
#SBATCH --cpus-per-task=2              # Number of CPUs per task
#SBATCH --mem=3000                    # Memory per task
#SBATCH --time=03:50:00                # Max run time for each task (HH:MM:SS)
#SBATCH --get-user-env                 # Get environment variables for the job


# configFile=$(sed -n "${SLURM_ARRAY_TASK_ID}p" missing_or_corrupt_files_2016_24Feb.txt | awk '{print $1}')
# outputDirectory=$(sed -n "${SLURM_ARRAY_TASK_ID}p" missing_or_corrupt_files_2016_24Feb.txt | awk '{print $3}')
# nEvents=$(sed -n "${SLURM_ARRAY_TASK_ID}p" missing_or_corrupt_files_2016_24Feb.txt | awk '{print $4}')
outputDirectory="GenSim"

echo "Processing job ${SLURM_ARRAY_TASK_ID} "

# Run the main script
echo "sh scale_up_genSim.sh $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_ID $outputDirectory"
sh scale_up_genSim.sh $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_TASK_ID $outputDirectory