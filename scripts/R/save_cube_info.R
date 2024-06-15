save_cube_info <- function(info_output_file = "output/variable_list.csv"){


  variable_list <- list.files("output/cubes/", full.names = T) %>%
    map_dfr(
      check_na
    )

  variable_list %>%
    write_csv("output/variable_list.csv")

  log_info(glue("The summary info on the cubes can be found in {info_output_file}."))

  return(TRUE)

}
