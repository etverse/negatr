test_that("nc_model() constructs with defaults", {
  m <- nc_model()
  expect_s3_class(m, "nc_model")
  expect_identical(m$fitter, stats::glm)
  expect_length(m$fitter_args, 0L)
})

test_that("nc_model() stores extra arguments", {
  m <- nc_model(fitter = stats::glm, family = stats::binomial())
  expect_s3_class(m, "nc_model")
  expect_named(m$fitter_args, "family")
})

test_that("nc_model() accepts lm", {
  m <- nc_model(fitter = stats::lm)
  expect_identical(m$fitter, stats::lm)
})

test_that("nc_model() errors on non-function fitter", {
  expect_snapshot(nc_model(fitter = "lm"), error = TRUE)
})

test_that("print.nc_model() produces output", {
  m <- nc_model(fitter = stats::lm)
  expect_output(print(m), "Negative control model")
})

test_that("build_predictors() returns correct variables", {
  spec <- nc_spec(
    exposure = "A", outcome = "Y",
    nce = "Z", nco = "W",
    covariates = c("age", "sex")
  )
  expect_equal(
    build_predictors(spec, include = c("exposure", "covariates")),
    c("A", "age", "sex")
  )
  expect_equal(
    build_predictors(spec, include = c("nce", "nco")),
    c("Z", "W")
  )
  expect_equal(
    build_predictors(spec, include = c("exposure", "covariates"), exclude = "A"),
    c("age", "sex")
  )
})

test_that("fit_model() fits a linear model", {
  df <- data.frame(Y = rnorm(50), A = rnorm(50), age = rnorm(50))
  spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
  m <- nc_model(fitter = stats::lm)
  fit <- fit_model(spec, df, "Y", c("A", "age"), m)
  expect_true(inherits(fit, "lm"))
  expect_true("A" %in% names(stats::coef(fit)))
})
