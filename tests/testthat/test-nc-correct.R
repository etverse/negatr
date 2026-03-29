make_nc_data <- function(seed = 1L, n = 200L) {
  set.seed(seed)
  df <- data.frame(
    A = rbinom(n, 1L, 0.5),
    Y = rnorm(n),
    W = rnorm(n),
    age = rnorm(n)
  )
  spec <- nc_spec(
    exposure = "A", outcome = "Y",
    nco = "W", covariates = "age"
  )
  nc_data(df, spec)
}

test_that("nc_correct() diff_in_diff returns nc_correct_result", {
  nd <- make_nc_data()
  res <- nc_correct(nd, method = "diff_in_diff")
  expect_s3_class(res, "nc_correct_result")
  expect_equal(res$method, "diff_in_diff")
  expect_equal(res$nc_type, "nco")
})

test_that("nc_correct() diff_in_diff returns numeric estimate", {
  nd <- make_nc_data()
  res <- nc_correct(nd, method = "diff_in_diff")
  expect_type(res$estimate, "double")
  expect_false(is.na(res$estimate))
})

test_that("nc_correct() diff_in_diff stores both model fits", {
  nd <- make_nc_data()
  res <- nc_correct(nd, method = "diff_in_diff")
  expect_named(res$model_fits, c("primary", "nco"))
  expect_true(inherits(res$model_fits$primary, "lm"))
  expect_true(inherits(res$model_fits$nco, "lm"))
})

test_that("nc_correct() diff_in_diff estimate equals manual calculation", {
  set.seed(42L)
  n <- 200L
  df <- data.frame(
    A = rbinom(n, 1L, 0.5),
    Y = rnorm(n),
    W = rnorm(n)
  )
  spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
  nd <- nc_data(df, spec)
  m <- nc_model(fitter = stats::lm)

  res <- nc_correct(nd, method = "diff_in_diff", model = m)

  beta_y <- stats::coef(stats::lm(Y ~ A, data = df))[["A"]]
  beta_w <- stats::coef(stats::lm(W ~ A, data = df))[["A"]]
  expect_equal(res$estimate, beta_y - beta_w, tolerance = 1e-10)
})

test_that("nc_correct() diff_in_diff errors without nco", {
  set.seed(1L)
  df <- data.frame(A = rbinom(100L, 1L, 0.5), Y = rnorm(100L), Z = rnorm(100L))
  spec <- nc_spec(exposure = "A", outcome = "Y", nce = "Z")
  nd <- nc_data(df, spec)
  expect_snapshot(nc_correct(nd, method = "diff_in_diff"), error = TRUE)
})

test_that("nc_correct() errors on non-nc_data input", {
  expect_snapshot(
    nc_correct(data.frame(x = 1), method = "diff_in_diff"),
    error = TRUE
  )
})

test_that("nc_correct() errors on non-nc_model model", {
  nd <- make_nc_data()
  expect_snapshot(
    nc_correct(nd, model = list()),
    error = TRUE
  )
})

test_that("nc_correct() errors on unsupported method", {
  nd <- make_nc_data()
  expect_snapshot(
    nc_correct(nd, method = "not_a_method"),
    error = TRUE
  )
})

test_that("nc_correct() print produces output", {
  nd <- make_nc_data()
  res <- nc_correct(nd, method = "diff_in_diff")
  expect_output(print(res), "Negative control bias correction")
})
