# seq_scripts
Scripts used for all lab bio-informatics work. 


## Resources / Prior reading


1. Cellranger wesbite and tutorials - [link](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger).
2. Great introduction of single cell sequencing - [link](https://genomemedicine.biomedcentral.com/articles/10.1186/s13073-017-0467-4)
3. Our gods and saviours at the Satija Lab, providing us with [Seurat](https://satijalab.org/seurat/), a neat R package for scRNA seq data analysis.
4. [Bioconductor](https://www.bioconductor.org) - lots of great resources for bulk sequencing packages.


   Needless to say, some proficiency in R is required for using Seurat and the packages in Bioconductor. 
   I would start with some general purpose [R tutorials](https://r4ds.had.co.nz), and quickly transition towards using ggplot2 for [visualizing your data](https://r4ds.had.co.nz/data-visualisation.html#first-steps). 
   I'll make a mini training repo for that stuff too soon, but those links are how I learnt this stuff. 

## Requirements:

1. [cellranger](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/installation) installed and configured correctly on local machine / sherlock parition.

   I've already done this for the HiesingerLab partition on sherlock. Type in `cellranger` in the terminal to see options. 
   Executable is located in `$PI_HOME/single_cell/cellranger-3.1.0`

2. bcl2fastq installed and configured correctly. This is a dependency of cellranger's mkfastq step.

   This is already configured and installed on Sherlock. Load the module by typing in `module load bcl2fastq` prior to calling the cellranger mkfastq commands. 


## Scripts in this repo

Two main scripts handle the flow of information from raw data to fastq generation, to final counting of the sequenced data.
These two scripts 'mkfastq.sh' and 'cellranger_count.sh' have comments that explain how they work.
For the 'cellranger_count.sh' script in particular, we use the fast SSDs on the ***$L_SCRATCH partition*** (using anything else will crash the program / job will never end). 

***$L_SCRATCH*** is however purged at the end of every job, therefore while we run the program there, I've ensured that data is transferred to ***$GROUP_SCRATCH*** right before the job ends. 

There is a 'master_run.sh' script here too that allows for you to run as many cellranger jobs in parallel as you want with a single command, resources permitting.
Very useful when running large batches of sequencing data, ensuring everything is arranged in the right folders for downstream processing with R. 

For a quick tutorial on how this works, I would refer to Dave Tang's [blog](https://davetang.org/muse/2018/08/09/getting-started-with-cell-ranger/), really well written tutorial for using cellranger.
Will add R scripts here later.


## General Instructions

1. The sequencing facilty provides data in the form of DNANexus links that will point to three 'tar' compressed files. 
   Navigate into the directory you will use to run the job and download the folders via `wget <insert link here>`. Read up on how wget works, or hit `wget -h` for help + options text. 

2. Untar the files using the command `tar -xvf <name of .tar file here>`. 
	Some of the files are large and I suggest logging into one of our nodes with `sdev -p willhies -m 8G -t 2:00:00`, before using the `tar -xvf` command. 
	This  ill request 2 hours of time on one of our servers with 8 GB of RAM available for use - more than enough to overcome the limits on the standard sherlock login nodes.

3. A csv file containing the sample indices will be provided. 
   Ensure that the [format](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/mkfastq_) is correct.

4. The un-compressed files can now be used to run the cellranger pipeline. 
   It's however important that the files are placed correctly in a specfic set of subfolders to run. In the scripts provided for example, the structure of the directory must look something like this: 

   Note: I put in all the downloaded .tar files in an 'archive' folder to keep things clean. I reccomend arranging your folders as shown ***after*** you've 'untarred' all the downloaded .tar files. 

   ```
   
   ├── archive
   │   ├── 191211_COOPER_0301_AH7NFWBBXY.InterOp.tar
   │   ├── 191211_COOPER_0301_AH7NFWBBXY_L5.tar
   │   └── 191211_COOPER_0301_AH7NFWBBXY.metadata.tar
   ├── Config
   │   ├── h7nfwbbxy_2019-12-11\ 12-29-47_Effective.cfg
   │   ├── h7nfwbbxy_2019-12-11\ 12-29-47_Override.cfg
   │   ├── h7nfwbbxy_2019-12-11\ 12-29-48_SortedOverride.cfg
   │   ├── HiSeqControlSoftware.Options.cfg
   │   ├── RTAStart.log
   │   └── Variability_HiSeq_E.bin
   ├── rawdata
   │   ├── Data
   │   ├── InterOp
   │   ├── RTAComplete.txt
   │   ├── RTAConfiguration.xml
   │   ├── RTALogs
   │   ├── RunInfo.xml
   │   └── runParameters.xml
   ├── Recipe
   │   └── H7NFWBBXY.xml
   ├── samples.csv
   ```

5. Generate the mkfastq files using the 'mkfastq.sh' script, and then use 'cellranger_count.sh' to generate your aligned reads. 
   Note: I usually name this 'submit.sh' and place in multiple folders for large batches, and use the 'master_run.sh' script to trigger all to run at the same time.
   Ask me how this works in person, too tired to explain here. 


