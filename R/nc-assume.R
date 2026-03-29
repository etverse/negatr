#' Check assumptions for a negative control analysis
#'
#' `nc_assume()` evaluates whether the dataset and specification are consistent
#' with core assumptions required by negative control methods. Checks are
#' performed heuristically (e.g. via regression tests) and should be treated
#' as diagnostic aids, not proofs.
#'
#' Checks performed:
#'
#' - **Exclusion restriction** (`"exclusion"`): Tests whether the negative
#'   control exposure (NCE) is associated with the primary outcome after
#'   adjusting for the primary exposure and covariates. A significant
#'   association is evidence against the exclusion restriction.
#' - **U-comparability** (`"u_comparability"`): Tests whether the NCE is
#'   associated with the primary exposure. A significant association is
#'   consistent with U-comparability: the NCE and the primary exposure share
#'   the same unmeasured confounders.
#'
#' @param ncdata `[nc_data]`\cr
#'   Dataset prepared with [nc_data()].
#' @param checks `[character()]`\cr
#'   Which assumptions to check. Defaults to all available checks.
#' @param model `[nc_model]`\cr
#'   Model specification for regression-based checks. Defaults to OLS.
#' @param ... `[any]`\cr
#'   Reserved for future use.
#'
#' @return An object of class `nc_assume_result`: a named list where each
#'   element corresponds to one check and contains `$passed` (`TRUE`/`FALSE`/
#'   `NA`), `$message`, and optionally `$model_fit`.
#'
#' @export
#'
#' @examples
#' df <- data.frame(
#'   A = rbinom(200, 1, 0.5),
#'   Y = rnorm(200),
#'   Z = rbinom(200, 1, 0.5),
#'   W = rnorm(200),
#'   age = rnorm(200)
#' )
#' spec <- nc_spec(
#'   exposure = "A", outcome = "Y",
#'   nce = "Z", nco = "W",
#'   covariates = "age"
#' )
#' nd <- nc_data(df, spec)
#' nc_assume(nd)
nc_assume <- function(
    ncdata,
    checks = c("exclusion", "u_comparability"),
    model = nc_model(stats::lm),
    ...) {
  if (!inherits(ncdata, "nc_data")) {
    rlang::abort("`ncdata` must be an `nc_data` object created by `nc_data()`.")
  }
  if (!inherits(model, "nc_model")) {
    rlang::abort("`model` must be an `nc_model` object created by `nc_model()`.")
  }

  supported <- c("exclusion", "u_comparability")
  for (ch in checks) check_choice(ch, supported)

  spec <- attr(ncdata, "spec")
  results <- list()

  if ("exclusion" %in% checks) {
    results[["exclusion"]] <- check_exclusion(ncdata, spec, model)
  }
  if ("u_comparability" %in% checks) {
    results[["u_comparability"]] <- check_u_comparability(ncdata, spec, model)
  }

  structure(results, class = "nc_assume_result")
}

#' @export
print.nc_assume_result <- function(x, ...) {
  cat("Negative control assumption checks\n")
  for (nm in names(x)) {
    item <- x[[nm]]
    status <- if (isTRUE(item$passed)) "[PASS]" else if (isFALSE(item$passed)) "[FAIL]" else "[WARN]"
    cat(" ", status, nm, ":", item$message, "\n")
  }
  invisible(x)
}

check_exclusion <- function(ncdata, spec, model) {
  if (is.null(spec$nce)) {
    return(list(
      passed = NA,
      message = "No NCE specified; exclusion restriction cannot be checked."
    ))
  }

  predictors <- c(
    spec$nce,
    build_predictors(spec, include = c("exposure", "covariates"))
  )
  fit <- fit_model(spec, ncdata, spec$outcome, predictors, model)
  cs <- summary(fit)$coefficients

  if (!spec$nce %in% rownames(cs)) {
    return(list(
      passed = NA,
      message = "NCE coefficient not found in model; check model specification.",
      model_fit = fit
    ))
  }

  p_val <- cs[spec$nce, 4L]
  passed <- p_val >= 0.05
  msg <- if (passed) {
    sprintf(
      "NCE not significantly associated with outcome (p = %.3f).",
      p_val
    )
  } else {
    sprintf(
      "NCE is significantly associated with outcome (p = %.3f); exclusion restriction may be violated.",
      p_val
    )
  }

  list(passed = passed, message = msg, model_fit = fit)
}

check_u_comparability <- function(ncdata, spec, model) {
  if (is.null(spec$nce)) {
    return(list(
      passed = NA,
      message = "No NCE specified; U-comparability cannot be checked."
    ))
  }

  predictors <- c(
    spec$nce,
    build_predictors(spec, include = c("covariates"))
  )
  fit <- fit_model(spec, ncdata, spec$exposure, predictors, model)
  cs <- summary(fit)$coefficients

  if (!spec$nce %in% rownames(cs)) {
    return(list(
      passed = NA,
      message = "NCE coefficient not found in model; check model specification.",
      model_fit = fit
    ))
  }

  p_val <- cs[spec$nce, 4L]
  passed <- p_val < 0.05
  msg <- if (passed) {
    sprintf(
      "NCE is associated with primary exposure (p = %.3f), consistent with U-comparability.",
      p_val
    )
  } else {
    sprintf(
      "NCE is not associated with primary exposure (p = %.3f); U-comparability may not hold.",
      p_val
    )
  }

  list(passed = passed, message = msg, model_fit = fit)
}
