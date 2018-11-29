# MetadataExtractor

## Purpose

The purpose of the script is to retrieve basic metadata from all the shapefiles contained 
in a folder, summarizing those in a .pdf file.

## Quick start

In the folder where your shapefiles are create a new folder called "metadataExtractor" and get in it the following files:
- metadata.Rmd
- metadata_code.R
- metadata_to_fill.xlsx

Modify  the information in "metadata_to_fill.xlsx"

Run metadata_code.R

## Peculiarities

1. You might have problems with the lates version of the markdown library.
If this is the case install the version 1.8

> Install previous version of rmarkdown  
> install.packages("devtools")  
> library(devtools)  
> install_version("rmarkdown",version=1.8)  

2. Ensure to have installed MikTex and have abilitated the on the fly installation of new packages.

3. If the shapefile library is not available install it manually downloading the .zip file from the CRAN repository


