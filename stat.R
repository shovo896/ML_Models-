# Install required package
install.packages("fastICA")

# Load libraries
library(fastICA)

set.seed(42)
samples <- 200
time <- seq(0, 8, length.out = samples)
signal_1 <- sin(2 * time)
signal_2 <- sign(sin(3 * time))
signal_3 <- rlaplace(samples) # Laplace distribution

# If rlaplace is not available, use:
signal_3 <- stats::rnorm(samples) # Or use another distribution

S <- cbind(signal_1, signal_2, signal_3)
S <- S + 0.2 * matrix(rnorm(length(S)), nrow=nrow(S))

A <- matrix(c(1, 1, 1, 0.5, 2, 1, 1.5, 1, 2), nrow=3, byrow=TRUE)
X <- S %*% t(A)

# Apply ICA
ica_result <- fastICA(X, n.comp=3)
S_ <- ica_result$S

# Visualize the signals
par(mfrow=c(3,1), mar=c(4,4,2,1))
plot(S, type='l', main='Original Signals')
plot(X, type='l', main='Observed Signals')
plot(S_, type='l', main='Estimated Sources (FastICA)')