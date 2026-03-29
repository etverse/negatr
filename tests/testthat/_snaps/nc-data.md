# nc_spec() errors when neither nce nor nco supplied

    Code
      nc_spec(exposure = "A", outcome = "Y")
    Condition
      Error in `nc_spec()`:
      ! At least one of `nce` or `nco` must be supplied.

# nc_spec() errors on bad input types

    Code
      nc_spec(exposure = 1, outcome = "Y", nco = "W")
    Condition
      Error in `nc_spec()`:
      ! `exposure` must be a single string, not numeric.

---

    Code
      nc_spec(exposure = "A", outcome = 1, nco = "W")
    Condition
      Error in `nc_spec()`:
      ! `outcome` must be a single string, not numeric.

---

    Code
      nc_spec(exposure = "A", outcome = "Y", nco = 1)
    Condition
      Error in `nc_spec()`:
      ! `nco` must be a single string, not numeric.

# nc_data() errors on missing column

    Code
      nc_data(df, spec)
    Condition
      Error in `nc_data()`:
      ! Column `W` not found in data.

# nc_data() errors on non-data-frame

    Code
      nc_data(list(A = 1), spec)
    Condition
      Error in `nc_data()`:
      ! `data` must be a data frame, not list.

# nc_data() errors on non-nc_spec

    Code
      nc_data(df, list(exposure = "A"))
    Condition
      Error in `nc_data()`:
      ! `spec` must be an `nc_spec` object created by `nc_spec()`.

