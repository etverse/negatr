

# Create a correction result

[**Source code**](https://github.com/etverse/negatr/tree/main/R/nc-result.R#L103)

## Description

<code>nc_correct_result()</code> constructs the standard return value
for all <code>nc_correct()</code> methods. It captures the
bias-corrected effect estimate, its uncertainty, and supporting objects
for further inspection.

## Usage

<pre><code class='language-R'>nc_correct_result(
  estimate,
  se = NULL,
  ci = NULL,
  method,
  nc_type,
  model_fits = list(),
  call = NULL
)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="estimate">estimate</code>
</td>
<td>
<code style="white-space: pre;">\[numeric(1)\]</code><br> Bias-corrected
point estimate.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="se">se</code>
</td>
<td>
<code style="white-space: pre;">\[numeric(1) | NULL\]</code><br>
Standard error of the corrected estimate, or <code>NULL</code>.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="ci">ci</code>
</td>
<td>
<code style="white-space: pre;">\[numeric(2) | NULL\]</code><br> Named
numeric vector <code>c(lower = …, upper = …)</code>, or
<code>NULL</code>.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="method">method</code>
</td>
<td>
<code style="white-space: pre;">\[character(1)\]</code><br> Name of the
correction method used.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="nc_type">nc_type</code>
</td>
<td>
<code style="white-space: pre;">\[character(1)\]</code><br> Which
negative control(s) were used: <code>“nce”</code>, <code>“nco”</code>,
or <code>“both”</code>.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="model_fits">model_fits</code>
</td>
<td>
<code style="white-space: pre;">\[list\]</code><br> Named list of raw
fitted model objects.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="call">call</code>
</td>
<td>
<code style="white-space: pre;">\[call | NULL\]</code><br> The
user-level call that produced this result.
</td>
</tr>
</table>

## Value

An object of class <code>nc_correct_result</code>.
