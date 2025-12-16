# Stratified Sampling Allocation – R Implementation

## Overview
This repository contains an R implementation of stratified sampling used to estimate
the population mean. The project determines the required sample size and allocates
samples across strata using different allocation strategies.

The implementation applies finite population correction to ensure realistic variance
estimation for large but finite populations.

## Objectives
- To estimate the minimum sample size required for a specified level of precision
- To allocate samples across strata efficiently
- To compare classical and optimal stratified sampling methods
- To study the effect of cost and time on sampling design

## Stratified Sampling Concept
In stratified sampling, the population is divided into homogeneous groups called strata.
A separate sample is drawn from each stratum, and the overall estimate is obtained by
combining information from all strata.

This approach improves precision when variability within strata is low compared to
variability across strata.

## Precision and Sampling Bias
Sampling bias in this project refers to the allowable margin of error in estimating
the population mean.

The sample size is chosen such that the variability of the stratified sample mean
does not exceed the user-defined margin of error at a given confidence level.

## Allocation Methods Used

### 1. Proportional Allocation
Samples are allocated to each stratum in proportion to the stratum’s population size.
Larger strata receive more samples, while smaller strata receive fewer samples.

This method is simple and widely used when stratum variances are similar.

### 2. Neyman Allocation
Samples are allocated based on both stratum size and stratum variability.
Strata with higher variability receive more samples.

This method improves precision compared to proportional allocation when variances
differ significantly across strata.

### 3. Optimum Allocation (Cost-Based)
This method allocates samples by considering population size, variability, and
the cost of sampling in each stratum.

Strata that are cheaper to sample and more variable receive more observations.
The objective is to achieve the required precision at minimum total cost.

### 4. Optimum Allocation (Time-Based)
This method is similar to cost-based allocation but uses time required per observation
instead of monetary cost.

Strata that require less time to survey and have higher variability receive
more samples.

## Finite Population Correction
Since sampling is done without replacement from a finite population, finite population
correction is applied to adjust variance estimates and avoid overestimation of uncertainty.


## Implementation Details
- The program automatically determines the required total sample size
- Stratum-wise sample sizes are rounded and adjusted to maintain consistency
- Variance constraints are verified before finalizing the sample size


## Files Included
- `stratified_sampling.R` – R script implementing all allocation methods

## Author
**SOUMYA GOYAL**  
BSc Data Science & Statistics
CHRIST (DEEMED TO BE UNIVERSITY)

## Academic Note
This project was developed as part of coursework on stratified sampling techniques
and demonstrates practical implementation using R programming.
