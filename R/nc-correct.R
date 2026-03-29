#' Correct for bias using negative controls
#'
#' `nc_correct()` applies a bias correction method that uses negative control
#' variables to produce a bias-adjusted estimate of the primary
#' exposure-outcome association.
#'
#' Currently implemented methods:
#'
#' - `"diff_in_diff"`: Difference-in-differences (simple subtraction). Corrects
#'   the primary estimate by subtracting the negative control association,
#'   under the equi-confounding assumption. Requires a negative control outcome
#'   (`nco`).
#'
#' @param ncdata `[nc_data]`\cr
#'   Dataset prepared with [nc_data()].
#' @param method `[character(1)]`\cr
#'   Correction method to use. See Details for available methods.
#' @param model `[nc_model]`\cr
#'   Model specification created with [nc_model()]. Defaults to OLS via
#'   [stats::lm()].
#' @param ... `[any]`\cr
#'   Additional arguments passed to the specific correction method.
#'
#' @return An [nc_correct_result()] object.
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
#' nc_correct(nd, method = "diff_in_diff")
nc_correct <- function(ncdata, method = "diff_in_diff", model = nc_model(stats::lm), ...) {
  if (!inherits(ncdata, "nc_data")) {
    rlang::abort("`ncdata` must be an `nc_data` object created by `nc_data()`.")
  }
  if (!inherits(model, "nc_model")) {
    rlang::abort("`model` must be an `nc_model` object created by `nc_model()`.")
  }

  supported <- c("diff_in_diff")
  check_choice(method, supported)

  spec <- attr(ncdata, "spec")

  switch(method,
    diff_in_diff = nc_correct_diff_in_diff(ncdata, spec, model, rlang::current_call(), ...)
  )
}

nc_correct_diff_in_diff <- function(ncdata, spec, model, call, ...) {
  if (is.null(spec$nco)) {
    rlang::abort(
      "The `diff_in_diff` method requires a negative control outcome (`nco`).",
      call = call
    )
  }

  primary_predictors <- build_predictors(spec, include = c("exposure", "covariates"))
  fit_primary <- fit_model(spec, ncdata, spec$outcome, primary_predictors, model)

  nco_predictors <- build_predictors(spec, include = c("exposure", "covariates"))
  fit_nco <- fit_model(spec, ncdata, spec$nco, nco_predictors, model)

  primary_coefs <- stats::coef(fit_primary)
  nco_coefs <- stats::coef(fit_nco)

  if (!spec$exposure %in% names(primary_coefs)) {
    rlang::abort(
      paste0("Coefficient for `", spec$exposure, "` not found in primary model."),
      call = call
    )
  }
  if (!spec$exposure %in% names(nco_coefs)) {
    rlang::abort(
      paste0("Coefficient for `", spec$exposure, "` not found in NCO model."),
      call = call
    )
  }

  beta_primary <- primary_coefs[[spec$exposure]]
  beta_nco <- nco_coefs[[spec$exposure]]
  corrected <- beta_primary - beta_nco

  nc_correct_result(
    estimate = corrected,
    se = NULL,
    ci = NULL,
    method = "diff_in_diff",
    nc_type = "nco",
    model_fits = list(primary = fit_primary, nco = fit_nco),
    call = call
  )
}
