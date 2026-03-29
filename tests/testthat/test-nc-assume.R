make_nc_data_full <- function(seed = 1L, n = 200L) {
  set.seed(seed)
  df <- data.frame(
    A = rbinom(n, 1L, 0.5),
    Y = rnorm(n),
    Z = rbinom(n, 1L, 0.5),
    W = rnorm(n),
    age = rnorm(n)
  )
  spec <- nc_spec(
    exposure = "A", outcome = "Y",
    nce = "Z", nco = "W",
    covariates = "age"
  )
  nc_data(df, spec)
}

test_that("nc_assume() returns nc_assume_result", {
  nd <- make_nc_data_full()
  res <- nc_assume(nd)
  expect_s3_class(res, "nc_assume_result")
})

test_that("nc_assume() runs all checks by default", {
  nd <- make_nc_data_full()
  res <- nc_assume(nd)
  expect_named(res, c("exclusion", "u_comparability"))
})

test_that("nc_assume() runs selected checks only", {
  nd <- make_nc_data_full()
  res <- nc_assume(nd, checks = "exclusion")
  expect_named(res, "exclusion")
})

test_that("nc_assume() each check has required fields", {
  nd <- make_nc_data_full()
  res <- nc_assume(nd)
  for (nm in names(res)) {
    expect_true("passed" %in% names(res[[nm]]), info = nm)
    expect_true("message" %in% names(res[[nm]]), info = nm)
  }
})

test_that("nc_assume() exclusion returns NA when no NCE", {
  set.seed(1L)
  df <- data.frame(A = rbinom(100L, 1L, 0.5), Y = rnorm(100L), W = rnorm(100L))
  spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
  nd <- nc_data(df, spec)
  res <- nc_assume(nd, checks = "exclusion")
  expect_true(is.na(res$exclusion$passed))
})

test_that("nc_assume() u_comparability returns NA when no NCE", {
  set.seed(1L)
  df <- data.frame(A = rbinom(100L, 1L, 0.5), Y = rnorm(100L), W = rnorm(100L))
  spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
  nd <- nc_data(df, spec)
  res <- nc_assume(nd, checks = "u_comparability")
  expect_true(is.na(res$u_comparability$passed))
})

test_that("nc_assume() errors on unsupported check", {
  nd <- make_nc_data_full()
  expect_snapshot(nc_assume(nd, checks = "not_a_check"), error = TRUE)
})

test_that("nc_assume() errors on non-nc_data input", {
  expect_snapshot(
    nc_assume(data.frame(x = 1)),
    error = TRUE
  )
})

test_that("print.nc_assume_result() produces output", {
  nd <- make_nc_data_full()
  res <- nc_assume(nd)
  expect_output(print(res), "Negative control assumption checks")
})
