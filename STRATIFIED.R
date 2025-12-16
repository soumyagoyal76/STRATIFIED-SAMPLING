# ==============================================================================
# Project: Stratified Sampling Allocation Estimator
# Purpose: Determine sample size (n) and stratum allocation (nh) under:
#          1. Proportional Allocation
#          2. Neyman Allocation
#          3. Optimum Allocation (Cost/Time constrained)
# Author: SOUMYA GOYAL
# 1. Setup Data 

# Simulating a population with 4 Strata
# Nh: Stratum Size, Sh: Std Dev, Ch: Cost per unit, Th: Time per unit
strata_data <- data.frame(
  Stratum = c(1, 2, 3, 4),
  Nh = c(4000, 3000, 2000, 1000), # Population size per stratum
  Sh = c(10, 20, 30, 40),         # Standard deviation
  Ch = c(4, 6, 8, 10),            # Cost ($) per unit
  Th = c(1, 1.5, 2, 2.5)          # Time (hrs) per unit
)

# Global Parameters
N <- sum(strata_data$Nh)          # Total Population
E <- 1.5                          # Desired Margin of Error (Precision)
Z <- 1.96                         # Confidence Level (95%)
V_target <- (E / Z)^2             # Target Variance

# Calculate Weight (Wh)
strata_data$Wh <- strata_data$Nh / N

# ==============================================================================
# 2. Functions for Allocation 
# ==============================================================================

# --- Method A: Proportional Allocation ---
# Formula: nh = n * Wh
# n = Sum(Wh * Sh^2) / (V + (1/N)*Sum(Wh * Sh^2))
calc_proportional <- function(data, V, N) {
  numerator <- sum(data$Wh * data$Sh^2)
  denominator <- V + (1/N) * numerator
  n <- numerator / denominator
  
  data$n_prop <- round(n * data$Wh)
  return(list(n_total = ceiling(n), allocation = data[, c("Stratum", "n_prop")]))
}

# --- Method B: Neyman Allocation ---
# Formula: nh propto Nh * Sh
# n = (Sum(Wh * Sh))^2 / (V + (1/N)*Sum(Wh * Sh^2))
calc_neyman <- function(data, V, N) {
  numerator <- (sum(data$Wh * data$Sh))^2
  denominator <- V + (1/N) * sum(data$Wh * data$Sh^2)
  n <- numerator / denominator
  
  # Allocation weights
  alloc_weight <- (data$Nh * data$Sh) / sum(data$Nh * data$Sh)
  data$n_neyman <- round(n * alloc_weight)
  return(list(n_total = ceiling(n), allocation = data[, c("Stratum", "n_neyman")]))
}

# --- Method C: Optimum Allocation (Cost Based) ---
# Formula: nh propto (Nh * Sh) / sqrt(Ch)
# Minimizes total cost for a fixed Variance (V)
calc_optimum <- function(data, V, N) {
  # Term 1: Sum(Wh * Sh * sqrt(Ch))
  term1 <- sum(data$Wh * data$Sh * sqrt(data$Ch))
  # Term 2: Sum(Wh * Sh / sqrt(Ch))
  term2 <- sum(data$Wh * data$Sh / sqrt(data$Ch))
  
  numerator <- term1 * term2
  denominator <- V + (1/N) * sum(data$Wh * data$Sh^2)
  n <- numerator / denominator
  
  # Allocation weights
  numerator_h <- (data$Nh * data$Sh) / sqrt(data$Ch)
  alloc_weight <- numerator_h / sum(numerator_h)
  
  data$n_optimum <- round(n * alloc_weight)
  return(list(n_total = ceiling(n), allocation = data[, c("Stratum", "Ch", "n_optimum")]))
}

# 3. Execution & Output 

res_prop <- calc_proportional(strata_data, V_target, N)
res_neyman <- calc_neyman(strata_data, V_target, N)
res_opt <- calc_optimum(strata_data, V_target, N)

cat("\n=========================================\n")
cat("STRATIFIED SAMPLING ALLOCATION REPORT\n")
cat("=========================================\n")
cat("Parameters:\n")
cat(sprintf("Population (N): %d\nTarget Error (e): %.2f\nConfidence (Z): %.2f\n", N, E, Z))

cat("\n-----------------------------------------\n")
cat(sprintf("1. Proportional Allocation (Total n = %d)\n", res_prop$n_total))
print(res_prop$allocation, row.names = FALSE)

cat("\n-----------------------------------------\n")
cat(sprintf("2. Neyman Allocation (Total n = %d)\n", res_neyman$n_total))
print(res_neyman$allocation, row.names = FALSE)

cat("\n-----------------------------------------\n")
cat(sprintf("3. Optimum Allocation (Total n = %d)\n", res_opt$n_total))
cat("   *Optimized for variable Cost (Ch)*\n")
print(res_opt$allocation, row.names = FALSE)
cat("\n=========================================\n")
