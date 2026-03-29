test_that("check_string accepts a single string", {
  expect_no_error(check_string("hello"))
})

test_that("check_string rejects non-strings", {
  expect_snapshot(check_string(1), error = TRUE)
  expect_snapshot(check_string(c("a", "b")), error = TRUE)
  expect_snapshot(check_string(NULL), error = TRUE)
})

test_that("check_formula accepts a formula", {
  expect_no_error(check_formula(y ~ x))
})

test_that("check_formula rejects non-formulas", {
  expect_snapshot(check_formula("y ~ x"), error = TRUE)
})

test_that("check_data_frame accepts a data frame", {
  expect_no_error(check_data_frame(data.frame(x = 1)))
})

test_that("check_data_frame rejects non-data-frames", {
  expect_snapshot(check_data_frame(list(x = 1)), error = TRUE)
})

test_that("check_column_exists accepts present columns", {
  df <- data.frame(x = 1, y = 2)
  expect_no_error(check_column_exists(df, "x"))
})

test_that("check_column_exists rejects missing columns", {
  df <- data.frame(x = 1)
  expect_snapshot(check_column_exists(df, "z"), error = TRUE)
})

test_that("check_choice accepts valid choices", {
  expect_no_error(check_choice("a", c("a", "b")))
})

test_that("check_choice rejects invalid choices", {
  expect_snapshot(check_choice("c", c("a", "b")), error = TRUE)
})

test_that("check_null_or_string accepts NULL or string", {
  expect_no_error(check_null_or_string(NULL))
  expect_no_error(check_null_or_string("ok"))
})

test_that("check_null_or_string rejects non-string non-NULL", {
  expect_snapshot(check_null_or_string(1L), error = TRUE)
})

test_that("check_null_or_character accepts NULL or character", {
  expect_no_error(check_null_or_character(NULL))
  expect_no_error(check_null_or_character(c("a", "b")))
})

test_that("check_null_or_character rejects non-character non-NULL", {
  expect_snapshot(check_null_or_character(1L), error = TRUE)
})
