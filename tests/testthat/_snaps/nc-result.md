# nc_detect_result() errors on bad nc_type

    Code
      nc_detect_result(estimate = 0.1, method = "null_test", nc_type = "bad",
        model_fit = NULL)
    Condition
      Error in `nc_detect_result()`:
      ! `nc_type` must be one of "nce", "nco", not "bad".

# nc_correct_result() errors on bad nc_type

    Code
      nc_correct_result(estimate = 0.1, method = "diff_in_diff", nc_type = "bad")
    Condition
      Error in `nc_correct_result()`:
      ! `nc_type` must be one of "nce", "nco", "both", not "bad".

