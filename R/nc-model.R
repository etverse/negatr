#' Specify a model for a negative control analysis
#'
#' `nc_model()` describes how to fit regression models within a negative
#' control analysis. It wraps a fitting function together with any additional
#' arguments, making the model specification portable and inspectable.
#'
#' The `fitter` must be a function that accepts at minimum a `formula` and
#' `data` argument, e.g. [stats::glm()], [stats::lm()], or a compatible
#' function from `mgcv` or `survival`. Custom fitters are also accepted as long
#' as they follow this convention.
#'
#' @param fitter `[function]`\cr
#'   The model fitting function. Defaults to [stats::glm()].
#' @param ... `[any]`\cr
#'   Additional arguments forwarded to `fitter` (e.g. `family = binomial()`).
#'
#' @return An object of class `nc_model`.
#'
#' @export
#'
#' @examples
#' nc_model()
#' nc_model(fitter = stats::glm, family = stats::binomial())
#' nc_model(fitter = stats::lm)
nc_model <- function(fitter = stats::glm, ...) {
  if (!is.function(fitter)) {
    rlang::abort("`fitter` must be a function.")
  }

  structure(
    list(
      fitter = fitter,
      fitter_args = rlang::list2(...)
    ),
    class = "nc_model"
  )
}

#' @export
print.nc_model <- function(x, ...) {
  fitter_name <- tryCatch(
    deparse(substitute(x$fitter)),
    error = function(e) "<unknown>"
  )
  cat("Negative control model\n")
  cat("  Fitter:", format(x$fitter), "\n")
  if (length(x$fitter_args) > 0L) {
    cat("  Extra args:", paste(names(x$fitter_args), collapse = ", "), "\n")
  }
  invisible(x)
}

fit_model <- function(spec, data, response, predictors, model) {
  formula <- stats::as.formula(
    paste(response, "~", paste(predictors, collapse = " + "))
  )
  args <- c(list(formula = formula, data = data), model$fitter_args)
  do.call(model$fitter, args)
}

build_predictors <- function(
  spec,
  include = c("exposure", "nce", "nco", "covariates"),
  exclude = NULL
) {
  vars <- character(0L)
  if ("exposure" %in% include && !is.null(spec$exposure)) {
    vars <- c(vars, spec$exposure)
  }
  if ("nce" %in% include && !is.null(spec$nce)) {
    vars <- c(vars, spec$nce)
  }
  if ("nco" %in% include && !is.null(spec$nco)) {
    vars <- c(vars, spec$nco)
  }
  if ("covariates" %in% include && !is.null(spec$covariates)) {
    vars <- c(vars, spec$covariates)
  }
  setdiff(vars, exclude)
}
