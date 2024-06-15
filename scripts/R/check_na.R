check_na <- function(file_path){

  # ignore messages and warnings
  q_read_delim <- quietly(.f = ~read_delim(.x, "|"))
  file <- q_read_delim(file_path)$result
  rows = nrow(file)

  report <- file %>%
    # select(-c(page_num, total_pages)) %>%
    summarise(
      across(everything(), ~mean(is.na(.x)))
    ) %>%
    pivot_longer(
      cols = everything(),
      names_to = "variable",
      values_to = "proportion_missing"
    ) %>%
    mutate(
      cube = gsub("\\.csv", "", basename(file_path)),
      cube_rows = rows
    ) %>%
    select(
      cube,
      cube_rows,
      variable,
      proportion_missing
    )

  return(report)

}
