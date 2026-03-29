# check_string rejects non-strings

    Code
      check_string(1)
    Condition
      Error:
      ! `1` must be a single string, not numeric.

---

    Code
      check_string(c("a", "b"))
    Condition
      Error:
      ! `c("a", "b")` must be a single string, not character.

---

    Code
      check_string(NULL)
    Condition
      Error:
      ! `NULL` must be a single string, not NULL.

# check_formula rejects non-formulas

    Code
      check_formula("y ~ x")
    Condition
      Error:
      ! `"y ~ x"` must be a formula, not character.

# check_data_frame rejects non-data-frames

    Code
      check_data_frame(list(x = 1))
    Condition
      Error:
      ! `list(x = 1)` must be a data frame, not list.

# check_column_exists rejects missing columns

    Code
      check_column_exists(df, "z")
    Condition
      Error:
      ! Column `z` not found in data.

# check_choice rejects invalid choices

    Code
      check_choice("c", c("a", "b"))
    Condition
      Error:
      ! `"c"` must be one of "a", "b", not "c".

# check_null_or_string rejects non-string non-NULL

    Code
      check_null_or_string(1L)
    Condition
      Error:
      ! `1L` must be a single string, not integer.

# check_null_or_character rejects non-character non-NULL

    Code
      check_null_or_character(1L)
    Condition
      Error:
      ! `1L` must be a character vector or NULL, not integer.

