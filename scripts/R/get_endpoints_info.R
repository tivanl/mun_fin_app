# gets the endpoints for the cubes

get_endpoints_info <- function(uri = "http://municipaldata.treasury.gov.za/api/cubes"){

  req <- request(uri) %>%
    req_perform()

  df_out <- req$body %>%
    rawToChar() %>%
    fromJSON() %>%
    .$data %>%
    as_tibble()

  return(df_out)

}
