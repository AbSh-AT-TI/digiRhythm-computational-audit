# 03_plot_lsp_argument_audit.R
# Audit of plot_lsp argument propagation in dfc()
#
# plot controls the overall dfc() plot, whereas plot_lsp is documented
# to control the individual Lomb-Scargle periodogram plots generated
# during rolling-window analysis.
#
# The calls below hold plot = FALSE and vary plot_lsp. If the internal
# LSP plots still appear when plot_lsp = FALSE, this demonstrates that
# the argument is not being propagated as documented.

library(digiRhythm)

data("df516b_2", package = "digiRhythm")

# Test with individual LSP plots requested
cat("Test 1: dfc() with plot = FALSE and plot_lsp = TRUE\n")
result_plot_lsp_true <- tryCatch(
  dfc(
    df516b_2,
    "Motion.Index",
    alpha = 0.05,
    harm_cutoff = 12,
    sampling = 12,
    plot = FALSE,
    plot_lsp = TRUE,
    verbose = FALSE
  ),
  error = function(e) {
    message("dfc() returned an error: ", conditionMessage(e))
    NULL
  }
)

# Test with individual LSP plots suppressed
cat("Test 2: dfc() with plot = FALSE and plot_lsp = FALSE\n")
result_plot_lsp_false <- tryCatch(
  dfc(
    df516b_2,
    "Motion.Index",
    alpha = 0.05,
    harm_cutoff = 12,
    sampling = 12,
    plot = FALSE,
    plot_lsp = FALSE,
    verbose = FALSE
  ),
  error = function(e) {
    message("dfc() returned an error: ", conditionMessage(e))
    NULL
  }
)

# Compare graphical output during the two calls.
# The expected documented behaviour is that the second call should not
# generate individual LSP plots.
#
# Record software environment
cat("\ndigiRhythm version:\n")
print(packageVersion("digiRhythm"))

cat("\nR session information:\n")
print(sessionInfo())
