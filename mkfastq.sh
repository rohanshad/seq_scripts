#!/bin/bash

# Name of your job (keep this stuff as is)
#SBATCH --job-name=mkfastq
#SBATCH --partition=owners,willhies
#SBATCH --mem=24G

# Specify the name of the output file. The %j specifies the job ID (keep this as is)
#SBATCH --output=log.%j

# The walltime you require for your job
#SBATCH --time=12:00:00

# Send an email to this address when you job starts and finishes (change to your email)
#SBATCH --mail-user=rshad@stanford.edu
#SBATCH --mail-type=end

echo "Extracting tar files..."
tar -xvf *.tar
echo "Done"
sleep 10

echo "Creating working directory structure..."

mkdir archive
mkdir rawdata
mkdir startup_generator
cp $HOME/seq_scripts/master_run.sh startup_generator/
chmod +x startup_generator/master_run.sh

mv *.tar archive/
mv Data/ rawdata/
mv InterOp/ rawdata/
mv RTAComplete.txt rawdata/
mv RTAConfiguration.xml rawdata/
mv RTALogs/ rawdata/
mv RunInfo.xml rawdata/
mv runParameters.xml rawdata/

echo "Directory structure created."

echo "Preparing mkfastq stage..."
sleep 10

# Set ulimits 
ulimit -u 10000

echo "Loading modules..."
#Load required modules
module load biology bcl2fastq

echo "Running mfkastq stage..."
# Name of the executable
cellranger mkfastq --id=mkfastq_dir \
                 --run=rawdata \
                 --csv=samples.csv \
                 --jobmode=local


echo "mkfastq created."
sleep 10

echo "Starting cellranger count so you don't have to..."
./startup_generator/master_run.sh

sleep 10