# digiRhythm-computational-audit
R scripts accompanying a computational audit of the digiRhythm R package, focusing on rolling-window calculations, spectral frequency selection, and rhythmicity indices.

# Computational Audit of the digiRhythm R Package
## Overview

This repository contains the R scripts accompanying the study: Computational audit of the digiRhythm R package for analysing animal behavioural rhythms.
The scripts document the computational tests conducted to examine the implementation of the `dfc()` and `lomb_scargle_periodogram()` functions.

## Contents
The repository includes scripts examining:
1. Rolling-window calculations and input-order dependence.
2. Spectral frequency selection and harmonic retention.
3. Frequency reporting across different rolling-window lengths.
4. Input handling and chronological ordering.
5. DFC and HP calculations, including edge cases involving zero denominators.

## Requirements
- R
- `digiRhythm`
- `dplyr`
- `lubridate`

Install the required packages using:
```r
install.packages(c("digiRhythm", "dplyr", "lubridate"))
```

## Reproducibility
The scripts use package datasets and simulated activity time series to reproduce the computational tests described in the accompanying study.
The R version and package versions used for the analyses should be recorded using `sessionInfo()`.

## Citation
If you use these scripts, please cite the associated study and the archived software version where available.

## Contact
For questions about the scripts, please contact the corresponding author of the associated study.
