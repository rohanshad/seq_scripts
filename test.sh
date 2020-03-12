#!/bin/bash

mkdir startup_generator

sed 1d samples.csv | while IFS=, read -r lane sample index
do
       echo "Sample ID: $sample, $(pwd)"
       #mkdir startup_generator/$sample

done
