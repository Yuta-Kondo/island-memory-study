#' Read and Clean Island Data
#'
#' Reads the raw CSV data, creates the age group factor, converts relevant
#' columns to factors, and sets the reference level for Treatment.
#'
#' @param path Character string, path to the raw CSV file.
#'   Defaults to "data/raw/island_data.csv".
#' @return A tibble (data frame) with cleaned data.
#' @examples
#' \dontrun{
#' clean_df <- get_clean_data()
#' glimpse(clean_df)
#' }
get_clean_data <- function(path = "data/raw/island_data.csv") {
  # Ensure tidyverse (specifically readr, dplyr, forcats) is loaded
  if (!requireNamespace("readr", quietly = TRUE) || 
      !requireNamespace("dplyr", quietly = TRUE) ||
      !requireNamespace("forcats", quietly = TRUE)) {
    stop("Packages 'readr', 'dplyr', and 'forcats' (part of tidyverse) are required. Please run load_packages().")
  }

  # Read the CSV file
  df <- readr::read_csv(path, show_col_types = FALSE)

  # Create age_group factor
  df <- df |>
    dplyr::mutate(
      age_group = cut(
        Age,
        breaks = c(17, 24, 44, 65),
        labels = c("18-24", "25-44", "45-65"),
        right = TRUE,
        include.lowest = TRUE # Ensure 18 is included if present
      )
    )

  # Convert character/other columns to factors and set Treatment reference level
  df <- df |>
    dplyr::mutate(
      # Convert specified columns to factors
      dplyr::across(c(Location, Gender, Education.Level, Treatment), forcats::as_factor),
      # Relevel Treatment factor
      Treatment = forcats::fct_relevel(Treatment, "Control")
    )

  # Verify Treatment levels (optional, for debugging)
  # print(levels(df$Treatment))

  return(df)
}
