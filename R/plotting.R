#' Create Q-Q Plot for Model Residuals
#'
#' Generates a quantile-quantile plot to assess the normality of model residuals.
#'
#' @param model A fitted model object (e.g., from `lm` or `aov`).
#' @param title Optional title for the plot.
#' @return A ggplot object representing the Q-Q plot.
#' @examples
#' \dontrun{
#'   model <- lm(mpg ~ wt, data = mtcars)
#'   plot_qq(model)
#' }
plot_qq <- function(model, title = "Normal Q-Q Plot of Residuals") {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required. Please run load_packages().")
  }
  
  # Extract residuals safely
  res <- stats::residuals(model)
  if (is.null(res)) {
      stop("Could not extract residuals from the model.")
  }
  
  # Create data frame for ggplot
  df_plot <- data.frame(Residuals = res)
  
  # Generate Q-Q plot
  p <- ggplot2::ggplot(df_plot, ggplot2::aes(sample = Residuals)) +
    ggplot2::stat_qq() +
    ggplot2::stat_qq_line(color = "blue", linewidth = 1) +
    ggplot2::labs(
      title = title,
      x = "Theoretical Quantiles",
      y = "Sample Quantiles (Residuals)"
    ) +
    ggplot2::theme_minimal()
    
  return(p)
}

#' Create Residuals vs. Fitted Plot for Homogeneity Check
#'
#' Generates a plot of square root of absolute standardized residuals versus fitted values
#' to check for homogeneity of variance. Includes a LOESS smooth line.
#'
#' @param model A fitted model object (e.g., from `lm` or `aov`).
#' @param title Optional title for the plot.
#' @return A ggplot object representing the homogeneity plot.
#' @examples
#' \dontrun{
#'   model <- lm(mpg ~ wt, data = mtcars)
#'   plot_homogeneity(model)
#' }
plot_homogeneity <- function(model, title = "Homogeneity of Variances Check") {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required. Please run load_packages().")
  }

  # Extract fitted values and standardized residuals safely
  fitted_vals <- stats::fitted(model)
  std_res <- stats::rstandard(model)
  
  if (is.null(fitted_vals) || is.null(std_res)) {
      stop("Could not extract fitted values or standardized residuals from the model.")
  }

  # Create data frame for ggplot
  df_plot <- data.frame(
    Fitted = fitted_vals,
    Sqrt_Abs_Std_Residual = sqrt(abs(std_res))
  )

  # Generate plot
  p <- ggplot2::ggplot(df_plot, ggplot2::aes(x = Fitted, y = Sqrt_Abs_Std_Residual)) +
    ggplot2::geom_point(alpha = 0.6) +
    ggplot2::geom_smooth(method = "loess", se = TRUE, color = "blue", fill = "grey80", formula = 'y ~ x') +
    ggplot2::labs(
      x = "Fitted Values",
      y = expression(sqrt(abs("Standardized Residuals"))), # Use expression for math symbols
      title = title
    ) +
    ggplot2::theme_minimal()
    
  return(p)
}


#' Plot Linearity Check (e.g., Age vs. Score by Treatment)
#'
#' Generates a scatter plot with regression lines for each treatment group
#' to visually check for linearity assumptions or interactions.
#'
#' @param df A data frame containing the variables to plot (e.g., 'Age', 'Memory.card.score', 'Treatment').
#' @param x_var Character string, name of the x-axis variable (e.g., "Age").
#' @param y_var Character string, name of the y-axis variable (e.g., "Memory.card.score").
#' @param color_var Character string, name of the variable to color points/lines by (e.g., "Treatment").
#' @param title Optional title for the plot.
#' @return A ggplot object.
#' @examples
#' \dontrun{
#'   clean_df <- get_clean_data()
#'   plot_linearity_check(clean_df, x_var = "Age", y_var = "Memory.card.score", 
#'                        color_var = "Treatment")
#' }
plot_linearity_check <- function(df, x_var, y_var, color_var, title = NULL) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required. Please run load_packages().")
  }
  if (!all(c(x_var, y_var, color_var) %in% names(df))) {
    stop("One or more specified variables not found in the data frame.")
  }
  
  # Default title if none provided
  if (is.null(title)) {
      title <- paste("Linearity Check:", y_var, "vs", x_var, "by", color_var)
  }

  p <- ggplot2::ggplot(df, ggplot2::aes_string(x = x_var, y = y_var, color = color_var)) +
    ggplot2::geom_point(alpha = 0.7) +
    ggplot2::geom_smooth(method = "lm", se = FALSE) + # Add linear model lines per group
    ggplot2::labs(
      title = title,
      x = x_var,
      y = y_var,
      color = color_var
    ) +
    ggplot2::theme_minimal()
    
  return(p)
}
