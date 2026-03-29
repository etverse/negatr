

# Specify a model for a negative control analysis

[**Source code**](https://github.com/etverse/negatr/tree/main/R/nc-model.R#L25)

## Description

<code>nc_model()</code> describes how to fit regression models within a
negative control analysis. It wraps a fitting function together with any
additional arguments, making the model specification portable and
inspectable.

## Usage

<pre><code class='language-R'>nc_model(fitter = stats::glm, ...)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="fitter">fitter</code>
</td>
<td>
<code style="white-space: pre;">\[function\]</code><br> The model
fitting function. Defaults to <code>stats::glm()</code>.
</td>
</tr>
<tr>
<td style="white-space: collapse; font-family: monospace; vertical-align: top">
<code id="...">…</code>
</td>
<td>
<code style="white-space: pre;">\[any\]</code><br> Additional arguments
forwarded to <code>fitter</code> (e.g. <code>family =
binomial()</code>).
</td>
</tr>
</table>

## Details

The <code>fitter</code> must be a function that accepts at minimum a
<code>formula</code> and <code>data</code> argument,
e.g. <code>stats::glm()</code>, <code>stats::lm()</code>, or a
compatible function from <code>mgcv</code> or <code>survival</code>.
Custom fitters are also accepted as long as they follow this convention.

## Value

An object of class <code>nc_model</code>.

## Examples

``` r
library("negatr")

nc_model()
```

    Negative control model
      Fitter: function (formula, family = gaussian, data, weights, subset,      na.action, start = NULL, etastart, mustart, offset, control = list(...),      model = TRUE, method = "glm.fit", x = FALSE, y = TRUE, singular.ok = TRUE,      contrasts = NULL, ...)  {     cal <- match.call()     if (is.character(family))          family <- get(family, mode = "function", envir = parent.frame())     if (is.function(family))          family <- family()     if (is.null(family$family)) {         print(family)         stop("'family' not recognized")     }     if (missing(data))          data <- environment(formula)     mf <- match.call(expand.dots = FALSE)     m <- match(c("formula", "data", "subset", "weights", "na.action",          "etastart", "mustart", "offset"), names(mf), 0L)     mf <- mf[c(1L, m)]     mf$drop.unused.levels <- TRUE     mf[[1L]] <- quote(stats::model.frame)     mf <- eval(mf, parent.frame())     if (identical(method, "model.frame"))          return(mf)     if (!is.character(method) && !is.function(method))          stop("invalid 'method' argument")     if (identical(method, "glm.fit"))          control <- do.call("glm.control", control)     mt <- attr(mf, "terms")     Y <- model.response(mf, "any")     if (length(dim(Y)) == 1L) {         nm <- rownames(Y)         dim(Y) <- NULL         if (!is.null(nm))              names(Y) <- nm     }     X <- if (!is.empty.model(mt))          model.matrix(mt, mf, contrasts)     else matrix(, NROW(Y), 0L)     weights <- as.vector(model.weights(mf))     if (!is.null(weights) && !is.numeric(weights))          stop("'weights' must be a numeric vector")     if (!is.null(weights) && any(weights < 0))          stop("negative weights not allowed")     offset <- as.vector(model.offset(mf))     if (!is.null(offset)) {         if (length(offset) != NROW(Y))              stop(gettextf("number of offsets is %d should equal %d (number of observations)",                  length(offset), NROW(Y)), domain = NA)     }     mustart <- model.extract(mf, "mustart")     etastart <- model.extract(mf, "etastart")     fit <- eval(call(if (is.function(method)) "method" else method,          x = X, y = Y, weights = weights, start = start, etastart = etastart,          mustart = mustart, offset = offset, family = family,          control = control, intercept = attr(mt, "intercept") >              0L, singular.ok = singular.ok))     if (length(offset) && attr(mt, "intercept") > 0L) {         fit2 <- eval(call(if (is.function(method)) "method" else method,              x = X[, "(Intercept)", drop = FALSE], y = Y, mustart = fit$fitted.values,              weights = weights, offset = offset, family = family,              control = control, intercept = TRUE))         if (!fit2$converged)              warning("fitting to calculate the null deviance did not converge -- increase 'maxit'?")         fit$null.deviance <- fit2$deviance     }     if (model)          fit$model <- mf     fit$na.action <- attr(mf, "na.action")     if (x)          fit$x <- X     if (!y)          fit$y <- NULL     structure(c(fit, list(call = cal, formula = formula, terms = mt,          data = data, offset = offset, control = control, method = method,          contrasts = attr(X, "contrasts"), xlevels = .getXlevels(mt,              mf))), class = c(fit$class, c("glm", "lm"))) } 

``` r
nc_model(fitter = stats::glm, family = stats::binomial())
```

    Negative control model
      Fitter: function (formula, family = gaussian, data, weights, subset,      na.action, start = NULL, etastart, mustart, offset, control = list(...),      model = TRUE, method = "glm.fit", x = FALSE, y = TRUE, singular.ok = TRUE,      contrasts = NULL, ...)  {     cal <- match.call()     if (is.character(family))          family <- get(family, mode = "function", envir = parent.frame())     if (is.function(family))          family <- family()     if (is.null(family$family)) {         print(family)         stop("'family' not recognized")     }     if (missing(data))          data <- environment(formula)     mf <- match.call(expand.dots = FALSE)     m <- match(c("formula", "data", "subset", "weights", "na.action",          "etastart", "mustart", "offset"), names(mf), 0L)     mf <- mf[c(1L, m)]     mf$drop.unused.levels <- TRUE     mf[[1L]] <- quote(stats::model.frame)     mf <- eval(mf, parent.frame())     if (identical(method, "model.frame"))          return(mf)     if (!is.character(method) && !is.function(method))          stop("invalid 'method' argument")     if (identical(method, "glm.fit"))          control <- do.call("glm.control", control)     mt <- attr(mf, "terms")     Y <- model.response(mf, "any")     if (length(dim(Y)) == 1L) {         nm <- rownames(Y)         dim(Y) <- NULL         if (!is.null(nm))              names(Y) <- nm     }     X <- if (!is.empty.model(mt))          model.matrix(mt, mf, contrasts)     else matrix(, NROW(Y), 0L)     weights <- as.vector(model.weights(mf))     if (!is.null(weights) && !is.numeric(weights))          stop("'weights' must be a numeric vector")     if (!is.null(weights) && any(weights < 0))          stop("negative weights not allowed")     offset <- as.vector(model.offset(mf))     if (!is.null(offset)) {         if (length(offset) != NROW(Y))              stop(gettextf("number of offsets is %d should equal %d (number of observations)",                  length(offset), NROW(Y)), domain = NA)     }     mustart <- model.extract(mf, "mustart")     etastart <- model.extract(mf, "etastart")     fit <- eval(call(if (is.function(method)) "method" else method,          x = X, y = Y, weights = weights, start = start, etastart = etastart,          mustart = mustart, offset = offset, family = family,          control = control, intercept = attr(mt, "intercept") >              0L, singular.ok = singular.ok))     if (length(offset) && attr(mt, "intercept") > 0L) {         fit2 <- eval(call(if (is.function(method)) "method" else method,              x = X[, "(Intercept)", drop = FALSE], y = Y, mustart = fit$fitted.values,              weights = weights, offset = offset, family = family,              control = control, intercept = TRUE))         if (!fit2$converged)              warning("fitting to calculate the null deviance did not converge -- increase 'maxit'?")         fit$null.deviance <- fit2$deviance     }     if (model)          fit$model <- mf     fit$na.action <- attr(mf, "na.action")     if (x)          fit$x <- X     if (!y)          fit$y <- NULL     structure(c(fit, list(call = cal, formula = formula, terms = mt,          data = data, offset = offset, control = control, method = method,          contrasts = attr(X, "contrasts"), xlevels = .getXlevels(mt,              mf))), class = c(fit$class, c("glm", "lm"))) } 
      Extra args: family 

``` r
nc_model(fitter = stats::lm)
```

    Negative control model
      Fitter: function (formula, data, subset, weights, na.action, method = "qr",      model = TRUE, x = FALSE, y = FALSE, qr = TRUE, singular.ok = TRUE,      contrasts = NULL, offset, ...)  {     ret.x <- x     ret.y <- y     cl <- match.call()     mf <- match.call(expand.dots = FALSE)     m <- match(c("formula", "data", "subset", "weights", "na.action",          "offset"), names(mf), 0L)     mf <- mf[c(1L, m)]     mf$drop.unused.levels <- TRUE     mf[[1L]] <- quote(stats::model.frame)     mf <- eval(mf, parent.frame())     if (method == "model.frame")          return(mf)     else if (method != "qr")          warning(gettextf("method = '%s' is not supported. Using 'qr'",              method), domain = NA)     mt <- attr(mf, "terms")     y <- model.response(mf, "numeric")     w <- as.vector(model.weights(mf))     if (!is.null(w) && !is.numeric(w))          stop("'weights' must be a numeric vector")     offset <- model.offset(mf)     mlm <- is.matrix(y)     ny <- if (mlm)          nrow(y)     else length(y)     if (!is.null(offset)) {         if (!mlm)              offset <- as.vector(offset)         if (NROW(offset) != ny)              stop(gettextf("number of offsets is %d, should equal %d (number of observations)",                  NROW(offset), ny), domain = NA)     }     if (is.empty.model(mt)) {         x <- NULL         z <- list(coefficients = if (mlm) matrix(NA_real_, 0,              ncol(y)) else numeric(), residuals = y, fitted.values = 0 *              y, weights = w, rank = 0L, df.residual = if (!is.null(w)) sum(w !=              0) else ny)         if (!is.null(offset)) {             z$fitted.values <- offset             z$residuals <- y - offset         }     }     else {         x <- model.matrix(mt, mf, contrasts)         z <- if (is.null(w))              lm.fit(x, y, offset = offset, singular.ok = singular.ok,                  ...)         else lm.wfit(x, y, w, offset = offset, singular.ok = singular.ok,              ...)     }     class(z) <- c(if (mlm) "mlm", "lm")     z$na.action <- attr(mf, "na.action")     z$offset <- offset     z$contrasts <- attr(x, "contrasts")     z$xlevels <- .getXlevels(mt, mf)     z$call <- cl     z$terms <- mt     if (model)          z$model <- mf     if (ret.x)          z$x <- x     if (ret.y)          z$y <- y     if (!qr)          z$qr <- NULL     z } 
