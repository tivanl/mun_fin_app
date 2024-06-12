# Municipal Finance Data

This project sets out to make working with the municipal finance data easier. The [Municipal Finance Data](https://municipaldata.treasury.gov.za/) contain current and historical Municipal budget and financial performance information from the National Treasury of South Africa. 

The website provides API documentation which is useful for understanding how to request data from the API. 

This project uses mainly two functions:

  * `get_endpoints_info()`
    + This function gets the endpoints for each of the datasets available on the API as well as some additional information.
    + This function returns the data as a `tibble`
  * `get_cube_info()`
    + takes the endpoint of a cube and extracts the facts & data from that cube.
    + the API has a 10,000 row limit per hit
    + this function recursively requests the data from the API until all of the data have been retrieved
    + the function saves the data continuously as it retrieves data from the API and creates the file for the specific cube if it doesn't already exist
    + the function also checks, if the file already exists, what the latest page was that was saved and then continues from there 
