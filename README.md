# Precalc 1 at Mt. Hood Community College

Interactive course materials for Precalc 1 at MHCC. 

1. Make a copy of `Makefile.paths.orignal` as `Makefile.paths`,
and then edit it following the instructions in that file.

2. From the root folder of this project, run `make <target>`
where `<target>` can be any of `images`, `html`, `pg`, `webwork-server-tex`, `latex`, `pdf`, or `check`.
Output will be generated in the appropriate place within `precalc1-MHCC/output/`.

Typically, you will run `make html`. If there is a new image to compile, you will run `make images` first.

To make PG files for uploading to WeBWorK, run `make pg`.

To make pdf output, run `make pdf`. If you run `make latex`, this will create a tex file without further processing it into a pdf.
If there is a new WeBWorK problem that uses the server as its source or creates an image file from the WeBWorK server, then run 
`make webwork-server-tex` prior to `make pdf` or `make latex`.

Running `make check` will compare the project to the DTD for MathBook XML and compile a list of DTD errors in `precalc1-MHCC/output/dtderrors.txt`.

