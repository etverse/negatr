

# Detect bias using negative controls

[**Source code**](https://github.com/etverse/negatr/tree/main/R/nc-detect.R#L37)

## Description

<code>nc_detect()</code> tests for the presence of bias by estimating
the association between a negative control variable and the primary
outcome or exposure. A statistically or practically significant
association suggests the presence of unmeasured confounding, selection
bias, or measurement error.

## Usage

<pre><code class='language-R'>nc_detect(ncdata, method = "null_test", model = nc_model(stats::lm), ...)
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
<code id="method">method</code>
</td>
<td>
<code style="white-space: pre;">\[character(1)\]</code><br> Detection
method to use. See Details for available methods.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="model">model</code>
</td>
<td>
<code style="white-space: pre;">\[nc_model\]</code><br> Model
specification created with <code>nc_model()</code>. Defaults to OLS via
<code>stats::lm()</code>.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="...">…</code>
</td>
<td>
<code style="white-space: pre;">\[any\]</code><br> Additional arguments
passed to the specific detection method.
</td>
</tr>
</table>

## Details

Currently implemented methods:

<ul>
<li>

<code>“null_test”</code>: Null hypothesis test of the negative control
association (Wald test on the regression coefficient).

</li>
</ul>

## Value

An <code>nc_detect_result()</code> object.

## Examples

``` r
library("negatr")

df <- data.frame(
  A = rbinom(200, 1, 0.5),
  Y = rnorm(200),
  W = rnorm(200),
  age = rnorm(200)
)
spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W", covariates = "age")
nd <- nc_data(df, spec)
nc_detect(nd, method = "null_test")
```

    Negative control bias detection
      Method  : null_test 
      NC type : nco 
      Estimate: 0.0429 
      SE      : 0.0698 
      95% CI  : [ -0.0947 , 0.1804 ]
      P-value : 0.5396 
