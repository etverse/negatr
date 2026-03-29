

# Correct for bias using negative controls

[**Source code**](https://github.com/etverse/negatr/tree/main/R/nc-correct.R#L38)

## Description

<code>nc_correct()</code> applies a bias correction method that uses
negative control variables to produce a bias-adjusted estimate of the
primary exposure-outcome association.

## Usage

<pre><code class='language-R'>nc_correct(ncdata, method = "diff_in_diff", model = nc_model(stats::lm), ...)
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
<code style="white-space: pre;">\[character(1)\]</code><br> Correction
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
passed to the specific correction method.
</td>
</tr>
</table>

## Details

Currently implemented methods:

<ul>
<li>

<code>“diff_in_diff”</code>: Difference-in-differences (simple
subtraction). Corrects the primary estimate by subtracting the negative
control association, under the equi-confounding assumption. Requires a
negative control outcome (<code>nco</code>).

</li>
</ul>

## Value

An <code>nc_correct_result()</code> object.

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
nc_correct(nd, method = "diff_in_diff")
```

    Negative control bias correction
      Method  : diff_in_diff 
      NC type : nco 
      Corrected estimate: -0.1535 
