# gets and saves the data for a specific cube

# uri <- "http://municipaldata.treasury.gov.za/api/cubes/grants_v2"

get_cube_info <- function(uri, current_page = 1, parameter = "facts"){

  # extract the cube name to construct the file name
  file_name <- gsub("(.*/)([^/]*$)", "\\2", uri) %>%
    str_c("output/cubes//", ., ".csv")

  log_info(glue("STARTING ........{file_name}........"))

  if(file_name %in% list.files("output/cubes/", full.names = T) & current_page == 1){

    # check the latest page that has bee retrieved
    q_read_delim <- quietly(.f = ~read_delim(.x, "|"))
    file <- q_read_delim(file_name)$result

    current_page <- file %>%
      pull(page_num) %>%
      max()
    max_page <- file %>%
      pull(total_pages) %>%
      max()

    if(max_page == current_page){

      return(TRUE)

    }

    # start from the page after that
    current_page = current_page + 1

  }

  # get the specific uri for the request including the page
  uri_page <- glue("{uri}/{parameter}?page={current_page}")


  req <- request(uri_page) %>%
    req_perform()

  while(req$status != 200){

    Sys.sleep(1)

    req <- request(uri_page) %>%
      req_perform()

  }


  req_body <- req %>%
    .$body %>%
    rawToChar() %>%
    fromJSON()

  total_facts <- req_body$total_fact_count

  current_page <- req_body$page
  page_size <- req_body$page_size

  req_data <- req_body$data %>%
    as_tibble() %>%
    mutate(
      page_num = current_page,
      total_pages = total_facts %/% 10000 + 1
    )

  log_info(glue("RETRIEVED page {current_page} of {total_facts %/% 10000 + 1} for {uri}"))

  if(!file_name %in% list.files("output/cubes/", full.names = T)){
    write_delim(req_data, file = file_name, delim = "|")
  }

  write_delim(
    req_data,
    file_name,
    delim = "|",
    append = TRUE,
    col_names = FALSE
  )

  if(ceiling(total_facts / 10000)  > current_page){

    current_page = current_page + 1

    saved_to <- get_cube_info(uri, current_page = current_page, parameter = parameter)

  }

  gc()

  return(file_name)

}
