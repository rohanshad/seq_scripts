#!/bin/bash

#Job Name (change to reflect the case you're running)
#SBATCH --job-name=sample_id

#Output file (this will store the log file for the job)
#SBATCH --output=log.%j

# Send an email to this address when you job starts and finishes (change to your email)
#SBATCH --mail-user=rshad@stanford.edu
#SBATCH --mail-type=end

# Time limits 
#SBATCH -t 48:00:00

# Partition info
#SBATCH --partition=owners,willhies
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --mem=180G
#SBATCH --ntasks-per-node=24

# Set ulimits higher

ulimit -u 10000

#Creates working directory within high speed L_SCRATCH + runs everything in it

mkdir $L_SCRATCH/workdir
cd $L_SCRATCH/workdir


echo "Running in L_SCRATCH"

# Name of the executable (cellranger count; channge parameters as per run case)

cellranger count --id=sample_id \
                 --transcriptome=$GROUP_HOME/single_cell/refdata-cellranger-mm10-3.0.0 \
                 --fastqs=$(pwd)/mkfastq_dir/outs/fastq_path \
                 --sample=sample_id \
                 --expect-cells=10000 \
                 
#L_SCRATCH wil purge everything from memory as soon as job ends, this step copies everything back to GROUP_SCRATCH

echo "Copying back to GROUP_SCRATCH"

#Eventually have 'project folder' auto populate with date

mkdir $GROUP_SCRATCH/Marfan_Mouse_output/projectfolder
cp -r $L_SCRATCH/workdir/sample_id $GROUP_SCRATCH/Marfan_Mouse_output/projectfolder

echo "Job copied, waiting 10s to terminate..."

sleep 10