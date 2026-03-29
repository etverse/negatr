

# Prepare a negative control dataset

[**Source code**](https://github.com/etverse/negatr/tree/main/R/nc-data.R#L79)

## Description

<code>nc_data()</code> combines a data frame with an
<code>nc_spec()</code> object, validates that all declared columns are
present, and returns an object ready to pass to <code>nc_detect()</code>
or <code>nc_correct()</code>.

## Usage

<pre><code class='language-R'>nc_data(data, spec)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="data">data</code>
</td>
<td>
<code style="white-space: pre;">\[data.frame\]</code><br> The analysis
dataset.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="spec">spec</code>
</td>
<td>
<code style="white-space: pre;">\[nc_spec\]</code><br> Variable
specification created by <code>nc_spec()</code>.
</td>
</tr>
</table>

## Value

An object of class <code>nc_data</code> (also a
<code>data.frame</code>).

## Examples

``` r
library("negatr")

df <- data.frame(A = rbinom(100, 1, 0.5), Y = rnorm(100), W = rnorm(100))
spec <- nc_spec(exposure = "A", outcome = "Y", nco = "W")
nc_data(df, spec)
```

    Negative control dataset [ 100 x 3 ]
    Negative control specification
      Exposure  : A 
      Outcome   : Y 
      NC Outcome  : W 
