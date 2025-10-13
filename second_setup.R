
options(repos = c(CRAN = "https://cloud.r-project.org"))

# ---- 2. Define function to auto-install packages ----
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# ---- 3. Load required packages ----
packages <- c("ggplot2", "dplyr", "tidyr", "readr", "corrplot")
lapply(packages, install_if_missing)

# ---- 4. Load Dataset ----
# Update the path if your data file is different
data_path <- "dataset.csv"  # change this to your actual CSV file name
if (!file.exists(data_path)) {
  cat("⚠️ Dataset not found at:", data_path, "\n")
  quit(status = 1)
}
data <- read_csv(data_path)

# ---- 5. Basic Summary Statistics ----
cat("\n===== Summary Statistics =====\n")
print(summary(data))
cat("\nNumber of Rows:", nrow(data), "\n")
cat("Number of Columns:", ncol(data), "\n")

# ---- 6. Correlation Matrix ----
numeric_data <- dplyr::select_if(data, is.numeric)
if (ncol(numeric_data) > 1) {
  corr_matrix <- cor(numeric_data, use = "complete.obs")
  cat("\n===== Correlation Matrix =====\n")
  print(round(corr_matrix, 3))
  
  # Optional: visualize correlation
  corrplot(corr_matrix, method = "color", type = "upper", tl.cex = 0.8)
} else {
  cat("\n(No numeric columns found for correlation)\n")
}

# ---- 7. Example Visualization ----
cat("\n===== Generating Example Plot =====\n")

# Check if there are at least two numeric columns
if (ncol(numeric_data) >= 2) {
  plot_file <- "plot_output.png"
  ggplot(numeric_data, aes(x = .data[[names(numeric_data)[1]]], 
                           y = .data[[names(numeric_data)[2]]])) +
    geom_point(color = "blue", alpha = 0.6) +
    ggtitle("Sample Scatter Plot") +
    theme_minimal()
  
  ggsave(plot_file)
  cat("✅ Plot saved as:", plot_file, "\n")
} else {
  cat("⚠️ Not enough numeric data for plotting.\n")
}

cat("\n===== Script Completed Successfully =====\n")
