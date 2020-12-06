#!/bin/bash

#Job Name (change to reflect the case you're running)
#SBATCH --job-name=aggr_atac

#Output file (this will store the log file for the job)
#SBATCH --output=log.%j

# Send an email to this address when you job starts and finishes (change to your email)
#SBATCH --mail-user=rshad@stanford.edu
#SBATCH --mail-type=end

# Time limits 
#SBATCH -t 24:00:00

# Partition info
#SBATCH --partition=owners,willhies
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --mem=180G
#SBATCH --ntasks-per-node=24

# Set ulimits higher
ulimit -u 10000

# cellranger-atac aggr run
cellranger-atac aggr --id=AGG_run \
	--csv=samples.csv \
	--normalize=depth \
	--reference=$GROUP_HOME/ref_genomes/refdata-cellranger-atac-mm10-1.2.0 \
	--nosecondary 