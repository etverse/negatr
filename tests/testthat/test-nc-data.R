test_that("nc_spec() constructs correctly", {
  spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
  expect_s3_class(spec, "nc_spec")
  expect_equal(spec$exposure, "A")
  expect_equal(spec$outcome, "Y")
  expect_null(spec$nce)
  expect_equal(spec$nco, "W")
  expect_null(spec$covariates)
})

test_that("nc_spec() with nce only works", {
  spec <- nc_spec(exposure = "A", outcome = "Y", nce = "Z")
  expect_s3_class(spec, "nc_spec")
  expect_equal(spec$nce, "Z")
  expect_null(spec$nco)
})

test_that("nc_spec() with both nc works", {
  spec <- nc_spec(exposure = "A", outcome = "Y", nce = "Z", nco = "W")
  expect_equal(spec$nce, "Z")
  expect_equal(spec$nco, "W")
})

test_that("nc_spec() with covariates works", {
  spec <- nc_spec(
    exposure = "A",
    outcome = "Y",
    nco = "W",
    covariates = c("age", "sex")
  )
  expect_equal(spec$covariates, c("age", "sex"))
})

test_that("nc_spec() errors when neither nce nor nco supplied", {
  expect_snapshot(
    nc_spec(exposure = "A", outcome = "Y"),
    error = TRUE
  )
})

test_that("nc_spec() errors on bad input types", {
  expect_snapshot(nc_spec(exposure = 1, outcome = "Y", nco = "W"), error = TRUE)
  expect_snapshot(nc_spec(exposure = "A", outcome = 1, nco = "W"), error = TRUE)
  expect_snapshot(nc_spec(exposure = "A", outcome = "Y", nco = 1), error = TRUE)
})

test_that("print.nc_spec() produces output", {
  spec <- nc_spec(
    exposure = "A",
    outcome = "Y",
    nce = "Z",
    nco = "W",
    covariates = "age"
  )
  expect_output(print(spec), "Negative control specification")
  expect_output(print(spec), "NC Exposure")
  expect_output(print(spec), "NC Outcome")
  expect_output(print(spec), "Covariates")
})

test_that("nc_data() constructs correctly", {
  df <- data.frame(A = 1, Y = 2, W = 3)
  spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
  nd <- nc_data(df, spec)
  expect_s3_class(nd, "nc_data")
  expect_s3_class(nd, "data.frame")
  expect_identical(attr(nd, "spec"), spec)
})

test_that("nc_data() errors on missing column", {
  df <- data.frame(A = 1, Y = 2)
  spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
  expect_snapshot(nc_data(df, spec), error = TRUE)
})

test_that("nc_data() errors on non-data-frame", {
  spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
  expect_snapshot(nc_data(list(A = 1), spec), error = TRUE)
})

test_that("nc_data() errors on non-nc_spec", {
  df <- data.frame(A = 1, Y = 2, W = 3)
  expect_snapshot(nc_data(df, list(exposure = "A")), error = TRUE)
})

test_that("print.nc_data() produces output", {
  df <- data.frame(A = 1, Y = 2, W = 3)
  spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
  nd <- nc_data(df, spec)
  expect_output(print(nd), "Negative control dataset")
})
