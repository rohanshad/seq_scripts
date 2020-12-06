#!/bin/bash

# This the command we will run on each submit script that is found
run_command="sbatch"

# Record the original path
original_pwd=$(pwd)

# Will find and run all scripts titled 'submit.sh', helps when submitting jobs in different directories at once
# Rember part is important to modify if you're looking to run things from subfolders!!!
script_list=$(ls */submit.sh)

# Loop through each script in the submission list
for script in ${script_list}; do
    # Get the directory and filename parts of the path.
    script_dir=$(dirname "${script}")
    script_name=$(basename "${script}")

    # Change into the directory where the script is
    cd "${script_dir}"

    # Run the submit program, providing the script path.
    # NOTE: The run command is intentionally not quoted.  If we quoted the
    # run command, then any additional programs would not be processed.
    echo "In ${script_dir}: Running ${run_command} ${script_name}"
    ${run_command} "${script_name}"

    # Did the run command work?
    if [ $? -ne 0 ]; then
        echo "ERROR running the submit command!"
        exit 1
    fi

    # Change back up to the original path
    cd "${original_pwd}"

done