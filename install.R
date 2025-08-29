#!/usr/bin/env Rscript
#
# install.R: Install a list of R libraries from a file
#
# Prep input with:
#   cd {R_library_repository}
#   ls -l | tr -s ' ' | cut -d ' ' -f 9 > R.libraries
#
# Run with:
#   Rscript install.R {manifest} {path}
#

library(readr)

args = commandArgs(trailingOnly=TRUE)

if (length(args) != 2) {
    stop("Usage: Rscript install.R {manifest} {path}", call.=FALSE)
}

manifest <- args[1]
path <- args[2]

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version = "3.21")

offset <- 0

while (TRUE) {
    line = read_lines(manifest, skip = offset, n_max = 1)
    if (length(line) == 0) {
        break
    }

    BiocManager::install(line,lib=path,force=TRUE)

    offset <- offset + 1
}
