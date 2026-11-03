# 01_rolling_window_audit.R
# Computational audit of rolling-window coverage in digiRhythm
#
# This script:
# (1) tests dfc() using exactly one seven-day period from the built-in dataset;
# (2) compares the expected rolling-window count with the count implied by
#     the current implementation.
#
# Note: The first seven calendar days of df516b_2 may contain missing
# observations. This is a test of the package's behaviour on that extracted
# interval, not a claim that the interval contains 672 observations.

# Install required packages if necessary:
# install.packages(c("digiRhythm", "dplyr", "lubridate"))

library(digiRhythm)
library(dplyr)
library(lubridate)

data("df516b_2", package = "digiRhythm")

# 1(a). Extract the first seven calendar days of the dataset
first_day <- as.Date(df516b_2$datetime[1])

dat_W1 <- df516b_2 %>%
  select(1:2) %>%
  filter(
    as.Date(datetime) >= first_day,
    as.Date(datetime) < first_day + 7
  )

# Inspect the extracted interval
cat("Rows in extracted seven-day interval:", nrow(dat_W1), "\n")
cat("Expected rows for complete 15-minute sampling:", 7 * 24 * 4, "\n")
cat("First timestamp:", as.character(min(dat_W1$datetime)), "\n")
cat("Last timestamp:", as.character(max(dat_W1$datetime)), "\n")

# Apply dfc(). Depending on the package version and input, this call may
# return an error. The tryCatch() wrapper records the error and allows the
# remainder of the script to run.
res <- tryCatch(
  dfc(
    dat_W1,
    "Motion.Index",
    sampling = 15,
    alpha = 0.05,
    rolling_window = 7,
    plot = FALSE,
    plot_lsp = FALSE,
    verbose = FALSE
  ),
  error = function(e) {
    message("dfc() returned an error: ", conditionMessage(e))
    NULL
  }
)

# 1(b). Compare expected and implemented rolling-window counts
window_check <- data.frame(
  recording_days = c(7, 8, 14, 45),
  rolling_window = 7
)

# For D consecutive calendar days and a W-day window, the expected number
# of complete windows is D - W + 1.
window_check$expected_windows <-
  window_check$recording_days -
  window_check$rolling_window + 1

# This reproduces the expression identified in the audited implementation.
window_check$implemented_windows <-
  window_check$recording_days -
  window_check$rolling_window - 1

print(window_check)

# Record software environment
cat("\n digiRhythm version:\n")
print(packageVersion("digiRhythm"))
cat("\n R session information:\n")
print(sessionInfo())
