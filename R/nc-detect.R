#' Detect bias using negative controls
#'
#' `nc_detect()` tests for the presence of bias by estimating the association
#' between a negative control variable and the primary outcome or exposure.
#' A statistically or practically significant association suggests the presence
#' of unmeasured confounding, selection bias, or measurement error.
#'
#' Currently implemented methods:
#'
#' - `"null_test"`: Null hypothesis test of the negative control association
#'   (Wald test on the regression coefficient).
#'
#' @param ncdata `[nc_data]`\cr
#'   Dataset prepared with [nc_data()].
#' @param method `[character(1)]`\cr
#'   Detection method to use. See Details for available methods.
#' @param model `[nc_model]`\cr
#'   Model specification created with [nc_model()]. Defaults to OLS via
#'   [stats::lm()].
#' @param ... `[any]`\cr
#'   Additional arguments passed to the specific detection method.
#'
#' @return An [nc_detect_result()] object.
#'
#' @export
#'
#' @examples
#' df <- data.frame(
#'   A = rbinom(200, 1, 0.5),
#'   Y = rnorm(200),
#'   W = rnorm(200),
#'   age = rnorm(200)
#' )
#' spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W", covariates = "age")
#' nd <- nc_data(df, spec)
#' nc_detect(nd, method = "null_test")
nc_detect <- function(ncdata, method = "null_test", model = nc_model(stats::lm), ...) {
  if (!inherits(ncdata, "nc_data")) {
    rlang::abort("`ncdata` must be an `nc_data` object created by `nc_data()`.")
  }
  if (!inherits(model, "nc_model")) {
    rlang::abort("`model` must be an `nc_model` object created by `nc_model()`.")
  }

  supported <- c("null_test")
  check_choice(method, supported)

  spec <- attr(ncdata, "spec")

  switch(method,
    null_test = nc_detect_null_test(ncdata, spec, model, rlang::current_call(), ...)
  )
}

nc_detect_null_test <- function(ncdata, spec, model, call, ...) {
  if (is.null(spec$nco) && is.null(spec$nce)) {
    rlang::abort("At least one negative control variable must be specified.", call = call)
  }

  if (!is.null(spec$nco)) {
    nc_var <- spec$nco
    nc_type <- "nco"
    predictors <- build_predictors(
      spec,
      include = c("exposure", "covariates"),
      exclude = NULL
    )
    predictors <- c(nc_var, predictors)
    response <- spec$outcome
  } else {
    nc_var <- spec$nce
    nc_type <- "nce"
    predictors <- build_predictors(
      spec,
      include = c("covariates"),
      exclude = NULL
    )
    predictors <- c(nc_var, predictors)
    response <- spec$outcome
  }

  fit <- fit_model(spec, ncdata, response, predictors, model)
  coef_summary <- summary(fit)$coefficients

  if (!nc_var %in% rownames(coef_summary)) {
    rlang::abort(
      paste0("Coefficient for `", nc_var, "` not found in model summary."),
      call = call
    )
  }

  row <- coef_summary[nc_var, , drop = FALSE]
  estimate <- row[1L, 1L]
  se <- if (ncol(row) >= 2L) row[1L, 2L] else NULL
  p_value <- if (ncol(row) >= 4L) row[1L, 4L] else NULL

  ci <- tryCatch(
    {
      ci_mat <- stats::confint(fit)
      c(lower = ci_mat[nc_var, 1L], upper = ci_mat[nc_var, 2L])
    },
    error = function(e) NULL
  )

  nc_detect_result(
    estimate = estimate,
    se = se,
    ci = ci,
    p_value = p_value,
    method = "null_test",
    nc_type = nc_type,
    model_fit = fit,
    call = call
  )
}
