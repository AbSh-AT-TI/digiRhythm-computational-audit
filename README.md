# Computational Audit of the digiRhythm R Package

This repository contains R scripts accompanying a computational audit of the
`digiRhythm` package, focusing on `dfc()` and `lomb_scargle_periodogram()`.

## Contents

| Script | Purpose |
|---|---|
| `R/01_rolling_window_audit.R` | Tests the seven-day boundary case and compares expected and implemented rolling-window counts. |
| `R/02_spectral_truncation_frequency_audit.R` | Examines harmonic retention and frequency reporting for seven- and 14-day windows. |
| `R/03_plot_lsp_argument_audit.R` | Tests whether `plot_lsp` controls individual periodogram plots generated within `dfc()`. |
| `R/04_DFC_HP_zero_denominator_example.R` | Illustrates the arithmetic behaviour of DFC and HP when denominators are zero. |
| `R/05_ratio_plot_label_audit.R` | Generates the package plot for inspection of proportion/percentage labelling. |

## Requirements

The scripts use R and the following packages:

- `digiRhythm`
- `dplyr`
- `lubridate`

Install the packages with:

```r
install.packages(c("digiRhythm", "dplyr", "lubridate"))
```

Run each script from a fresh R session. Some scripts generate plots or intentionally
exercise edge cases. The first script catches and reports an error from `dfc()` so
that the remaining checks in that script can still be completed.

## Reproducibility notes

- The spectral audit uses simulated activity data with `set.seed(123)`.
- The rolling-window script uses the package dataset `df516b_2`.
- The DFC/HP zero-denominator script is an independent arithmetic illustration;
  it does not independently validate the package's significance-testing algorithm.
- The plotting scripts require visual inspection of the generated output.
- Package behaviour may change across `digiRhythm` versions. The scripts print
  `packageVersion("digiRhythm")` and `sessionInfo()` to record the environment.

## Citation

If you use or refer to these scripts, please cite the associated manuscript:
A Computational Audit of DFC and Lomb–Scargle Spectral Analysis in the digiRhythm R Package.

A full bibliographic reference and permanent DOI will be added once the manuscript is published and the code is archived.

## Licence

No licence has been assigned to this repository at present. Please contact the repository author for permission before reusing or redistributing the scripts.
