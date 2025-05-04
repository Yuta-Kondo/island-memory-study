#' Fit Basic ANOVA Models
#'
#' Fits one-way ANOVA, RCB (with age_group), and interaction models.
#'
#' @param df A data frame containing 'Memory.card.score', 'Treatment', and 'age_group'.
#' @return A named list containing the fitted 'aov' model objects:
#'   `one_way`, `rcb`, `interaction`.
#' @examples
#' \dontrun{
#'   clean_df <- get_clean_data()
#'   models <- fit_anova_models(clean_df)
#'   summary(models$rcb)
#' }
fit_anova_models <- function(df) {
  if (!all(c("Memory.card.score", "Treatment", "age_group") %in% names(df))) {
    stop("Data frame must contain 'Memory.card.score', 'Treatment', and 'age_group'.")
  }
  
  models <- list()
  
  # One-way ANOVA
  models$one_way <- stats::aov(Memory.card.score ~ Treatment, data = df)
  
  # RCB Model
  models$rcb <- stats::aov(Memory.card.score ~ Treatment + age_group, data = df)
  
  # Interaction Model (for additivity check)
  models$interaction <- stats::aov(Memory.card.score ~ Treatment * age_group, data = df)
  
  # Assign data explicitly to prevent potential issues with some functions
  models$one_way$call$data <- quote(df)
  models$rcb$call$data <- quote(df)
  models$interaction$call$data <- quote(df)

  return(models)
}


#' Perform Box-Cox Transformation and Fit Model
#'
#' Determines the optimal lambda using Box-Cox, transforms the response variable,
#' and fits a linear model using the specified formula with the transformed response.
#'
#' @param formula An object of class "formula": a symbolic description of the model
#'   to be fitted (e.g., Memory.card.score ~ Treatment + Age + ...).
#' @param data A data frame containing the variables in the model.
#' @param lambda_seq A sequence of lambda values to consider for Box-Cox.
#'   Defaults to `seq(-2, 4, 0.1)`.
#' @return A named list containing:
#'   `lambda`: The optimal lambda value found.
#'   `transformed_model`: The fitted 'lm' object using the transformed response.
#' @examples
#' \dontrun{
#'   clean_df <- get_clean_data()
#'   formula_additive <- Memory.card.score ~ Treatment + Age + Location + Gender + Education.Level
#'   bc_results <- fit_boxcox_transformed_model(formula_additive, clean_df)
#'   summary(bc_results$transformed_model)
#' }
fit_boxcox_transformed_model <- function(formula, data, lambda_seq = seq(-2, 4, 0.1)) {
  if (!requireNamespace("MASS", quietly = TRUE)) {
    stop("Package 'MASS' is required for Box-Cox. Please run load_packages().")
  }
  
  # Ensure formula is a formula object
  formula <- stats::as.formula(formula)
  
  # Fit initial model to get Box-Cox lambda
  initial_model <- stats::lm(formula, data = data)
  initial_model$call$data <- quote(data) # Ensure data context is kept

  # Perform Box-Cox
  bc <- MASS::boxcox(initial_model, lambda = lambda_seq, plotit = FALSE)
  optimal_lambda <- bc$x[which.max(bc$y)]

  # Get response variable name from formula
  response_var <- all.vars(formula)[1]
  
  # Transform the response variable
  # Handle lambda close to 0 (log transform)
  if (abs(optimal_lambda) < 1e-6) {
    data$y_transformed <- log(data[[response_var]])
  } else {
    data$y_transformed <- (data[[response_var]]^optimal_lambda - 1) / optimal_lambda
  }

  # Create the formula for the transformed model
  transformed_formula_str <- paste("y_transformed ~", paste(all.vars(formula)[-1], collapse = " + "))
  transformed_formula <- stats::as.formula(transformed_formula_str)

  # Fit the model with the transformed response
  transformed_model <- stats::lm(transformed_formula, data = data)
  transformed_model$call$data <- quote(data) # Ensure data context

  return(list(lambda = optimal_lambda, transformed_model = transformed_model))
}
