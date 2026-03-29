check_string <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!rlang::is_string(x)) {
    rlang::abort(
      paste0("`", arg, "` must be a single string, not ", class(x)[[1L]], "."),
      call = call
    )
  }
  invisible(x)
}

check_formula <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!inherits(x, "formula")) {
    rlang::abort(
      paste0("`", arg, "` must be a formula, not ", class(x)[[1L]], "."),
      call = call
    )
  }
  invisible(x)
}

check_data_frame <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is.data.frame(x)) {
    rlang::abort(
      paste0("`", arg, "` must be a data frame, not ", class(x)[[1L]], "."),
      call = call
    )
  }
  invisible(x)
}

check_column_exists <- function(data, col, arg = rlang::caller_arg(col), call = rlang::caller_env()) {
  if (!col %in% names(data)) {
    rlang::abort(
      paste0("Column `", col, "` not found in data."),
      call = call
    )
  }
  invisible(col)
}

check_choice <- function(x, choices, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!x %in% choices) {
    rlang::abort(
      paste0(
        "`", arg, "` must be one of ",
        paste0('"', choices, '"', collapse = ", "),
        ", not \"", x, "\"."
      ),
      call = call
    )
  }
  invisible(x)
}

check_null_or_string <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is.null(x)) check_string(x, arg = arg, call = call)
  invisible(x)
}

check_null_or_character <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is.null(x) && !is.character(x)) {
    rlang::abort(
      paste0("`", arg, "` must be a character vector or NULL, not ", class(x)[[1L]], "."),
      call = call
    )
  }
  invisible(x)
}
