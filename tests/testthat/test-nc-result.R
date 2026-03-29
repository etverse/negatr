test_that("nc_detect_result() constructs correctly", {
  r <- nc_detect_result(
    estimate = 0.1,
    se = 0.05,
    ci = c(lower = 0.0, upper = 0.2),
    p_value = 0.04,
    method = "null_test",
    nc_type = "nco",
    model_fit = NULL
  )
  expect_s3_class(r, "nc_detect_result")
  expect_equal(r$estimate, 0.1)
  expect_equal(r$method, "null_test")
  expect_equal(r$nc_type, "nco")
})

test_that("nc_detect_result() errors on bad nc_type", {
  expect_snapshot(
    nc_detect_result(
      estimate = 0.1,
      method = "null_test",
      nc_type = "bad",
      model_fit = NULL
    ),
    error = TRUE
  )
})

test_that("print.nc_detect_result() produces output", {
  r <- nc_detect_result(
    estimate = 0.1,
    se = 0.05,
    ci = c(lower = 0.0, upper = 0.2),
    p_value = 0.04,
    method = "null_test",
    nc_type = "nco",
    model_fit = NULL
  )
  expect_output(print(r), "Negative control bias detection")
  expect_output(print(r), "null_test")
  expect_output(print(r), "0.1")
})

test_that("nc_correct_result() constructs correctly", {
  r <- nc_correct_result(
    estimate = 0.3,
    se = 0.1,
    ci = c(lower = 0.1, upper = 0.5),
    method = "diff_in_diff",
    nc_type = "nco"
  )
  expect_s3_class(r, "nc_correct_result")
  expect_equal(r$estimate, 0.3)
  expect_equal(r$method, "diff_in_diff")
  expect_equal(r$nc_type, "nco")
})

test_that("nc_correct_result() errors on bad nc_type", {
  expect_snapshot(
    nc_correct_result(
      estimate = 0.1,
      method = "diff_in_diff",
      nc_type = "bad"
    ),
    error = TRUE
  )
})

test_that("print.nc_correct_result() produces output", {
  r <- nc_correct_result(
    estimate = 0.3,
    se = 0.1,
    ci = c(lower = 0.1, upper = 0.5),
    method = "diff_in_diff",
    nc_type = "nco"
  )
  expect_output(print(r), "Negative control bias correction")
  expect_output(print(r), "diff_in_diff")
  expect_output(print(r), "0.3")
})
