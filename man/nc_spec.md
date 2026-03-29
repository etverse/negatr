

# Specify negative controls for an analysis

[**Source code**](https://github.com/etverse/negatr/tree/main/R/nc-data.R#L31)

## Description

<code>nc_spec()</code> declares the roles of variables in a negative
control analysis: the primary exposure, primary outcome, covariates, and
one or both negative controls (exposure and/or outcome).

## Usage

<pre><code class='language-R'>nc_spec(exposure, outcome, nce = NULL, nco = NULL, covariates = NULL)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="exposure">exposure</code>
</td>
<td>
<code style="white-space: pre;">\[character(1)\]</code><br> Name of the
primary exposure column in <code>data</code>.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="outcome">outcome</code>
</td>
<td>
<code style="white-space: pre;">\[character(1)\]</code><br> Name of the
primary outcome column in <code>data</code>.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="nce">nce</code>
</td>
<td>
<code style="white-space: pre;">\[character(1) | NULL\]</code><br> Name
of the negative control exposure column. Either <code>nce</code> or
<code>nco</code> (or both) must be supplied.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="nco">nco</code>
</td>
<td>
<code style="white-space: pre;">\[character(1) | NULL\]</code><br> Name
of the negative control outcome column. Either <code>nce</code> or
<code>nco</code> (or both) must be supplied.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="covariates">covariates</code>
</td>
<td>
<code style="white-space: pre;">\[character() | NULL\]</code><br> Names
of measured covariate columns to adjust for.
</td>
</tr>
</table>

## Value

An object of class <code>nc_spec</code>.

## Examples

``` r
library("negatr")

nc_spec(
  exposure = "A",
  outcome = "Y",
  nco = "W",
  covariates = c("age", "sex")
)
```

    Negative control specification
      Exposure  : A 
      Outcome   : Y 
      NC Outcome  : W 
      Covariates : age, sex 
