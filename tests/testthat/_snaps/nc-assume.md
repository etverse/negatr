# nc_assume() errors on unsupported check

    Code
      nc_assume(nd, checks = "not_a_check")
    Condition
      Error in `nc_assume()`:
      ! `ch` must be one of "exclusion", "u_comparability", not "not_a_check".

# nc_assume() errors on non-nc_data input

    Code
      nc_assume(data.frame(x = 1))
    Condition
      Error in `nc_assume()`:
      ! `ncdata` must be an `nc_data` object created by `nc_data()`.

