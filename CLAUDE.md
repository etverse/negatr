# negatr

negatr will hold the etverse methods that use observed negative-control exposures or outcomes to detect and correct bias, proximal causal inference included. The etverse design (https://etverse.github.io/design.html) fixes what negatr owns, its fit verb `negat()`, and that its corrections are `contrast()` methods and its assumption checks `diagnose()` methods on causatr's generics.

The code now in `R/` predates the design and will be replaced by a rebuild that follows the design from its first commit. Do not extend or fix it; work on negatr starts with that rebuild.

## Commands

The `Makefile` has `make document`, `make test`, `make check`, `make format` (Air), `make lint` and `make site` (altdoc).

## Planning files

`METHODS.md` lists candidate methods and `DOUBTS.md` the open design questions.
