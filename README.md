# Municipal Finance Data

## Introduction

This project sets out to make working with the municipal finance data easier. The [Municipal Finance Data](https://municipaldata.treasury.gov.za/) contain current and historical Municipal budget and financial performance information from the National Treasury of South Africa. 

The website provides API documentation which is useful for understanding how to request data from the API. 

## API navigation

Downloading the data from the API can be a timely process. The number of rows returned per request is limited to 10,000 while some cubes have multiple millions of rows. 

This project uses mainly two functions:

  * `get_endpoints_info()`
    + this function gets the endpoints for each of the datasets available on the API as well as some additional information
    + this function returns the data as a `tibble`
  * `get_cube_info()`
    + takes the endpoint of a cube and extracts the facts & data from that cube.
    + the API has a 10,000 row limit per hit
    + this function recursively requests the data from the API until all of the data have been retrieved
    + the function saves the data continuously as it retrieves data from the API and creates the file for the specific cube if it doesn't already exist
    + the function also checks, if the file already exists, what the latest page was that was saved and then continues from there 

There is an issue that I am in the process of resolving with [openup:](https://openup.org.za/):

  * conditional_grants (empty lists from page 140 onward)
  * capital (HTTP 504 Gateway Timeout)
  * incexp (HTTP 504 Gateway Timeout)
  
## A look at the data

