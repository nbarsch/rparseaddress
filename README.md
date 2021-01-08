# rparseaddress
[**tenfourWest.com**](https://www.tenfourwest.com) function to parse addresses

## Installation in R

```r
if (!require(remotes)) install.packages("remotes")
remotes::install_github("nbarsch/rparseaddress")
```

## Usage
```rparseaddress``` is the R wrapper to the ```usaddress``` python module to make address parsing easy and automatic. This function uses the R package ```reticulate``` to run usaddress python module directly and easily in R.


## To parse addresses:
```rparseaddress::rparseaddress(address, check_python=TRUE, force_stateabb=FALSE, return="char")```

**On Mac and Linux** python AND the python module ``usaddress`` should automatically install if missing (because unix is superior clearly).

**On Windows** it is recommended to 
1. Install python yourself from here: https://www.python.org/downloads/windows/ 
2. Install c++ and python tools for visual studio: https://visualstudio.microsoft.com/downloads/ 
2. Use powershell to ```pip3 install usaddress```
3. When running ```parseaddress()``` use ```check_python=FALSE``` to avoid issues running in the windows OS. 

## Simplest use
```rparseaddress("Biden's White House 1600 Pennsylvania Ave NW, Washington DC 20500")```

```
                Recipient             AddressNumber                StreetName        StreetNamePostType StreetNamePostDirectional                 PlaceName 
    "Biden's White House"                    "1600"            "Pennsylvania"                     "Ave"                      "NW"              "Washington" 
                StateName                   ZipCode 
                     "DC"                   "20500" 
```
```rparseaddress("Biden's White House 1700 Pennsylvania Ave NW, Washington DC 20500", return="vertical")```

```

                               parsed_address
Recipient                 Biden's White House
AddressNumber                            1600
StreetName                       Pennsylvania
StreetNamePostType                        Ave
StreetNamePostDirectional                  NW
PlaceName                          Washington
StateName                                  DC
ZipCode                                 20500

```
```rparseaddress("Colgate University 13 Oak Drive Hamilton, NY 13346", return="horizontal")```

```
                        Recipient AddressNumber StreetName StreetNamePostType PlaceName StateName ZipCode
parsed_address Colgate University            13        Oak              Drive  Hamilton        NY   13346
```                   


## Optional Parameters:

```return``` FORMAT TYPE for RETURNED RESULTS (1. "vertical" or "v" for vertical data.frame, 2. "horizontal" or "h" for horizontal data.frame, "c" or "char" for named character vector )

```check_python``` TRUE or FALSE, DO NOT INSTALL MINICONDA IF PROMPTED! TRUE=check for python dependencies and install if missing, FALSE= skip check (faster if you have already have the python dependencies installed)

```force_stateabb``` TRUE or FALSE, if TRUE state names are forced to abbreviation format for unified format

## To Apply to: ADDRESS DATA.FRAME COLUMN -or- VECTOR OF ADDRESSES:

```
library(rparseaddress)

sampledf <- data.frame(adnum=c(1:4),addressvec=c("White House 1600 Pennsylvania Avenue NW Washington DC", "Colgate 13 Oak Dr. Hamilton, NY 13346","200 E Colfax Ave Denver, CO","355 E Kalamazoo Ave, Kalamazoo, MI 49007"),stringsAsFactors = F)

#to get a full data.frame with parsed results
advecdf <- rparseaddressvec(sampledf$addressvec)
print(advecdf)

     Recipient AddressNumber   StreetName StreetNamePostType StreetNamePostDirectional  PlaceName StateName ZipCode
1: White House          1600 Pennsylvania             Avenue                        NW Washington        DC    <NA>
2:     Colgate            13          Oak                Dr.                      <NA>   Hamilton        NY   13346
3:        <NA>           200       Colfax                Ave                      <NA>     Denver        CO    <NA>
4:        <NA>           355    Kalamazoo                Ave                      <NA>  Kalamazoo        MI   49007
   StreetNamePreDirectional
1:                     <NA>
2:                     <NA>
3:                        E
4:                        E


#to isolate one address characteristic, use return="characteristic", i.e. return="ZipCode" or return="StreetName"
> zipcodes <- rparseaddressvec(sampledf$addressvec,return="ZipCode")
> print(zipcodes)
[1] NA      "13346" NA      "49007"
> streetnames <- rparseaddressvec(sampledf$addressvec,return="StreetName")
> print(streetnames)
[1] "Pennsylvania" "Oak"          "Colfax"       "Kalamazoo"   

```

