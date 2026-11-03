# 02_spectral_truncation_frequency_audit.R
# Audit of harmonic retention and frequency reporting in digiRhythm
#
# The script uses the actual frequency grid and harmonic classifications
# returned by lomb_scargle_periodogram(). It then reproduces the fixed-bin
# truncation applied in dfc() and compares actual frequencies with the
# frequency labels assigned using (1:len)/7.

library(digiRhythm)

set.seed(123)

# 1. Analysis settings and simulated activity data
sampling <- 15
harm_cutoff <- 12
window_days <- c(7, 14)

samples_per_day <- 24 * 60 / sampling
n <- 14 * samples_per_day

dat14 <- data.frame(
  datetime = seq(
    from = as.POSIXct("2020-05-01 00:00:00", tz = "UTC"),
    by = "15 min",
    length.out = n
  ),
  Motion.Index = round(
    50 +
      20 * cos(2 * pi * (0:(n - 1)) / samples_per_day) +
      rnorm(n, mean = 0, sd = 5)
  )
)

cat("Dimensions of simulated 14-day recording:\n")
print(dim(dat14))
print(head(dat14))
print(tail(dat14))

# 2. Run the package's Lomb-Scargle implementation for each window length
run_lsp_audit <- function(window_days) {
  n_obs <- window_days * samples_per_day
  dat_window <- dat14[seq_len(n_obs), , drop = FALSE]

  lsp <- lomb_scargle_periodogram(
    data = dat_window,
    sampling = sampling,
    harm_cutoff = harm_cutoff,
    plot = FALSE
  )

  lsp_data <- lsp$lsp_data

  # Identify harmonic components classified by the package
  harmonic_bins <- which(lsp_data$status_harmonic == "Harmonic")
  harmonic_data <- lsp_data[harmonic_bins, , drop = FALSE]

  harmonic_frequency_cpd <- harmonic_data$frequency_hz * 86400
  harmonic_order <- round(24 / harmonic_data$period_hours)

  # Reproduce the frequency-bin limit used by dfc()
  retained_bins <- min(nrow(lsp_data), samples_per_day)

  harmonic_results <- data.frame(
    window_days = window_days,
    harmonic_order = harmonic_order,
    bin_position = harmonic_bins,
    frequency_cpd = harmonic_frequency_cpd,
    retained_by_dfc = harmonic_bins <= retained_bins
  )

  # Compare actual LSP frequencies with dfc()'s assigned frequency labels
  retained_index <- seq_len(retained_bins)

  frequency_results <- data.frame(
    window_days = window_days,
    bin_position = retained_index,
    actual_frequency_cpd =
      lsp_data$frequency_hz[retained_index] * 86400,
    dfc_reported_frequency_cpd = retained_index / 7
  )

  frequency_results$absolute_difference <- abs(
    frequency_results$actual_frequency_cpd -
      frequency_results$dfc_reported_frequency_cpd
  )

  list(
    lsp_data = lsp_data,
    harmonic_results = harmonic_results,
    frequency_results = frequency_results,
    retained_bins = retained_bins
  )
}

audit_results <- lapply(window_days, run_lsp_audit)
names(audit_results) <- paste0(window_days, "_days")

# 3. Compare retained and excluded harmonics
harmonic_comparison <- do.call(
  rbind,
  lapply(audit_results, function(x) x$harmonic_results)
)

harmonic_summary <- do.call(
  rbind,
  lapply(
    split(harmonic_comparison, harmonic_comparison$window_days),
    function(x) {
      window_label <- as.character(x$window_days[1])
      result <- audit_results[[paste0(window_label, "_days")]]

      data.frame(
        window_days = x$window_days[1],
        retained_bins = result$retained_bins,
        harmonics_retained = sum(x$retained_by_dfc),
        harmonics_excluded = sum(!x$retained_by_dfc),
        excluded_harmonics = paste(
          x$harmonic_order[!x$retained_by_dfc],
          collapse = ", "
        )
      )
    }
  )
)

cat("\nHarmonic classification and retention:\n")
print(harmonic_comparison)

cat("\nSummary of harmonic retention:\n")
print(harmonic_summary)

cat("\nHarmonics excluded by the reproduced dfc() truncation:\n")
print(subset(harmonic_comparison, !retained_by_dfc))

# 4. Examine frequency-reporting discrepancy
frequency_comparison <- do.call(
  rbind,
  lapply(audit_results, function(x) x$frequency_results)
)

frequency_summary <- do.call(
  rbind,
  lapply(
    split(frequency_comparison, frequency_comparison$window_days),
    function(x) {
      data.frame(
        window_days = x$window_days[1],
        retained_bins = nrow(x),
        highest_actual_frequency = max(x$actual_frequency_cpd),
        highest_reported_frequency = max(x$dfc_reported_frequency_cpd),
        maximum_absolute_difference = max(x$absolute_difference)
      )
    }
  )
)

cat("\nSummary of frequency-label discrepancies:\n")
print(frequency_summary)

cat("\nFirst 15 retained frequency bins:\n")
print(head(frequency_comparison, 15))

cat("\nLast 10 retained frequency bins:\n")
print(tail(frequency_comparison, 10))

# 5. Verify expected results for this simulated dataset
# These checks are intended to fail visibly if package behaviour changes.
harmonic_counts <- table(harmonic_comparison$window_days)

stopifnot(all(harmonic_counts == harm_cutoff))

stopifnot(
  sum(
    harmonic_comparison$retained_by_dfc[
      harmonic_comparison$window_days == 7
    ]
  ) == 12
)

stopifnot(
  sum(
    harmonic_comparison$retained_by_dfc[
      harmonic_comparison$window_days == 14
    ]
  ) == 6
)

# 6. Record software environment
cat("\ndigiRhythm version:\n")
print(packageVersion("digiRhythm"))

cat("\nR session information:\n")
print(sessionInfo())
