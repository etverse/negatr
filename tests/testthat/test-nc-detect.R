make_nc_data <- function(seed = 1L, n = 200L) {
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

test_that("nc_detect() null_test returns nc_detect_result", {
  nd <- make_nc_data()
  res <- nc_detect(nd, method = "null_test")
  expect_s3_class(res, "nc_detect_result")
  expect_equal(res$method, "null_test")
})

test_that("nc_detect() null_test uses nco by default when both present", {
  nd <- make_nc_data()
  res <- nc_detect(nd, method = "null_test")
  expect_equal(res$nc_type, "nco")
})

test_that("nc_detect() null_test uses nce when nco absent", {
  set.seed(1L)
  df <- data.frame(A = rbinom(100L, 1L, 0.5), Y = rnorm(100L), Z = rnorm(100L))
  spec <- nc_spec(exposure = "A", outcome = "Y", nce = "Z")
  nd <- nc_data(df, spec)
  res <- nc_detect(nd, method = "null_test")
  expect_equal(res$nc_type, "nce")
})

test_that("nc_detect() null_test returns numeric estimate", {
  nd <- make_nc_data()
  res <- nc_detect(nd, method = "null_test")
  expect_type(res$estimate, "double")
  expect_false(is.na(res$estimate))
})

test_that("nc_detect() null_test returns CI", {
  nd <- make_nc_data()
  res <- nc_detect(nd, method = "null_test")
  expect_named(res$ci, c("lower", "upper"))
  expect_true(res$ci[["lower"]] < res$ci[["upper"]])
})

test_that("nc_detect() errors on non-nc_data input", {
  expect_snapshot(
    nc_detect(data.frame(x = 1), method = "null_test"),
    error = TRUE
  )
})

test_that("nc_detect() errors on non-nc_model model", {
  nd <- make_nc_data()
  expect_snapshot(
    nc_detect(nd, model = list()),
    error = TRUE
  )
})

test_that("nc_detect() errors on unsupported method", {
  nd <- make_nc_data()
  expect_snapshot(
    nc_detect(nd, method = "not_a_method"),
    error = TRUE
  )
})

test_that("nc_detect() print produces output", {
  nd <- make_nc_data()
  res <- nc_detect(nd, method = "null_test")
  expect_output(print(res), "Negative control bias detection")
})
