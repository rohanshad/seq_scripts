#!/bin/bash

# Name of your job (keep this stuff as is)
#SBATCH --job-name=mkfastq
#SBATCH --partition=willhies
#SBATCH --mem=20G

# Specify the name of the output file. The %j specifies the job ID (keep this as is)
#SBATCH --output=mklog.%j

# The walltime you require for your simulation
#SBATCH --time=12:00:00

# Send an email to this address when you job starts and finishes (change to your email)
#SBATCH --mail-user=rshad@stanford.edu
#SBATCH --mail-type=end



# Set ulimits 
ulimit -u 10000

#Load required modules
module load biology bcl2fastq

# Name of the executable
cellranger mkfastq --id=mkfastq_dir \
                 --run=rawdata \
                 --csv=samples.csv \
                 --jobmode=local