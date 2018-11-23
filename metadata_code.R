#####################################################
#       Metadata Extractor from shapefile           #
#                                                   #  
#                November 22th 2018                 #
#                 Marco Pizzolato                   #
#####################################################

### SHORT DESCRIPTION ----

# The script loops through the shapefile in a folder and creates a report 

### PACKAGES ----

## Install previous version of rmarkdown
#install.packages("devtools")
#library(devtools)
#install_version("rmarkdown",version=1.8)

library(devtools)
library(rmarkdown) # ensure to have version 1.8
library(tinytex) 
library(sf) # manipulate shp
library(xlsx) # read xls
library(shapefiles) # library used to get the attr table
library(knitr) # create table in Rmd file

### SET WORKING DIRECTORY ----

# get path to current folder
path <- dirname(rstudioapi::getSourceEditorContext()$path)
path2 <- path
# get path to current folder + file
#path3 <- rstudioapi::getSourceEditorContext()$path
# set the WD to the current path

setwd(path)

# Check the wd
#getwd()

# Clean the environment
#rm(list = ls())


### READ EXCEL ----
# see if the file exists in the directory
exist <- which(list.files() == "metadata_to_fill.xlsx")


# if hte file does not exists fills with "not available data"
if (!length(exist) == 0){
  df <- read.xlsx(paste(path,"/metadata_to_fill.xlsx", sep=""), sheetIndex = 1, header=FALSE, encoding="UTF-8")
} else {
  df <- data.frame(stringsAsFactors=FALSE)
  df[1,1] <- "Auteur(s): "
  df[1,2] <- "not available "
  # geometry
  df[2,1] <- "Date: "
  df[2,2] <- "not available "
  # driver
  df[3,1] <- "Localisation: "
  df[3,2] <- "not available "
  # crs
  df[4,1] <- "Problèmes:  "
  df[4,2] <- "not available "
  # feature count
  df[5,1] <- "Commentaires "
  df[5,2] <- "not available "
}


### READ THE SHAPEFILE ----

setwd("..")

path_disp <- as.data.frame(path)


list_shp <- list.files(path = ".", pattern = ".*shp$")
list_whaaat <- list()
tabellone <- data.frame(stringsAsFactors=FALSE)
list_tabellone <- list()

for (i in 1:length(list_shp)){
  
  # read shapefile with sf package
  att_table <- st_read(paste("./",list_shp[i],sep = ""))
  att_layers <- st_layers(paste("./",list_shp[i],sep = ""))
  
  # get the attribute table compiled
  # name
  tabellone[1,1] <- "Name "
  tabellone[1,2] <- att_layers$name
  # geometry
  tabellone[2,1] <- "Geometry "
  tabellone[2,2] <- att_layers$geomtype[[1]]
  # driver
  tabellone[3,1] <- "Driver "
  tabellone[3,2] <- att_layers$driver
  # crs
  tabellone[4,1] <- "CRS  "
  tabellone[4,2] <- st_crs(att_table)[1]
  tabellone[5,1] <- ""
  tabellone[5,2] <- st_crs(att_table)[2]
  # feature count
  tabellone[6,1] <- "Feature count "
  tabellone[6,2] <- att_layers$features
  # fields count
  tabellone[7,1] <- "Fields count "
  tabellone[7,2] <- att_layers$fields
  
  list_tabellone[[i]] <- tabellone
  
  # read shapefile with shapefile package
  temp_shp <- strsplit(list_shp[i], split='.shp', fixed=TRUE)
  
  shape <- read.dbf(paste(temp_shp,".dbf",sep = ""), header = TRUE)
  list_whaaat[[i]] <- shape$header$fields
}


### PRINT THE PDF ----

rmarkdown::render( input = "metadataExtractor/metadata.Rmd",
                   output_format = "pdf_document",
                   output_file = paste("MetadataGenerator", ".pdf", sep = ""),
                   output_dir = getwd()) 
