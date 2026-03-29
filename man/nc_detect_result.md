

# Create a detection result

[**Source code**](https://github.com/etverse/negatr/tree/main/R/nc-result.R#L27)

## Description

<code>nc_detect_result()</code> constructs the standard return value for
all <code>nc_detect()</code> methods. It captures the estimated
association, its uncertainty, and the raw fitted model for further
inspection.

## Usage

<pre><code class='language-R'>nc_detect_result(
  estimate,
  se = NULL,
  ci = NULL,
  p_value = NULL,
  method,
  nc_type,
  model_fit,
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
<code style="white-space: pre;">\[numeric(1)\]</code><br> Point estimate
of the negative control association.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="se">se</code>
</td>
<td>
<code style="white-space: pre;">\[numeric(1) | NULL\]</code><br>
Standard error of the estimate, or <code>NULL</code> if not applicable.
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
<code id="p_value">p_value</code>
</td>
<td>
<code style="white-space: pre;">\[numeric(1) | NULL\]</code><br> P-value
for the null hypothesis that the association is zero, or
<code>NULL</code>.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="method">method</code>
</td>
<td>
<code style="white-space: pre;">\[character(1)\]</code><br> Name of the
detection method used.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="nc_type">nc_type</code>
</td>
<td>
<code style="white-space: pre;">\[character(1)\]</code><br> Which
negative control was used: <code>“nce”</code> or <code>“nco”</code>.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="model_fit">model_fit</code>
</td>
<td>
<code style="white-space: pre;">\[any\]</code><br> The raw fitted model
object (e.g. output of <code>stats::glm()</code>).
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

An object of class <code>nc_detect_result</code>.
