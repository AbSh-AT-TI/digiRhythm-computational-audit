# 05_ratio_plot_label_audit.R
# Inspection of DFC and HP plotting scale/axis labels
#
# DFC and HP are ratios on a 0-1 scale. This script generates the package
# output for visual inspection of whether the plotted axis is labelled
# "Percentage" while the values remain proportions.
#
# Inspect the resulting plot: a value of 0.8 represents 80%, not 0.8%.

library(digiRhythm)

data("df516b_2", package = "digiRhythm")

result <- dfc(
  df516b_2,
  "Motion.Index",
  alpha = 0.05,
  harm_cutoff = 12,
  sampling = 12,
  plot = TRUE,
  plot_lsp = FALSE,
  verbose = FALSE
)

# Inspect the returned object and plot labels, where available
print(result)
str(result)

# Record software environment
cat("\ndigiRhythm version:\n")
print(packageVersion("digiRhythm"))

cat("\nR session information:\n")
print(sessionInfo())
