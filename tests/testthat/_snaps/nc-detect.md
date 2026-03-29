# nc_detect() errors on non-nc_data input

    Code
      nc_detect(data.frame(x = 1), method = "null_test")
    Condition
      Error in `nc_detect()`:
      ! `ncdata` must be an `nc_data` object created by `nc_data()`.

# nc_detect() errors on non-nc_model model

    Code
      nc_detect(nd, model = list())
    Condition
      Error in `nc_detect()`:
      ! `model` must be an `nc_model` object created by `nc_model()`.

# nc_detect() errors on unsupported method

    Code
      nc_detect(nd, method = "not_a_method")
    Condition
      Error in `nc_detect()`:
      ! `method` must be one of "null_test", not "not_a_method".

