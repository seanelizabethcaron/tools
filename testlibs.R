#!/usr/bin/env Rscript
#
# testlibs.R: Test loadability of a list of R modules from a file
#
# We do this by literally loading then unloading each library in sequence
# If a library fails to load, the script will abend and we can correct the
# problem based on the error output
#
# Prep input with:
#   cd {R_library_repository}
#   ls -l | tr -s ' ' | cut -d ' ' -f 9 > R.libraries
#
# Run with:
#   Rscript testlibs.R {manifest}
#

library(readr)

args = commandArgs(trailingOnly=TRUE)

if (length(args) != 1) {
    stop("Usage: Rscript testlibs.R {manifest}", call.=FALSE)
}

manifest <- args[1]

offset <- 0

while (TRUE) {
    line = read_lines(manifest, skip = offset, n_max = 1)
    if (length(line) == 0) {
        break
    }

    library(line, character.only = TRUE)

    line_2 = paste("package:", line, sep="")

    detach(line_2, character.only = TRUE)

    offset <- offset + 1
}
