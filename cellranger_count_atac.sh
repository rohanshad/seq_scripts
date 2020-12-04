#!/bin/bash

#Job Name (change to reflect the case you're running)
#SBATCH --job-name=sample_name_here

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

#Saves current parent directory as variable
path=$((pwd) | rev | cut -d'/' -f3- | rev)

#Creates working directory within high speed L_SCRATCH + runs everything in it

mkdir $L_SCRATCH/workdir
cd $L_SCRATCH/workdir


echo "Running in L_SCRATCH"


# Name of the executable (cellranger count; channge parameters as per run case)

cellranger-atac count --id=sample_name_here \
                 --reference=$GROUP_HOME/ref_genomes/refdata-cellranger-atac-mm10-1.2.0 \
                 --fastqs=$path/mkfastq_dir \
                 --sample=sample_name_here 
                 
#L_SCRATCH wil purge everything from memory as soon as job ends, this step copies everything back to GROUP_SCRATCH

echo "Copying back to GROUP_SCRATCH"

#Eventually have 'project folder' auto populate with date

mkdir $GROUP_SCRATCH/Marfan_Mouse_atac_output/
cp -r $L_SCRATCH/workdir/sample_name_here $GROUP_SCRATCH/Marfan_Mouse_atac_output/

echo "Job copied, waiting 10s to terminate..."

sleep 10