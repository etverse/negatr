#' Specify negative controls for an analysis
#'
#' `nc_spec()` declares the roles of variables in a negative control analysis:
#' the primary exposure, primary outcome, covariates, and one or both negative
#' controls (exposure and/or outcome).
#'
#' @param exposure `[character(1)]`\cr
#'   Name of the primary exposure column in `data`.
#' @param outcome `[character(1)]`\cr
#'   Name of the primary outcome column in `data`.
#' @param nce `[character(1) | NULL]`\cr
#'   Name of the negative control exposure column. Either `nce` or `nco`
#'   (or both) must be supplied.
#' @param nco `[character(1) | NULL]`\cr
#'   Name of the negative control outcome column. Either `nce` or `nco`
#'   (or both) must be supplied.
#' @param covariates `[character() | NULL]`\cr
#'   Names of measured covariate columns to adjust for.
#'
#' @return An object of class `nc_spec`.
#'
#' @export
#'
#' @examples
#' nc_spec(
#'   exposure = "A",
#'   outcome = "Y",
#'   nco = "W",
#'   covariates = c("age", "sex")
#' )
nc_spec <- function(
    exposure,
    outcome,
    nce = NULL,
    nco = NULL,
    covariates = NULL) {
  check_string(exposure)
  check_string(outcome)
  check_null_or_string(nce)
  check_null_or_string(nco)
  check_null_or_character(covariates)

  if (is.null(nce) && is.null(nco)) {
    rlang::abort("At least one of `nce` or `nco` must be supplied.")
  }

  structure(
    list(
      exposure = exposure,
      outcome = outcome,
      nce = nce,
      nco = nco,
      covariates = covariates
    ),
    class = "nc_spec"
  )
}

#' Prepare a negative control dataset
#'
#' `nc_data()` combines a data frame with an [nc_spec()] object, validates that
#' all declared columns are present, and returns an object ready to pass to
#' [nc_detect()] or [nc_correct()].
#'
#' @param data `[data.frame]`\cr
#'   The analysis dataset.
#' @param spec `[nc_spec]`\cr
#'   Variable specification created by [nc_spec()].
#'
#' @return An object of class `nc_data` (also a `data.frame`).
#'
#' @export
#'
#' @examples
#' df <- data.frame(A = rbinom(100, 1, 0.5), Y = rnorm(100), W = rnorm(100))
#' spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
#' nc_data(df, spec)
nc_data <- function(data, spec) {
  check_data_frame(data)
  if (!inherits(spec, "nc_spec")) {
    rlang::abort("`spec` must be an `nc_spec` object created by `nc_spec()`.")
  }

  required_cols <- c(spec$exposure, spec$outcome, spec$nce, spec$nco, spec$covariates)
  for (col in required_cols) {
    check_column_exists(data, col)
  }

  structure(
    data,
    spec = spec,
    class = c("nc_data", "data.frame")
  )
}

#' @export
print.nc_spec <- function(x, ...) {
  cat("Negative control specification\n")
  cat("  Exposure  :", x$exposure, "\n")
  cat("  Outcome   :", x$outcome, "\n")
  if (!is.null(x$nce)) cat("  NC Exposure :", x$nce, "\n")
  if (!is.null(x$nco)) cat("  NC Outcome  :", x$nco, "\n")
  if (!is.null(x$covariates)) {
    cat("  Covariates :", paste(x$covariates, collapse = ", "), "\n")
  }
  invisible(x)
}

#' @export
print.nc_data <- function(x, ...) {
  spec <- attr(x, "spec")
  cat("Negative control dataset [", nrow(x), "x", ncol(x), "]\n")
  print(spec)
  invisible(x)
}
