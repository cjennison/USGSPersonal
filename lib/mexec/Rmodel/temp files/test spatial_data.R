#!/usr/bin/env Rscript

library(sp)
library(rgdal)
library(rgeos)
library(maptools)     


# Load NHDplus Data

##
##
#####
####
###
##
#


# Base directory (change depending on file structure wherever this is being run)
basedir<-"C:/ALR/SpatialData"
# basedir<-"/home/ana/testing"
# basedir<-"C:/Documents/__USGS"

##### Define projections
# Projection used by NHD and NHDplus
proj4.NHD<-"+proj=longlat +ellps=GRS80 +datum=NAD83 +no_defs"
#Projection used by NHDplus for gridded data
# proj4.NHDplusgrid
# Projection used by MassGIS
# proj4.MAstateplane<-"+proj=lcc +lat_1=41.71666666666667 +lat_2=42.68333333333333 +lat_0=41 +lon_0=-71.5 +x_0=200000 +y_0=750000 +ellps=GRS80 +units=m +no_defs"


### load NHDPlus shapefiles and attribute dbf files
#Flowlines
setwd(paste0(basedir,"/NHDPlus/NHDPlusV21_NE_01_NHDSnapshot_01/NHDPlusNE/NHDPlus01/NHDSnapshot/Hydrography"))
system.time(NEFlow.line<-readShapeLines("NHDFlowline",proj4string=CRS(proj4.NHD)))

#Catchments
setwd(paste0(basedir,"/NHDplus/NHDPlusV21_NE_01_NHDPlusCatchment_01/NHDPlusNE/NHDPlus01/NHDPlusCatchment"))
system.time(NECatch.shape<-readShapePoly("Catchment",proj4string=CRS(proj4.NHD)))

#Attributes tables
setwd(paste0(basedir,"/NHDplus/NHDPlusV21_NE_01_NHDPlusAttributes_01/NHDPlusNE/NHDPlus01/NHDPlusAttributes"))
system.time(plusflow<-read.dbf("PlusFlow.dbf"))
system.time(plusflowlineVAA<-read.dbf("PlusFlowlineVAA.dbf"))

### Merge w/ VAA table to get attributes
plusdata<-plusflowlineVAA[,c(1,4,1)]
bkup<-NEFlow.line
NEFlow.line@data[c(1:nrow(NEFlow.line@data)),ncol(NEFlow.line)+1]<-c(1:nrow(NEFlow.line@data)) #add column to sort by later
colnames(NEFlow.line@data)[15]<-"sortby"
NEFlow.line@data<-merge(NEFlow.line, plusdata, by.x="COMID", by.y="ComID", all.x=TRUE, sort=FALSE)
NEFlow.line@data<-NEFlow.line@data[order(NEFlow.line$sortby),] 
rm(list=c("plusdata"))

NHDFlow.line<-NEFlow.line
NHDCatch.shape<-NECatch.shape


   ### Create a subset of NHDplus flowlines/features
   ### lower CT R basin only, just to save time
   lowCTFlow.line<-NEFlow.line[substr(NEFlow.line$REACHCODE,1,6)=="010802",] #HUC6
   system.time(lowCTCatch.shape<-NECatch.shape[NECatch.shape$FEATUREID %in% lowCTFlow.line$COMID,])
# 
# huc8<-unique(substr(NEFlow.line$REACHCODE,1,8))
# huc8[1:10]
# length(huc8)

setwd("C:/ALR/GeneratedSpatialData/dissolved_hucs/huc8byreachcode")
for (i in 1:length(huc8)) {
   
   huc8.line<-NEFlow.line[substr(NEFlow.line$REACHCODE,1,8)==huc8[i],] #HUC8
   huc8.shape<-NECatch.shape[NECatch.shape$FEATUREID %in% huc8.line$COMID,]
   writeOGR(huc8.shape,  ".", layer=paste0(huc8[i],"Catchments"), driver="ESRI Shapefile")
   writeOGR(huc8.line,  ".", layer=paste0(huc8[i],"Flowlines"), driver="ESRI Shapefile")
   writeOGR(huc8.shape,  paste0(huc8[i],"Catchments.kml"), layer="NHDCatchments", driver="KML",dataset_options=c("NameField=FEATUREID"))
   writeOGR(huc8.line,  paste0(huc8[i],"Flowlines.kml"), layer="NHDplusFlowlines", driver="KML",dataset_options=c("NameField=COMID","DescriptionField=GNIS_NAME"))    
   
}
i<-length(huc8)
# huc8.line<-NEFlow.line[substr(NEFlow.line$REACHCODE,1,8)==huc8[i],] #HUC8
# huc8.shape<-NECatch.shape[NECatch.shape$FEATUREID %in% huc8.line$COMID,]
# huc8.line@data
# plot(NECatch.shape)
# plot(huc8.line,att=T)
# 
# NEFlow.line@data[substr(NEFlow.line$REACHCODE,1,8)==huc8[length(huc8)],]
# 
# midCTFlow.line<-NEFlow.line[substr(NEFlow.line$REACHCODE,1,8)=="01080201",] #HUC8
# midCTCatch.shape<-NECatch.shape[NECatch.shape$FEATUREID %in% midCTFlow.line$COMID,]

setwd("C:/ALR/GeneratedSpatialData/smallNHDplus")
writeOGR(lowCTCatch.shape,  ".", layer="NHDCatchments", driver="ESRI Shapefile")
writeOGR(lowCTFlow.line,  ".", layer="NHDplusFlowlines", driver="ESRI Shapefile")
writeOGR(lowCTCatch.shape,  "NHDCatchments.kml", layer="NHDCatchments", driver="KML",dataset_options=c("NameField=FEATUREID"))
writeOGR(lowCTFlow.line,  "NHDplusFlowlines.kml", layer="NHDplusFlowlines", driver="KML",dataset_options=c("NameField=COMID","DescriptionField=GNIS_NAME"))    

