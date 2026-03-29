

# Check assumptions for a negative control analysis

[**Source code**](https://github.com/etverse/negatr/tree/main/R/nc-assume.R#L49)

## Description

<code>nc_assume()</code> evaluates whether the dataset and specification
are consistent with core assumptions required by negative control
methods. Checks are performed heuristically (e.g. via regression tests)
and should be treated as diagnostic aids, not proofs.

## Usage

<pre><code class='language-R'>nc_assume(
  ncdata,
  checks = c("exclusion", "u_comparability"),
  model = nc_model(stats::lm),
  ...
)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="ncdata">ncdata</code>
</td>
<td>
<code style="white-space: pre;">\[nc_data\]</code><br> Dataset prepared
with <code>nc_data()</code>.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="checks">checks</code>
</td>
<td>
<code style="white-space: pre;">\[character()\]</code><br> Which
assumptions to check. Defaults to all available checks.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="model">model</code>
</td>
<td>
<code style="white-space: pre;">\[nc_model\]</code><br> Model
specification for regression-based checks. Defaults to OLS.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="...">…</code>
</td>
<td>
<code style="white-space: pre;">\[any\]</code><br> Reserved for future
use.
</td>
</tr>
</table>

## Details

Checks performed:

<ul>
<li>

<strong>Exclusion restriction</strong> (<code>“exclusion”</code>): Tests
whether the negative control exposure (NCE) is associated with the
primary outcome after adjusting for the primary exposure and covariates.
A significant association is evidence against the exclusion restriction.

</li>
<li>

<strong>U-comparability</strong> (<code>“u_comparability”</code>): Tests
whether the NCE is associated with the primary exposure. A significant
association is consistent with U-comparability: the NCE and the primary
exposure share the same unmeasured confounders.

</li>
</ul>

## Value

An object of class <code>nc_assume_result</code>: a named list where
each element corresponds to one check and contains
<code style="white-space: pre;">$passed</code>
(<code>TRUE</code>/<code>FALSE</code>/ <code>NA</code>),
<code style="white-space: pre;">$message</code>, and optionally
<code style="white-space: pre;">$model_fit</code>.

## Examples

``` r
library("negatr")

df <- data.frame(
  A = rbinom(200, 1, 0.5),
  Y = rnorm(200),
  Z = rbinom(200, 1, 0.5),
  W = rnorm(200),
  age = rnorm(200)
)
spec <- nc_spec(
  exposure = "A", outcome = "Y",
  nce = "Z", nco = "W",
  covariates = "age"
)
nd <- nc_data(df, spec)
nc_assume(nd)
```

    Negative control assumption checks
      [PASS] exclusion : NCE not significantly associated with outcome (p = 0.950). 
      [FAIL] u_comparability : NCE is not associated with primary exposure (p = 0.089); U-comparability may not hold. 
