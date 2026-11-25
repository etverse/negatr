# negatr roadmap

negatr will hold the etverse methods that use observed negative-control exposures or outcomes to detect and correct bias, proximal causal inference included. The code now in the repository predates the [etverse design](https://etverse.github.io/design.html) and is replaced by a rebuild that follows the design from its first commit. Each item's status is in the [issues](https://github.com/etverse/negatr/issues), not in this file.

## 0.1.0

The first release is the rebuild. Its work is the [0.1.0 milestone](https://github.com/etverse/negatr/milestone/1), which today holds the bug in the current negative-control null tests ([#2](https://github.com/etverse/negatr/issues/2)); the rebuilt tests close it.

## Methods

- The candidate methods: the negative-control null test, restriction and stratification, difference-in-differences, proximal causal inference, negative-control mediators and negative controls in Mendelian randomisation ([#3](https://github.com/etverse/negatr/issues/3)). Which of them the rebuild offers is decided from the literature before its first code.
- Whether to organise the methods by the bias they address ([#4](https://github.com/etverse/negatr/issues/4)).

## Not planned here

- Bias analysis that needs no negative-control data, such as E-values: [biasetr](https://github.com/etverse/biasetr).
- Pooling across multiple imputations, which negatr calls from causatr.
