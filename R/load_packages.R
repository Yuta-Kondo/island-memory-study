#' Load (and install if missing) all CRAN packages used in the project
#'
#' This function checks for required packages, installs them if missing,
#' and loads them into the session.
#'
#' @return Invisible NULL. Loads packages as a side effect.
#' @examples
#' \dontrun{
#' load_packages()
#' }
load_packages <- function() {
  # List of required packages identified from the original scripts
  pkgs <- c(
    "tidyverse",    # For readr, dplyr, ggplot2, forcats etc.
    "performance",  # For check_model
    "MASS"          # For boxcox
    # Add any other required packages here
  )

  # Check, install (if needed), and load packages
  installed_pkgs <- installed.packages()[, "Package"]
  
  for (pkg in pkgs) {
    if (!pkg %in% installed_pkgs) {
      message(paste("Installing package:", pkg))
      install.packages(pkg, dependencies = TRUE)
    }
    # Load package quietly
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }
  
  # Explicitly load ggplot2 again in case it wasn't fully attached via tidyverse
  # This ensures ggplot functions are definitely available
  if (!"ggplot2" %in% (.packages())) {
      suppressPackageStartupMessages(library(ggplot2))
  }

  invisible(NULL)
}
