#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <archive_file> <output_directory>"
    exit 1
fi

echo "Contents of the first input file ($1):"

Rscript prediction.R $1 $2 
