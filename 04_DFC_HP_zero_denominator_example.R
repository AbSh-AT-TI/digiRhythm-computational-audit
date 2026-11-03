# 04_DFC_HP_zero_denominator_example.R
# Illustration of undefined DFC and HP values when denominators are zero
#
# This is an independent arithmetic example illustrating the ratio
# calculations. It is not a claim that dfc() itself was run on this
# manually constructed power vector.

power <- c(0.20, 0.10, 0.05)
significant <- c(FALSE, FALSE, FALSE)
harmonic <- c(TRUE, FALSE, TRUE)

ssh <- sum(power[significant & harmonic])
sumsig <- sum(power[significant])
sumall <- sum(power)

DFC <- ssh / sumsig
HP <- ssh / sumall

c(
  ssh = ssh,
  sumsig = sumsig,
  sumall = sumall,
  DFC = DFC,
  HP = HP
)

# Expected arithmetic outcome:
# ssh = 0, sumsig = 0, sumall = 0.35
# DFC = NaN (0/0), HP = 0 (0/0.35)

# Additional case: no spectral power at all
zero_power <- c(0, 0, 0)
zero_significant <- c(FALSE, FALSE, FALSE)
zero_harmonic <- c(TRUE, FALSE, TRUE)

ssh_zero <- sum(zero_power[zero_significant & zero_harmonic])
sumsig_zero <- sum(zero_power[zero_significant])
sumall_zero <- sum(zero_power)

DFC_zero <- ssh_zero / sumsig_zero
HP_zero <- ssh_zero / sumall_zero

c(
  ssh = ssh_zero,
  sumsig = sumsig_zero,
  sumall = sumall_zero,
  DFC = DFC_zero,
  HP = HP_zero
)
