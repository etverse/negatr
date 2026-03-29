#' Create a detection result
#'
#' `nc_detect_result()` constructs the standard return value for all
#' [nc_detect()] methods. It captures the estimated association, its
#' uncertainty, and the raw fitted model for further inspection.
#'
#' @param estimate `[numeric(1)]`\cr
#'   Point estimate of the negative control association.
#' @param se `[numeric(1) | NULL]`\cr
#'   Standard error of the estimate, or `NULL` if not applicable.
#' @param ci `[numeric(2) | NULL]`\cr
#'   Named numeric vector `c(lower = ..., upper = ...)`, or `NULL`.
#' @param p_value `[numeric(1) | NULL]`\cr
#'   P-value for the null hypothesis that the association is zero, or `NULL`.
#' @param method `[character(1)]`\cr
#'   Name of the detection method used.
#' @param nc_type `[character(1)]`\cr
#'   Which negative control was used: `"nce"` or `"nco"`.
#' @param model_fit `[any]`\cr
#'   The raw fitted model object (e.g. output of [stats::glm()]).
#' @param call `[call | NULL]`\cr
#'   The user-level call that produced this result.
#'
#' @return An object of class `nc_detect_result`.
#'
#' @export
nc_detect_result <- function(
    estimate,
    se = NULL,
    ci = NULL,
    p_value = NULL,
    method,
    nc_type,
    model_fit,
    call = NULL) {
  check_string(method)
  check_choice(nc_type, c("nce", "nco"))

  structure(
    list(
      estimate = estimate,
      se = se,
      ci = ci,
      p_value = p_value,
      method = method,
      nc_type = nc_type,
      model_fit = model_fit,
      call = call
    ),
    class = "nc_detect_result"
  )
}

#' @export
print.nc_detect_result <- function(x, ...) {
  cat("Negative control bias detection\n")
  cat("  Method  :", x$method, "\n")
  cat("  NC type :", x$nc_type, "\n")
  cat("  Estimate:", format(round(x$estimate, 4L)), "\n")
  if (!is.null(x$se)) cat("  SE      :", format(round(x$se, 4L)), "\n")
  if (!is.null(x$ci)) {
    cat(
      "  95% CI  : [",
      format(round(x$ci[["lower"]], 4L)), ",",
      format(round(x$ci[["upper"]], 4L)), "]\n"
    )
  }
  if (!is.null(x$p_value)) cat("  P-value :", format(round(x$p_value, 4L)), "\n")
  invisible(x)
}

#' Create a correction result
#'
#' `nc_correct_result()` constructs the standard return value for all
#' [nc_correct()] methods. It captures the bias-corrected effect estimate,
#' its uncertainty, and supporting objects for further inspection.
#'
#' @param estimate `[numeric(1)]`\cr
#'   Bias-corrected point estimate.
#' @param se `[numeric(1) | NULL]`\cr
#'   Standard error of the corrected estimate, or `NULL`.
#' @param ci `[numeric(2) | NULL]`\cr
#'   Named numeric vector `c(lower = ..., upper = ...)`, or `NULL`.
#' @param method `[character(1)]`\cr
#'   Name of the correction method used.
#' @param nc_type `[character(1)]`\cr
#'   Which negative control(s) were used: `"nce"`, `"nco"`, or `"both"`.
#' @param model_fits `[list]`\cr
#'   Named list of raw fitted model objects.
#' @param call `[call | NULL]`\cr
#'   The user-level call that produced this result.
#'
#' @return An object of class `nc_correct_result`.
#'
#' @export
nc_correct_result <- function(
    estimate,
    se = NULL,
    ci = NULL,
    method,
    nc_type,
    model_fits = list(),
    call = NULL) {
  check_string(method)
  check_choice(nc_type, c("nce", "nco", "both"))

  structure(
    list(
      estimate = estimate,
      se = se,
      ci = ci,
      method = method,
      nc_type = nc_type,
      model_fits = model_fits,
      call = call
    ),
    class = "nc_correct_result"
  )
}

#' @export
print.nc_correct_result <- function(x, ...) {
  cat("Negative control bias correction\n")
  cat("  Method  :", x$method, "\n")
  cat("  NC type :", x$nc_type, "\n")
  cat("  Corrected estimate:", format(round(x$estimate, 4L)), "\n")
  if (!is.null(x$se)) cat("  SE      :", format(round(x$se, 4L)), "\n")
  if (!is.null(x$ci)) {
    cat(
      "  95% CI  : [",
      format(round(x$ci[["lower"]], 4L)), ",",
      format(round(x$ci[["upper"]], 4L)), "]\n"
    )
  }
  invisible(x)
}
