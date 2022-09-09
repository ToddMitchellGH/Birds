# Work.r: Ingest data into a dataframe, and make a map of the distribution
# 
# There is a lot to do:
# 1) where does R plot text --- is there an offset?
# 2) Add rivers and elevations
# 3) Statistics for species
#
# Todd Mitchell, August 2022

setwd( '/Users/mitchell/Documents/Data/ebird/South_America' )
list.files()
system( 'ls -lt data/*' )

# Download country files from the Cornell University ebird repository
# Load the file for Peru in June 2022 into R
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data",
     "ebd_PE_202206_202206_relJun-2022.txt" )
df_PE <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )

colnames( df )  # provides the column names.  "names( df )" gives the same.
 [1] "GLOBAL.UNIQUE.IDENTIFIER"   "LAST.EDITED.DATE"           "TAXONOMIC.ORDER"            "CATEGORY"                  
 [5] "TAXON.CONCEPT.ID"           "COMMON.NAME"                "SCIENTIFIC.NAME"            "SUBSPECIES.COMMON.NAME"    
 [9] "SUBSPECIES.SCIENTIFIC.NAME" "EXOTIC.CODE"                "OBSERVATION.COUNT"          "BREEDING.CODE"             
[13] "BREEDING.CATEGORY"          "BEHAVIOR.CODE"              "AGE.SEX"                    "COUNTRY"                   
[17] "COUNTRY.CODE"               "STATE"                      "STATE.CODE"                 "COUNTY"                    
[21] "COUNTY.CODE"                "IBA.CODE"                   "BCR.CODE"                   "USFWS.CODE"                
[25] "ATLAS.BLOCK"                "LOCALITY"                   "LOCALITY.ID"                "LOCALITY.TYPE"             
[29] "LATITUDE"                   "LONGITUDE"                  "OBSERVATION.DATE"           "TIME.OBSERVATIONS.STARTED" 
[33] "OBSERVER.ID"                "SAMPLING.EVENT.IDENTIFIER"  "PROTOCOL.TYPE"              "PROTOCOL.CODE"             
[37] "PROJECT.CODE"               "DURATION.MINUTES"           "EFFORT.DISTANCE.KM"         "EFFORT.AREA.HA"            
[41] "NUMBER.OBSERVERS"           "ALL.SPECIES.REPORTED"       "GROUP.IDENTIFIER"           "HAS.MEDIA"                 
[45] "APPROVED"                   "REVIEWED"                   "REASON"                     "TRIP.COMMENTS"             
[49] "SPECIES.COMMENTS"           "X"                         

# Ingest neighboring countries' data
system( 'ls -lt data/*' )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_BO_202206_202206_relJun-2022.txt" )
df_BO <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_BR_202206_202206_relJun-2022.txt" )
df_BR <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_CO_202206_202206_relJun-2022.txt" )
df_CO <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_AR_202206_202206_relJun-2022.txt" )
df_AR <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_CL_202206_202206_relJun-2022.txt" )
df_CL <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_EC_202206_202206_relJun-2022.txt" )
df_EC <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_GF_202206_202206_relJun-2022.txt" )
df_GF <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_GY_202206_202206_relJun-2022.txt" )
df_GY <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_PY_202206_202206_relJun-2022.txt" )
df_PY <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_SR_202206_202206_relJun-2022.txt" )
df_SR <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_UY_202206_202206_relJun-2022.txt" )
df_UY <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )
path <- file.path( "~", "Documents", "Data", "ebird", "South_America", "data", "ebd_VE_202206_202206_relJun-2022.txt" )
df_VE <- read.delim( path, stringsAsFactors = FALSE, header=TRUE )

library(tidyverse)
df2 <- bind_rows( df_AR, df_BO, df_BR, df_CL, df_CO, df_EC, df_GF, df_GY, df_PE, df_PY, df_SR, df_UY, df_VE )
nrow(df2)
# 604268

# Locations of cities
# Lima 12.0464° S, 77.0428° W
# Iquitos 3.7437° S, 73.2516° W
# Puerto Maldonado 12.5809° S, 69.2032° W
# Cusco 13.5320° S, 71.9675° W
# Chiclayo 6.7701° S, 79.8550° W
# Bogota 4.7110° N, 74.0721° W
# Cartagena 10.3932° N, 75.4832° W
# La Paz 16.4897° S, 68.1193° W
# Sao Paolo 23.5558° S, 46.6396° W
# Rio de Janiero 22.9068° S, 43.1729° W
# Manaus 3.1190° S, 60.0217° W
# Santiago 33.4489° S, 70.6693° W
# Buenos Aires 34.6037° S, 58.3816° W
# Ushuaia 54.8019° S, 68.3030° W
# Quito 0.1807° S, 78.4678° W

# Use ggplot2 for plots -----------------------------------------------------------------------
library(ggplot2)

ggp <- ggplot( df2, aes(x=LONGITUDE, y=LATITUDE)) + geom_point( color=rgb(0.7,0.7,0.7),shape=1, size=2 ) +
  ggtitle("June 2022 604k ebird observations" ) + theme(plot.title = element_text(hjust = 0.5)) +
  annotate('text', x=c(-77, -73.3, -69.2, -72, -74, -75.5, -68.1, -46.6, -43.2, -60, -80, -70.7, -58.4, -68.3, -78.5, -72.9), y=c(-12, -3.7, -12.6, -13.5, 4.7, 10.4, -16.5, -23.6, -22.9, -3.1, -6.8, -33.4, -34.6, -54.8, 0.2, -41.5), label=c('L', 'I', 'PM', 'C', 'B', 'C', 'LP', 'SP', 'RdJ', 'M', 'C', 'S', 'BA', 'U', 'Q', 'PM' )) + annotate(geom = "text", x=-93, y=-54, label = "First Climate Analyses", hjust = 0, color='grey40', size=3)
ggp
ggsave( "distsatotal202206.ggplot.annotated.png", ggp, dpi=400 )   # dpi=400 gives crisp lettering
system( 'open -a Preview.app distsatotal202206.ggplot.annotated.png' )

aspect_ratio = 55 / ( 60 * cos(20/180*pi) )
aspect_ratio
# 0.98 is close to 1 so no need to modify the figure.

# Output a subset of the variables ------------------------------------------------------------

colnames(df2[ c(1,6,7,11,16,17,29:31) ] )
[1] "GLOBAL.UNIQUE.IDENTIFIER" "COMMON.NAME"              "SCIENTIFIC.NAME"          "OBSERVATION.COUNT"        "COUNTRY"                 
[6] "COUNTRY.CODE"             "LATITUDE"                 "LONGITUDE"                "OBSERVATION.DATE"

write_csv( df2[ c(1,6,7,11,16,17,29:31) ], 'ebirdsouthamerica202206.csv' )
system( 'ls -l ebirdsouthamerica202206.csv' )
df_test = read_csv( 'ebirdsouthamerica202206.csv' )
ncol(df_test)
colnames(df_test)

[1] "GLOBAL.UNIQUE.IDENTIFIER" "COMMON.NAME"              "SCIENTIFIC.NAME"          "OBSERVATION.COUNT"        "COUNTRY"                 
[6] "COUNTRY.CODE"             "LATITUDE"                 "LONGITUDE"                "OBSERVATION.DATE"        

# From https://github.com/ashwinv2005/state-of-indias-birds/blob/master/species_codes_for_website.R
# the following write/read.csv pair works.  I had to drop row.names=F
# write.csv(lists, "species_codes_categories_for_website.csv", row.names = F)
# clemcheck = read.csv("eBird-Clements-v2019-integrated-checklist-August-2019.csv")