system.time(catchfromshape<-readShapePoly("NHDCatchments",proj4string=CRS(proj4.NHD)))
system.time(linesfromshape<-readShapeLines("NHDplusFlowlines",proj4string=CRS(proj4.NHD)))

setwd("C:/ALR/GeneratedSpatialData/huc8")
writeOGR(midCTCatch.shape,  ".", layer="huc8catch", driver="ESRI Shapefile")
writeOGR(midCTFlow.line,  ".", layer="huc8flow", driver="ESRI Shapefile")

system.time(catch8fromshape<-readShapePoly("huc8catch",proj4string=CRS(proj4.NHD)))
system.time(lines8fromshape<-readShapeLines("huc8flow",proj4string=CRS(proj4.NHD)))

   
   ### The NHDFlow.line and NHDCatch.shape will be used throughout the code
   ### Here, decide whether these should point to the full set of catchments/flowlines 
   ### for the New England region, or for a subsection of the Lower CT R basin
   NHDFlow.line<-lowCTFlow.line
   NHDCatch.shape<-lowCTCatch.shape


setwd(paste0(basedir,"/NHDplus/NHDPlusV21_NE_01_WBDSnapshot_01/NHDPlusNE/NHDPlus01/WBDSnapshot/WBD"))
system.time(hucs.shape<-readShapePoly("WBD_Subwatershed",proj4string=CRS(proj4.NHD)))

huc10.shape<-unionSpatialPolygons(hucs.shape,hucs.shape$HUC_10)
plot(huc10.shape)
class(huc10.shape)
names(huc10.shape@data)
length(levels(hucs.shape$HUC_8))
length(levels(hucs.shape$HUC_10))
length(levels(hucs.shape$HUC_12))


oldcatch<-NECatch.shape
newcatch<-NHDCatch.shape[1,]
newcatch@data
names(newcatch@data)
newcatch@data[,"HUC_10"]<-1
newcatch<-newcatch[-1,]
newcatch@data
names(newcatch@data)

featureids<-oldcatch$FEATUREID

hucs.shape<-bkuphuc
hucs.shape$HUC_10<-as.character(hucs.shape$HUC_10)
hucs.shape$HUC_10[333:335]

class(hucs.shape)

for (i in 1:2) {
    i<-345
   catch_index<-NECatch.shape$FEATUREID==featureids[i]
   huc_index<-over(NECatch.shape[catch_index,],huc10.shape)
    huc10.shape@polygons[[i]]@ID
    plot(huc10.shape[huc_index,])
    plot(NECatch.shape[catch_index,],add=T)
    n<-as.character(huc10.shape@polygons[[i]]@ID)
   n
    class(n)
    class(hucs.shape$HUC_10)
    sum(as.numeric(hucs.shape$HUC_10==n))
    hucs.shape[hucs.shape$HUC_10==n,]
    plot(hucs.shape[hucs.shape$HUC_10==n,],add=F,lty=3,col="blue")
#    print(current)
   newcatch_index<-length(newcatch)+1
    newcatch[newcatch_index,]<-oldcatch[catch_index,]
   newcatch[newcatch_index,"HUC_10"]
#    oldcatch<-oldcatch[-oldcatch$FEATUREID==current,]
#    print(paste("old",length(oldcatch),"new",length(newcatch)))
   
}










plot(huc10.shape[huc_index,])
plot(NECatch.shape[catch_index,],add=T)
str(huc10.shape)
getSlots(huc10.shape)
attributes(huc10.shape)
class(huc10.shape)
ncol(huc10.shape)
str(huc10.shape[1]@polygons)
attributes(huc10.shape[1]@polygons)
getSlots("SpatialPolygons")
huc10.shape@polygons[[1]]@ID

huc10.shape@polygons[,2]
names(huc10.shape)
class(huc10.shape["0107000609"])

str(unlist(huc10.shape@polygons))
getSlots("Polygons")
getSlots("polygons")

huc10.shape@polygons$Polygons


attr(huc10.shape[1]@polygons)
attr(huc10.shape[1],"ID")
a<-huc10.shape@polygons
names(a)
a@Polygons
str(a)

i<-2423
a<-NECatch.shape[NECatch.shape$FEATUREID==featureids[i],]
b<-over(a,huc10.shape) #returns index of huc10.shape
plot(huc10.shape[b,])
plot(a,add=T)

# for (i in 1:length(huc_codes)) {
for (i in 1:10) {
      
   catch<-over(NECatch.shape,huc10.shape[huc_codes[i]])
   print(huc_codes[1])
   print(catch$FEATUREID)
   writeOGR(catch,  ".", layer=huc_codes[i], driver="ESRI Shapefile")
}


plot(hucs.shape)
names(hucs.shape)
huc10.shape<-unionSpatialPolygons(hucs.shape,hucs.shape$HUC_10)
plot(huc10.shape)
class(huc10.shape)
names(huc10.shape@data)
length(levels(hucs.shape$HUC_8))
length(levels(hucs.shape$HUC_10))
length(levels(hucs.shape$HUC_12))

huc_codes<-levels(hucs.shape$HUC_10)
huc_codes[1:10]
lowCTFlow.line$REACHCODE[300:333]
names(NECatch.shape)
setwd("c:/ALR/GeneratedSpatialData/byHUC10")

oldcatch<-NECatch.shape
newcatch<-NHDCatch.shape[1,]
newcatch@data
names(newcatch@data)
newcatch@data[,"HUC_10"]<-1
newcatch<-newcatch[-1,]
newcatch@data
names(newcatch@data)