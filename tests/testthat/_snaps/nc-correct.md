# nc_correct() diff_in_diff errors without nco

    Code
      nc_correct(nd, method = "diff_in_diff")
    Condition
      Error in `nc_correct()`:
      ! The `diff_in_diff` method requires a negative control outcome (`nco`).

# nc_correct() errors on non-nc_data input

    Code
      nc_correct(data.frame(x = 1), method = "diff_in_diff")
    Condition
      Error in `nc_correct()`:
      ! `ncdata` must be an `nc_data` object created by `nc_data()`.

# nc_correct() errors on non-nc_model model

    Code
      nc_correct(nd, model = list())
    Condition
      Error in `nc_correct()`:
      ! `model` must be an `nc_model` object created by `nc_model()`.

# nc_correct() errors on unsupported method

    Code
      nc_correct(nd, method = "not_a_method")
    Condition
      Error in `nc_correct()`:
      ! `method` must be one of "diff_in_diff", not "not_a_method".

