## ********************************************************************* ##
## Copyright 2016                                                        ##
## Jack Green, Nick Chura                                                ##
##                                                                       ##
## This file is part of the Mount Hood Community College                 ##
## Precalculus Project                                                   ##
##                                                                       ##
## ********************************************************************* ##

#######################
# DO NOT EDIT THIS FILE
#######################

#   1) Make a copy of Makefile.paths.original
#      as Makefile.paths, which git will ignore
#   2) Edit Makefile.paths as directed there
#   3) The files Makefile and Makefile.paths.original
#      are managed by git revision control and edits will conflict

##############
# Introduction
##############

# This is not a "true" makefile, since it does not
# operate on dependencies.  It is more of a shell
# script, sharing common configurations

######################
# System Prerequisites
######################

#   install         (system tool to make directories)
#   xsltproc        (xml/xsl text processor)
#   xmllint         (only to check source against DTD)
#   <helpers>       (PDF viewer, web browser, pager, Sage executable, etc)

#####
# Use
#####

#	A) Navigate to the location of this file
#	B) At command line:  make <some-target-from-the-options-below>

# The included file contains customized versions
# of locations of the principal components of this
# project and names of various helper executables
include Makefile.paths

# These paths are subdirectories of
# the project distribution
PRJSRC    = $(PRJ)/src
OUTPUT    = $(PRJ)/output

# The project's main hub file
MAINFILE  = $(PRJSRC)/precalc1-MHCC.xml

# These paths are subdirectories of
# the Mathbook XML distribution
# MBUSR is where extension files get copied
# so relative paths work properly
MBXSL = $(MB)/xsl
MBUSR = $(MB)/user
DTD   = $(MB)/schema/dtd

# These paths are subdirectories of
# the scratch directory
PGOUT      = $(OUTPUT)/pg
HTMLOUT    = $(OUTPUT)/html
PDFOUT     = $(OUTPUT)/pdf
IMAGESOUT  = $(OUTPUT)/images
WWOUT      = $(OUTPUT)/webwork-extraction

# Some aspects of producing these examples require a WeBWorK server.
SERVER = "(https://webwork.pcc.edu,anonymous,anonymous,anonymous,open)"


################
#Targets for make
################

#  Extract webwork problems into a single XML file called
#  webwork-extraction.xml which holds multiple versions of each problem.
#  Also locally store images from the WeBWorK server.

webwork-extraction:
	install -d $(WWOUT)
	-rm $(WWOUT)/webwork-extraction.xml
	$(MB)/script/mbx -v -c webwork -d $(WWOUT) -s $(SERVER) $(MAINFILE)

#  Make a new PTX file from the source tree, with webwork elements replaced
#  by the webwork-reps from webwork-extraction.xml. (So run the above at
#  least once first.) Subsequent templates are applied to the result.

merge:
	cd $(OUTPUT); \
	xsltproc -xinclude --stringparam webwork.extraction $(WWOUT)/webwork-extraction.xml $(MBXSL)/pretext-merge.xsl $(MAINFILE) > merge.ptx

# LaTeX and PDF versions
# See prerequisite above about merge files.
# xsltproc may be passed --stringparam latex.fillin.style box for box answer blanks

pdf:
	install -d $(PDFOUT)
	install -d $(PDFOUT)/images
	-rm $(PDFOUT)/*.*
	-rm $(PDFOUT)/images/*
	cp -a $(WWOUT)/*.png $(PDFOUT)/images
	cd $(PDFOUT); \
	xsltproc $(MBXSL)/mathbook-latex.xsl $(OUTPUT)/merge.ptx; \
	xelatex precalc1-MHCC.tex; \
	xelatex precalc1-MHCC.tex; \
	open precalc1-MHCC.pdf

# make all the image files in svg format
images:
	install -d $(IMAGESOUT)
	-rm $(IMAGESOUT)/*.svg
	$(MB)/script/mbx -c latex-image -f svg -d $(IMAGESOUT) $(OUTPUT)/merge.ptx

# HTML output
# See prerequisite above about merge files.
html:
	install -d $(HTMLOUT)
	-rm $(HTMLOUT)/*.html
	-rm $(HTMLOUT)/knowl/*.html
	cp -a $(IMAGESOUT) $(HTMLOUT)
	cd $(HTMLOUT); \
	xsltproc --stringparam webwork.divisional.static no $(MBXSL)/mathbook-html.xsl $(OUTPUT)/merge.ptx;
	open -a $(HTMLVIEWER) $(HTMLOUT)/precalc1-MHCC.html

###########
# Utilities
###########

# Verify Source integrity
#   Leaves "jingreport.txt" in SCRATCH
#   Automatically invokes the "less" pager, could configure as $(PAGER)
check:
	install -d $(OUTPUT)
	-rm $(OUTPUT)/jingreport.txt
	-java -classpath ~/jing-trang/build -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration -jar ~/jing-trang/build/jing.jar $(MB)/schema/pretext.rng $(MAINFILE) > $(OUTPUT)/jingreport.txt
	less $(OUTPUT)/jingreport.txt

