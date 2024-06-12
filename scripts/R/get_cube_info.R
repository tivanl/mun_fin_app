# gets and saves the data for a specific cube

get_cube_info <- function(uri, current_page = 1, parameter = "facts"){

  # extract the cube name to construct the file name
  file_name <- gsub("(.*/)([^/]*$)", "\\2", uri) %>%
    str_c("output/cubes/", ., ".csv")

  if(file_name %in% list.files("output/cubes/", full.names = T & current_page == 1)){

    # check the latest page that has bee retrieved
    current_page <- read_delim(file_name) %>%
      pull(page_num) %>%
      max()

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
      page_num = current_page
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

  if(total_facts - (current_page - 1) * 10000 + page_size > 0){

    current_page = current_page + 1

    saved_to <- get_cube_info(uri, current_page = current_page, parameter = parameter)

  }

  return(file_name)

}
