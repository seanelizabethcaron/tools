#!/usr/bin/env Rscript
#
# install.R: Install a list of R libraries from a file
#
# Prep input with:
#   cd {R_library_repository}
#   ls -l | tr -s ' ' | cut -d ' ' -f 9 > R.libraries
#
# Setup:
#   If this is for a personal repository in a home directory, set R_LIBS_USER
#   Otherwise leave R_LIBS_USER unset
#
# Run with:
#   Rscript install.R {manifest}
#

library(readr)

args = commandArgs(trailingOnly=TRUE)

if (length(args) != 1) {
    stop("Usage: Rscript install.R {manifest}", call.=FALSE)
}

manifest <- args[1]

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version = "3.21")

offset <- 0

while (TRUE) {
    line = read_lines(manifest, skip = offset, n_max = 1)
    if (length(line) == 0) {
        break
    }

    BiocManager::install(line,force=TRUE)

    offset <- offset + 1
}
