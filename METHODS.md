# Summary of Methods

Notation:

- _A_ is the primary exposure.
- _X_ is a vector of measured confounders.
- _U_ is a vector of unmeasured confounders.
- _Y_ is the primary outcome.
- _Z_ is the negative control exposure.
- _W_ is the negative control outcome.

## Simple detection methods

### Null-hypothesis testing

> Formal assessment of whether the negative control association is statistically significant.

- Key assumption: _U_-comparability. The unmeasured confounders _U_ of _A_-_Y_ are the same to those of _A_-_W_ and _Z_-_Y_.
- When evaluating _Z_-_Y_, we need to adjust for _A_ (possibility of _Z_-_A_ $\rightarrow$ _Y_).
- Example: Wald test of the coefficient of the negative control exposure in a regression model.

References:

- [x] Shi, X., Miao, W. & Tchetgen, E.T. A Selective Review of Negative Control Methods in Epidemiology. Curr Epidemiol Rep 7, 190–202 (2020). https://doi.org/10.1007/s40471-020-00243-4
- [x] Lipsitch, Marc, Tchetgen Tchetgen, Eric, Cohen, Ted. Negative Controls: A Tool for Detecting Confounding and Bias in Observational Studies. Epidemiology 21(3):p 383-388, May 2010. https://doi.org/10.1097/EDE.0b013e3181d61eeb
- [ ] Levintow SN, Nielson CM, Hernandez RK, et al. Pragmatic considerations for negative control outcome studies to guide non-randomized comparative analyses: A narrative review. Pharmacoepidemiol Drug Saf. 2023; 32(6): 599-606. https://doi.org/10.1002/pds.5623
- [x] Arnold, Benjamin F., Ercumen, Ayse, Benjamin-Chung, Jade, Colford, John M. Jr. Brief Report: Negative Controls to Detect Selection Bias and Measurement Bias in Epidemiologic Studies. Epidemiology 27(5):p 637-641, September 2016. https://doi.org/10.1097/EDE.0000000000000504

## Restrictive analytical methods

### Restriction or stratification

> Restriction of the analytical method to subgroup of the population where the negative control association is null.

References:

- [ ] Chase D Latour, Megan Delgado, I-Hsuan Su, Catherine Wiener, Clement O Acheampong, Charles Poole, Jessie K Edwards, Kenneth Quinto, Til Stürmer, Jennifer L Lund, Jie Li, Nahleen Lopez, John Concato, Michele Jonsson Funk. Use of sensitivity analyses to assess uncontrolled confounding from unmeasured variables in observational, active comparator pharmacoepidemiologic studies: a systematic review. American Journal of Epidemiology, Volume 194, Issue 2, February 2025, Pages 524–535. https://doi.org/10.1093/aje/kwae234
- [ ] Gutierrez, S., Glymour, M.M. & Smith, G.D. Evidence triangulation in health research. Eur J Epidemiol 40, 743–757 (2025). https://doi.org/10.1007/s10654-024-01194-6

## Simple bias adjustment methods

### Difference-in-differences

References:

- [ ]
